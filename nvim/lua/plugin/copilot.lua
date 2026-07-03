return {
  "github/copilot.vim",
  lazy = false,

  init = function()
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
  end,

  config = function()
    vim.keymap.set("i", "<C-y>", 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false,
      desc = "Accept Copilot",
    })
  end,
}
