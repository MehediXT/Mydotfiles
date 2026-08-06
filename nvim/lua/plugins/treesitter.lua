return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- NvChad + Neovim 0.11 need the legacy master branch; main is a full rewrite.
    branch = "master",
    build = ":TSUpdate",
    opts = require "configs.treesitter",
    -- The legacy branch's top-level setup() does not accept configuration.
    -- Call its configs module directly so ensure_installed/highlight/indent work.
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
--yooo
