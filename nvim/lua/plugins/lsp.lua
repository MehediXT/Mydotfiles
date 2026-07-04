return {
  "neovim/nvim-lspconfig",
  config = function()
    -- Load NvChad defaults first
    require("nvchad.configs.lspconfig").defaults()

    vim.lsp.config("clangd", {
      cmd = {
        "clangd",
        "--header-insertion=never",
        "--clang-tidy=false",
      },
      init_options = {
        fallbackFlags = {
          "-std=c++17",
          "-I/usr/include/c++/13",
          "-I/usr/include/x86_64-linux-gnu/c++/13",
          "-I/usr/lib/gcc/x86_64-linux-gnu/13/include",
        },
      },
    })

    -- Universal fallback hook that turns off semantic tokens right as any client attaches
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "clangd" then
          client.server_capabilities.semanticTokensProvider = nil
        end
      end,
    })

    -- Enable all your servers cleanly in one single batch
    local servers = {
      "html",
      "cssls",
      "clangd",
      "lua_ls",
      "biome",
      "gopls",
      "ruff",
      "prismals",
      "taplo",
      "jdtls",
    }
    vim.lsp.enable(servers)
  end,
}
