return {
  -- NvChad still ships an nvim-cmp spec, while this config uses Blink. Import
  -- its complete Blink stack explicitly so completion, snippets, and pairs do
  -- not depend on whichever engine happens to exist in the plugin directory.
  { import = "nvchad.blink.lazyspec" },

  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "default",
        -- Enter should remain a newline unless an item was deliberately
        -- selected with Tab/C-n. This keeps C++ indentation predictable after
        -- access specifiers such as public: and private:.
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      },
      completion = {
        accept = {
          auto_brackets = { enabled = true },
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },
        menu = {
          auto_show = true,
          auto_show_delay_ms = 0,
          max_height = 12,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 150,
          window = { border = "rounded" },
        },
        ghost_text = { enabled = true },
      },
      signature = {
        enabled = true,
        window = { border = "rounded" },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = {
            fallbacks = {},
            timeout_ms = 2000,
          },
        },
      },
    },
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = { "TelescopePrompt", "vim" },
      fast_wrap = {},
      enable_check_bracket_line = false,
    },
  },
}
