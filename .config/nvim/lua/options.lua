require "nvchad.options"

-- add yours here!

local options = {
  cursorlineopt = "both",
  relativenumber = true,
  tabstop = 4,
  expandtab = false,
  shiftwidth = 4,
  smartindent = true,
  softtabstop = 4,
  numberwidth = 4,
  wrap = false,
  list = true,
  spell = false,
  spellfile = vim.fn.stdpath "data" .. "/site/spell/en.utf-8.add",
  scrolloff = 16,
  sidescrolloff = 8,
  -- signcolumn = "yes:2",
  foldmethod = "marker",
}

vim.fn.mkdir(vim.fn.stdpath "data" .. "/site/spell", "p")

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.g.python_highlight_all = 1
vim.cmd "syntax on"
vim.cmd "filetype plugin indent on"

vim.opt.listchars:append { tab = "│ ", trail = "" }

vim.api.nvim_create_augroup("SetTextWidth", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "SetTextWidth",
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.textwidth = 80
    vim.opt_local.spell = true
  end,
})
