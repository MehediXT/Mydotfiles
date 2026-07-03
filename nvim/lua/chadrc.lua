local options = {
  base46 = {
    theme = "ashes",
    hl_override = {
      Include = {
        bold = true,
        italic = true,
      },
      Macro = {
        bold = true,
        italic = true,
      },
      PreProc = {
        bold = true,
        italic = true,
      },
      Comment = {
        italic = true,
      },
      Type = {
        italic = true,
      },
      Boolean = {
        italic = true,
      },
      Number = {
        italic = true,
      },
      NvDashAscii = {
        bg = "blue",
        fg = "black",
      },
      NvDashButtons = {
        --  bg = "black",
        fg = "blue",
        bold = true,
      },
      TbFill = {
        bg = "NONE",
      },
      ["@type"] = { fg = "#89b4fa", bold = true },
      ["@type.definition"] = { fg = "#b4befe", bold = true },
      ["@type.builtin"] = { italic = true },
      ["@function"] = { fg = "#a6e3a1", bold = true },
      ["@function.call"] = { fg = "#a6e3a1" },
      ["@function.method"] = { fg = "#94e2d5", bold = true },
      ["@function.method.call"] = { fg = "#94e2d5" },
      ["@constructor"] = { fg = "#fab387", bold = true },
      ["@module"] = { fg = "#cba6f7", bold = true },
      ["@variable.member"] = { fg = "#89dceb" },
      ["@property"] = { fg = "#89dceb" },
      ["@constant"] = { fg = "#f9e2af", bold = true },
      ["@constant.macro"] = { bold = true },
      ["@keyword"] = { fg = "#cba6f7", bold = true },
      ["@keyword.function"] = { fg = "#cba6f7", bold = true },
      ["@operator"] = { fg = "#89b4fa" },
      ["@punctuation.delimiter"] = { fg = "#6c7086" },
      ["@punctuation.bracket"] = { fg = "#6c7086" },
    },
    transparency = false,
  },

  ui = {
    cmp = {
      icons = true,
      lspkind_text = true,
      style = "default", -- default/flat_light/flat_dark/atom/atom_colored
      format_colors = {
        tailwind = true, -- will work for css lsp too
        icon = "󱓻",
      },
    },

    telescope = { style = "bordered" }, -- borderless / bordered

    statusline = {
      theme = "minimal", -- default/vscode/vscode_colored/minimal
      -- default/round/block/arrow separators work only for default statusline theme
      -- round and block will work for minimal theme only
      separator_style = "block",
      order = nil,
      modules = nil,
    },
  },

  nvdash = {
    load_on_startup = true,

    header = {
      "                                   ",
      "            ▄ ▄                    ",
      "        ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄      ",
      "        █ ▄ █▄█ ▄▄▄ █ █▄█ █ █      ",
      "     ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █      ",
      "   ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄   ",
      "   █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄ ",
      " ▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █ ",
      " █▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █ ",
      "     █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█     ",
      "                                   ",
    },

    buttons = {
      { txt = " ", hl = "NvDashButtons", no_gap = true, rep = true },
      { txt = "  Find File", keys = "Spc f f", cmd = "Telescope find_files" },
      { txt = "  Recent Files", keys = "Spc f o", cmd = "Telescope oldfiles" },
      { txt = "󰈭  Find Word", keys = "Spc f w", cmd = "Telescope live_grep" },
      { txt = "  Bookmarks", keys = "Spc m a", cmd = "Telescope marks" },
      { txt = "  Themes", keys = "Spc t h", cmd = ":lua require('nvchad.themes').open()" },
      { txt = "  Mappings", keys = "Spc c h", cmd = "NvCheatsheet" },
    },
  },

  mason = {
    cmd = true,
    pkgs = {
      "autoflake",
      "black",
      "clangd",
      "css-lsp",
      "goimports",
      "golines",
      "gopls",
      "html-lsp",
      "isort",
      "lua-language-server",
      "prettier",
      "python-lsp-server",
      "stylua",
    },
  },
}

local status, chadrc = pcall(require, "chadrc")
return vim.tbl_deep_extend("force", options, status and chadrc or {})
