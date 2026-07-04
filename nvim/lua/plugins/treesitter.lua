return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- NvChad + Neovim 0.11 need the legacy master branch; main is a full rewrite.
    branch = "master",
    opts = require "configs.treesitter",
  },
}
