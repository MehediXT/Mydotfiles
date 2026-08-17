return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- The legacy master branch only supports Neovim 0.10/0.11. Neovim 0.12
    -- requires the rewritten main branch and its native highlighting API.
    branch = "main",
    lazy = false,
    dependencies = { "neovim-treesitter/treesitter-parser-registry" },
    build = ":TSUpdate | TSInstallAll",
    opts = require "configs.treesitter",
  },
}
--yooo
