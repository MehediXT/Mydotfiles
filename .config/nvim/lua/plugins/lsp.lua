return {
  "neovim/nvim-lspconfig",
  config = function()
    -- Load NvChad defaults first
    require("nvchad.configs.lspconfig").defaults()

    local function project_python(root_dir)
      if type(root_dir) == "string" then
        for _, relative_path in ipairs { ".venv/bin/python", "venv/bin/python", "env/bin/python" } do
          local candidate = vim.fs.joinpath(root_dir, relative_path)
          if vim.fn.executable(candidate) == 1 then
            return candidate
          end
        end
      end

      if vim.env.VIRTUAL_ENV then
        local active_python = vim.fs.joinpath(vim.env.VIRTUAL_ENV, "bin", "python")
        if vim.fn.executable(active_python) == 1 then
          return active_python
        end
      end
    end

    local function is_django_project(root_dir)
      return type(root_dir) == "string"
        and vim.uv.fs_stat(vim.fs.joinpath(root_dir, "manage.py")) ~= nil
    end

    local function has_project_ruff_config(root_dir)
      if type(root_dir) ~= "string" then
        return false
      end

      for _, filename in ipairs { "ruff.toml", ".ruff.toml" } do
        if vim.uv.fs_stat(vim.fs.joinpath(root_dir, filename)) then
          return true
        end
      end

      local pyproject = vim.fs.joinpath(root_dir, "pyproject.toml")
      if not vim.uv.fs_stat(pyproject) then
        return false
      end

      local ok, lines = pcall(vim.fn.readfile, pyproject)
      if not ok then
        return false
      end

      return vim.iter(lines):any(function(line)
        return line:match("^%s*%[tool%.ruff[%].]") ~= nil
      end)
    end

    -- Django adds these model-class attributes dynamically. BasedPyright cannot
    -- infer them without framework-specific runtime knowledge, so its static
    -- reportAttributeAccessIssue diagnostics are false positives. Filter only
    -- those exact attributes, and only for projects rooted by manage.py; keep
    -- every other attribute-access diagnostic, including normal Python typos.
    local django_model_attributes = {
      "objects",
      "DoesNotExist",
      "MultipleObjectsReturned",
    }

    local function is_django_model_attribute_diagnostic(diagnostic)
      local code = diagnostic.code
      if type(code) == "table" then
        code = code.value
      end

      if code ~= "reportAttributeAccessIssue" then
        return false
      end

      local message = diagnostic.message or ""
      if not message:find("for class", 1, true) then
        return false
      end

      for _, attribute in ipairs(django_model_attributes) do
        if message:find('attribute "' .. attribute .. '"', 1, true) then
          return true
        end
      end

      return false
    end

    local default_publish_diagnostics = vim.lsp.handlers["textDocument/publishDiagnostics"]

    local function publish_python_diagnostics(err, result, ctx, config)
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      if
        client
        and is_django_project(client.root_dir)
        and result
        and type(result.diagnostics) == "table"
      then
        local diagnostics = vim.tbl_filter(function(diagnostic)
          if client.name == "basedpyright" then
            return not is_django_model_attribute_diagnostic(diagnostic)
          end

          return true
        end, result.diagnostics)

        result = vim.tbl_extend("force", result, { diagnostics = diagnostics })
      end

      return default_publish_diagnostics(err, result, ctx, config)
    end

    -- clangd can accidentally select a newer, incomplete GCC directory when
    -- several GCC versions are installed. Derive the install directory from
    -- the same g++ executable used to submit solutions so libstdc++ and
    -- bits/stdc++.h are always indexed correctly.
    local clangd_fallback_flags = {
      "-std=gnu++17",
      "-Wall",
      "-Wextra",
      "-Wshadow",
    }

    if vim.fn.executable "g++" == 1 then
      local target = vim.trim(vim.fn.system { "g++", "-dumpmachine" })
      local version = vim.trim(vim.fn.system { "g++", "-dumpfullversion" }):match "^%d+"
      local gcc_install = version and vim.fs.joinpath("/usr/lib/gcc", target, version) or nil

      if gcc_install and vim.uv.fs_stat(gcc_install) then
        table.insert(clangd_fallback_flags, "--gcc-install-dir=" .. gcc_install)
      end
    end

    vim.lsp.config("clangd", {
      cmd = {
        "clangd",
        "--background-index",
        "--completion-style=detailed",
        "--all-scopes-completion",
        "--function-arg-placeholders",
        "--header-insertion=never",
        "--clang-tidy=false",
        "--query-driver=/usr/bin/g++,/usr/bin/g++-*,/usr/bin/*-g++",
      },
      init_options = {
        fallbackFlags = clangd_fallback_flags,
      },
    })

    -- BasedPyright supplies Python/Django completion and type checking. Point it
    -- at a project-local virtualenv first so Django and installed app imports
    -- resolve without hard-coding a machine-specific path.
    vim.lsp.config("basedpyright", {
      root_markers = {
        "manage.py",
        "pyrightconfig.json",
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        ".git",
      },
      before_init = function(_, config)
        local python = project_python(config.root_dir)
        if python then
          config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
            python = { pythonPath = python },
          })
        end
      end,
      on_init = function(client)
        -- Neovim snapshots client.settings before before_init runs. Copy the
        -- discovered interpreter into that snapshot and notify BasedPyright so
        -- the project virtualenv is used immediately.
        client.settings = vim.tbl_deep_extend("force", client.settings or {}, client.config.settings or {})
        client:notify("workspace/didChangeConfiguration", { settings = client.settings })
      end,
      settings = {
        basedpyright = {
          -- Ruff is the single import organizer, avoiding competing edits from
          -- two Python language servers during save.
          disableOrganizeImports = true,
          analysis = {
            autoImportCompletions = true,
            diagnosticMode = "openFilesOnly",
            typeCheckingMode = "basic",
          },
        },
      },
      handlers = {
        ["textDocument/publishDiagnostics"] = publish_python_diagnostics,
      },
    })

    vim.lsp.config("ruff", {
      root_markers = { "manage.py", "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
      before_init = function(params, config)
        if not is_django_project(config.root_dir) then
          return
        end

        -- Django and DRF intentionally use mutable class attributes as
        -- declarative metadata. Ignore RUF012 only in conventional framework
        -- modules. Files outside Django roots, including competitive-programming
        -- Python, retain Ruff's normal diagnostics.
        if has_project_ruff_config(config.root_dir) then
          return
        end

        -- Neovim has already copied config.init_options into the initialize
        -- request before this hook runs, so update the request payload itself.
        params.initializationOptions = vim.tbl_deep_extend("force", params.initializationOptions or {}, {
          settings = {
            configuration = vim.fs.joinpath(vim.fn.stdpath("config"), "ruff-django.toml"),
          },
        })
      end,
      init_options = {
        settings = {
          organizeImports = true,
          fixAll = true,
        },
      },
    })

    vim.lsp.config("djlsp", {
      root_markers = { "manage.py", "pyproject.toml", ".git" },
    })

    vim.lsp.config("html", {
      filetypes = { "html", "htmldjango" },
    })

    -- Universal fallback hook that turns off semantic tokens right as any client attaches
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "clangd" then
          client.server_capabilities.semanticTokensProvider = nil
        end

        -- BasedPyright provides the richer hover result. Ruff remains active
        -- for its fast diagnostics and code actions.
        if client and client.name == "ruff" then
          client.server_capabilities.hoverProvider = false
        end

        local function lsp_map(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, {
            buffer = args.buf,
            silent = true,
            desc = "LSP " .. desc,
          })
        end

        lsp_map("K", vim.lsp.buf.hover, "Hover documentation")
        lsp_map("gr", vim.lsp.buf.references, "References")
        lsp_map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        lsp_map("<leader>e", vim.diagnostic.open_float, "Line diagnostics")
        lsp_map("[d", function()
          vim.diagnostic.jump { count = -1, float = true }
        end, "Previous diagnostic")
        lsp_map("]d", function()
          vim.diagnostic.jump { count = 1, float = true }
        end, "Next diagnostic")
      end,
    })

    -- Enable all your servers cleanly in one single batch
    local servers = {
      "html",
      "cssls",
      "ts_ls",
      "clangd",
      "lua_ls",
      "biome",
      "gopls",
      "ruff",
      "prismals",
      "taplo",
      "jdtls",
      "basedpyright",
      "djlsp",
    }
    vim.lsp.enable(servers)
  end,
}
