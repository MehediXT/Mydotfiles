-- {{{ Default NvChad Stuff, ! Do not touch
vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- User-local and Mason tools must be visible to Neovim, including GUI launches.
local user_bin = vim.fs.joinpath(vim.uv.os_homedir(), ".local", "bin")
local mason_bin = vim.fs.joinpath(vim.fn.stdpath "data", "mason", "bin")
vim.env.PATH = table.concat({ user_bin, mason_bin, vim.env.PATH }, ":")

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "lazy-conf"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

-- nvchad autocommands
require "nvchad.autocmds"

-- }}}

-- load user configs
local cfgs = { "options", "aucmds", "func" }

for i = 1, #cfgs do
  require(cfgs[i])
end

-- mappings should be at the very end
vim.schedule(function()
  require "mappings"
end)

vim.cmd [[set exrc]]

vim.g.snipmate_snippets_path = vim.fn.stdpath "config" .. "/snippets/snipmate"
--the lua
