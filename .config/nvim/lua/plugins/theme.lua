return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,

    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,

        integrations = {
          treesitter = true,
          cmp = true,
        },

        custom_highlights = function(colors)
          return {
            -- Keep Catppuccin defaults, with a few focused C++ distinctions.
            ["@variable.stream.cpp"] = { fg = colors.peach },
            ["@variable.container.cpp"] = { fg = colors.sapphire },
            ["@variable.cpp"] = { fg = "#c46f7b" },
            ["@lsp.type.variable.cpp"] = { fg = "#c46f7b" },
          }
        end,
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
