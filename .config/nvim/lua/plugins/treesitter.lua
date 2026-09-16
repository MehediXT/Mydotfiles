return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- The legacy master branch only supports Neovim 0.10/0.11. Neovim 0.12
    -- requires the rewritten main branch and its native highlighting API.
    branch = "main",
    lazy = false,
    dependencies = { "neovim-treesitter/treesitter-parser-registry" },
    -- TSInstallAll is created by NvChad during init, so it is unavailable
    -- when lazy.nvim runs a fresh-install build command.
    build = ":TSUpdate",
    opts = require "configs.treesitter",
    config = function(_, opts)
      local treesitter = require "nvim-treesitter"

      -- The main branch has no legacy configs.setup() layer. Keep the
      -- install directory at its default and install our configured parsers
      -- from the normal Neovim startup path.
      treesitter.setup()
      treesitter.install(opts.ensure_installed or {})
    end,
  },
}
--yooo
