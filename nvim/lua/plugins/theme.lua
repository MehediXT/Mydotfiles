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

            -- Python
            ["@keyword.python"] = { fg = colors.mauve, italic = true, bold = true },
            ["@keyword.return.python"] = { fg = colors.red, bold = true },
            ["@keyword.function.python"] = { fg = colors.blue, italic = true },
            ["@keyword.conditional.python"] = { fg = colors.pink, italic = true },
            ["@type.builtin.python"] = { fg = colors.peach, bold = true },
            ["@function.python"] = { fg = colors.green, bold = true },
            ["@function.call.python"] = { fg = colors.teal },
            ["@module.python"] = { fg = colors.sky, bold = true },
            ["@constant.builtin.python"] = { fg = colors.peach },
            ["@string.python"] = { fg = colors.green },
            ["@number.python"] = { fg = colors.peach },
            ["@variable.python"] = { fg = colors.lavender },
            ["@variable.parameter.python"] = { fg = colors.maroon, italic = true },

            -- HTML
            ["@tag.html"] = { fg = colors.blue, bold = true },
            ["@tag.attribute.html"] = { fg = colors.yellow, italic = true },
            ["@tag.delimiter.html"] = { fg = colors.overlay2 },
            ["@operator.html"] = { fg = colors.sky },
            ["@string.html"] = { fg = colors.green },
            ["@string.special.url.html"] = { fg = colors.teal, underline = true },
            ["@character.special.html"] = { fg = colors.peach },

            -- CSS
            ["@keyword.directive.css"] = { fg = colors.mauve, bold = true },
            ["@keyword.import.css"] = { fg = colors.blue, bold = true },
            ["@keyword.modifier.css"] = { fg = colors.red, bold = true },
            ["@tag.css"] = { fg = colors.blue },
            ["@type.css"] = { fg = colors.yellow, bold = true },
            ["@type.tag.css"] = { fg = colors.blue },
            ["@constant.css"] = { fg = colors.peach, bold = true },
            ["@property.css"] = { fg = colors.sky },
            ["@property.class.css"] = { fg = colors.yellow, bold = true },
            ["@property.id.css"] = { fg = colors.peach, bold = true },
            ["@attribute.css"] = { fg = colors.mauve, italic = true },
            ["@tag.attribute.css"] = { fg = colors.yellow },
            ["@function.css"] = { fg = colors.teal },
            ["@module.css"] = { fg = colors.lavender },
            ["@variable.css"] = { fg = colors.flamingo },
            ["@string.css"] = { fg = colors.green },
            ["@string.plain.css"] = { fg = colors.green },
            ["@number.css"] = { fg = colors.peach },
            ["@number.float.css"] = { fg = colors.peach },
            ["@operator.css"] = { fg = colors.sky },
            ["@punctuation.delimiter.css"] = { fg = colors.overlay2 },
            ["@punctuation.bracket.css"] = { fg = colors.surface2 },

            -- JavaScript and JSX/React
            ["@keyword.javascript"] = { fg = colors.mauve, italic = true, bold = true },
            ["@keyword.function.javascript"] = { fg = colors.blue, italic = true },
            ["@keyword.coroutine.javascript"] = { fg = colors.mauve, italic = true },
            ["@keyword.operator.javascript"] = { fg = colors.mauve },
            ["@keyword.exception.javascript"] = { fg = colors.red, italic = true },
            ["@keyword.return.javascript"] = { fg = colors.red, bold = true },
            ["@keyword.import.javascript"] = { fg = colors.blue, bold = true },
            ["@keyword.export.javascript"] = { fg = colors.blue, bold = true },
            ["@keyword.conditional.javascript"] = { fg = colors.pink, italic = true },
            ["@keyword.conditional.ternary.javascript"] = { fg = colors.pink },
            ["@keyword.repeat.javascript"] = { fg = colors.mauve, italic = true },
            ["@type.javascript"] = { fg = colors.yellow, bold = true },
            ["@type.builtin.javascript"] = { fg = colors.peach, bold = true },
            ["@function.javascript"] = { fg = colors.green, bold = true },
            ["@function.call.javascript"] = { fg = colors.teal },
            ["@function.method.javascript"] = { fg = colors.green },
            ["@function.method.call.javascript"] = { fg = colors.teal },
            ["@constructor.javascript"] = { fg = colors.yellow, bold = true },
            ["@module.javascript"] = { fg = colors.sky, bold = true },
            ["@module.builtin.javascript"] = { fg = colors.sky },
            ["@constant.javascript"] = { fg = colors.peach, bold = true },
            ["@constant.builtin.javascript"] = { fg = colors.peach },
            ["@boolean.javascript"] = { fg = colors.peach, italic = true },
            ["@string.javascript"] = { fg = colors.green },
            ["@number.javascript"] = { fg = colors.peach },
            ["@variable.javascript"] = { fg = colors.text },
            ["@variable.parameter.javascript"] = { fg = colors.maroon, italic = true },
            ["@variable.member.javascript"] = { fg = colors.lavender },
            ["@variable.builtin.javascript"] = { fg = colors.flamingo, italic = true },
            ["@operator.javascript"] = { fg = colors.sky },
            ["@punctuation.delimiter.javascript"] = { fg = colors.overlay2 },
            ["@punctuation.bracket.javascript"] = { fg = colors.surface2 },
            ["@tag.javascript"] = { fg = colors.yellow, bold = true },
            ["@tag.builtin.javascript"] = { fg = colors.blue },
            ["@tag.attribute.javascript"] = { fg = colors.yellow, italic = true },
            ["@tag.delimiter.javascript"] = { fg = colors.overlay2 },

            -- TypeScript
            ["@keyword.typescript"] = { fg = colors.mauve, italic = true, bold = true },
            ["@keyword.function.typescript"] = { fg = colors.blue, italic = true },
            ["@keyword.coroutine.typescript"] = { fg = colors.mauve, italic = true },
            ["@keyword.operator.typescript"] = { fg = colors.mauve },
            ["@keyword.exception.typescript"] = { fg = colors.red, italic = true },
            ["@keyword.type.typescript"] = { fg = colors.lavender, italic = true, bold = true },
            ["@keyword.modifier.typescript"] = { fg = colors.flamingo, italic = true },
            ["@keyword.return.typescript"] = { fg = colors.red, bold = true },
            ["@keyword.import.typescript"] = { fg = colors.blue, bold = true },
            ["@keyword.export.typescript"] = { fg = colors.blue, bold = true },
            ["@keyword.conditional.typescript"] = { fg = colors.pink, italic = true },
            ["@keyword.conditional.ternary.typescript"] = { fg = colors.pink },
            ["@keyword.repeat.typescript"] = { fg = colors.mauve, italic = true },
            ["@type.typescript"] = { fg = colors.yellow, bold = true },
            ["@type.builtin.typescript"] = { fg = colors.peach, bold = true },
            ["@function.typescript"] = { fg = colors.green, bold = true },
            ["@function.call.typescript"] = { fg = colors.teal },
            ["@function.method.typescript"] = { fg = colors.green },
            ["@function.method.call.typescript"] = { fg = colors.teal },
            ["@constructor.typescript"] = { fg = colors.yellow, bold = true },
            ["@module.typescript"] = { fg = colors.sky, bold = true },
            ["@module.builtin.typescript"] = { fg = colors.sky },
            ["@constant.typescript"] = { fg = colors.peach, bold = true },
            ["@constant.builtin.typescript"] = { fg = colors.peach },
            ["@boolean.typescript"] = { fg = colors.peach, italic = true },
            ["@string.typescript"] = { fg = colors.green },
            ["@number.typescript"] = { fg = colors.peach },
            ["@variable.typescript"] = { fg = colors.text },
            ["@variable.parameter.typescript"] = { fg = colors.maroon, italic = true },
            ["@variable.member.typescript"] = { fg = colors.lavender },
            ["@variable.builtin.typescript"] = { fg = colors.flamingo, italic = true },
            ["@operator.typescript"] = { fg = colors.sky },
            ["@punctuation.delimiter.typescript"] = { fg = colors.overlay2 },
            ["@punctuation.bracket.typescript"] = { fg = colors.surface2 },

            -- TSX/React. Inherited TypeScript and JSX captures use the TSX suffix.
            ["@keyword.tsx"] = { fg = colors.mauve, italic = true, bold = true },
            ["@keyword.function.tsx"] = { fg = colors.blue, italic = true },
            ["@keyword.coroutine.tsx"] = { fg = colors.mauve, italic = true },
            ["@keyword.operator.tsx"] = { fg = colors.mauve },
            ["@keyword.exception.tsx"] = { fg = colors.red, italic = true },
            ["@keyword.type.tsx"] = { fg = colors.lavender, italic = true, bold = true },
            ["@keyword.modifier.tsx"] = { fg = colors.flamingo, italic = true },
            ["@keyword.return.tsx"] = { fg = colors.red, bold = true },
            ["@keyword.import.tsx"] = { fg = colors.blue, bold = true },
            ["@keyword.export.tsx"] = { fg = colors.blue, bold = true },
            ["@keyword.conditional.tsx"] = { fg = colors.pink, italic = true },
            ["@keyword.conditional.ternary.tsx"] = { fg = colors.pink },
            ["@keyword.repeat.tsx"] = { fg = colors.mauve, italic = true },
            ["@type.tsx"] = { fg = colors.yellow, bold = true },
            ["@type.builtin.tsx"] = { fg = colors.peach, bold = true },
            ["@function.tsx"] = { fg = colors.green, bold = true },
            ["@function.call.tsx"] = { fg = colors.teal },
            ["@function.method.tsx"] = { fg = colors.green },
            ["@function.method.call.tsx"] = { fg = colors.teal },
            ["@constructor.tsx"] = { fg = colors.yellow, bold = true },
            ["@module.tsx"] = { fg = colors.sky, bold = true },
            ["@module.builtin.tsx"] = { fg = colors.sky },
            ["@constant.tsx"] = { fg = colors.peach, bold = true },
            ["@constant.builtin.tsx"] = { fg = colors.peach },
            ["@boolean.tsx"] = { fg = colors.peach, italic = true },
            ["@string.tsx"] = { fg = colors.green },
            ["@number.tsx"] = { fg = colors.peach },
            ["@variable.tsx"] = { fg = colors.text },
            ["@variable.parameter.tsx"] = { fg = colors.maroon, italic = true },
            ["@variable.member.tsx"] = { fg = colors.lavender },
            ["@variable.builtin.tsx"] = { fg = colors.flamingo, italic = true },
            ["@operator.tsx"] = { fg = colors.sky },
            ["@punctuation.delimiter.tsx"] = { fg = colors.overlay2 },
            ["@punctuation.bracket.tsx"] = { fg = colors.surface2 },
            ["@tag.tsx"] = { fg = colors.yellow, bold = true },
            ["@tag.builtin.tsx"] = { fg = colors.blue },
            ["@tag.attribute.tsx"] = { fg = colors.yellow, italic = true },
            ["@tag.delimiter.tsx"] = { fg = colors.overlay2 },
          }
        end,
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
