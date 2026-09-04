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
            -- C++-specific captures keep the structure of a program visible:
            -- declarations/types are different from calls and local data.
            ["@function.cpp"] = { fg = colors.green, bold = true },
            ["@function.call.cpp"] = { fg = colors.blue },
            ["@function.method.cpp"] = { fg = colors.teal },
            ["@function.method.call.cpp"] = { fg = colors.sapphire },
            ["@type.cpp"] = { fg = colors.yellow },
            ["@type.builtin.cpp"] = { fg = colors.teal },
            ["@type.definition.cpp"] = { fg = colors.peach, bold = true },
            ["@variable.parameter.cpp"] = { fg = colors.lavender },
            ["@variable.member.cpp"] = { fg = colors.flamingo },
            ["@property.cpp"] = { fg = colors.rosewater },
            ["@constant.cpp"] = { fg = colors.peach },
            ["@constant.builtin.cpp"] = { fg = colors.maroon },
            ["@module.cpp"] = { fg = colors.sapphire },
            ["@variable.stream.cpp"] = { fg = colors.peach },
            ["@variable.container.cpp"] = { fg = colors.sapphire },
          }
        end,
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
