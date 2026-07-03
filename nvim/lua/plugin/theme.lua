return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  enabled = false,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = false,
      integrations = {
        cmp = true,
        gitsigns = true,
        telescope = true,
        treesitter = true,
        which_key = true,
        native_lsp = {
          enabled = true,
          inlay_hints = {
            background = true,
          },
        },
      },
    })

    vim.cmd.colorscheme "catppuccin-nvim"
  end,
}
