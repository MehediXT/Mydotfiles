local options = {
  base46 = {
    theme = "kanagawa",
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
        -- 	bg = "black",
        fg = "blue",
        bold = true,
      },
      TbFill = {
        bg = "NONE",
      },
      ["@ibl.scope.underline.1"] = { underline = false },
      ["@ibl.scope.underline"] = { underline = false },
      ["@type.builtin"] = { italic = true },
      ["@constant.macro"] = { bold = true },
    },
    transparency = false,
    theme_toggle = { "kanagawa", "kanagawa" },
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
