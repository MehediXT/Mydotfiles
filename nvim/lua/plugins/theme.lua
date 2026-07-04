return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,

    config = function()
      require("catppuccin").setup({
        flavour = "mocha",

        integrations = {
          treesitter = true,
          cmp = true,
        },

        custom_highlights = function(colors)
          return {
            -- Control flow
            ["@keyword.cpp"] = { fg = colors.mauve, italic = true, bold = true },
            ["@keyword.repeat.cpp"] = { fg = colors.mauve, italic = true },
            ["@keyword.conditional.cpp"] = { fg = colors.pink, italic = true },
            ["@keyword.return.cpp"] = { fg = colors.red, bold = true },

            -- Type-related keywords (class, namespace, template, using)
            ["@keyword.type.cpp"] = { fg = colors.lavender, italic = true, bold = true },
            ["@keyword.modifier.cpp"] = { fg = colors.flamingo, italic = true },

            -- Includes / imports
            ["@keyword.import.cpp"] = { fg = colors.blue, bold = true },

            -- Built-in types (int, char, void, bool, auto)
            ["@type.builtin.cpp"] = { fg = colors.peach, bold = true },

            -- User / STL types (vector, string, pair)
            ["@type.cpp"] = { fg = colors.yellow, bold = true },

            -- Functions
            ["@function.cpp"] = { fg = colors.green, bold = true },
            ["@function.call.cpp"] = { fg = colors.teal },
            ["@function.method.cpp"] = { fg = colors.green },
            ["@function.method.call.cpp"] = { fg = colors.teal },

            -- Namespaces / modules
            ["@namespace.cpp"] = { fg = colors.sky, bold = true },
            ["@module.cpp"] = { fg = colors.sky },

            -- Values
            ["@constant.cpp"] = { fg = colors.peach, bold = true },
            ["@constant.builtin.cpp"] = { fg = colors.peach },
            ["@number.cpp"] = { fg = colors.peach },
            ["@string.cpp"] = { fg = colors.green },

            -- Operators / punctuation
            ["@operator.cpp"] = { fg = colors.sky },
            ["@punctuation.delimiter.cpp"] = { fg = colors.overlay2 },

            -- Variables
            ["@variable.cpp"] = { fg = colors.text },
            ["@variable.parameter.cpp"] = { fg = colors.maroon, italic = true },
          }
        end,
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
