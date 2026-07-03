return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",

  event = { "BufReadPost", "BufNewFile" },

  opts = {
    ensure_installed = {
      "bash",
      "c",
      "cpp",
      "css",
      "html",
      "htmldjango",
      "javascript",
      "lua",
      "markdown",
      "python",
      "rust",
      "toml",
      "typescript",
      "vim",
      "vimdoc",
    },
    auto_install = true,
    sync_install = false,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
  },

  config = function(_, opts)
    require("nvim-treesitter").setup(opts)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterEnable", { clear = true }),
      callback = function(args)
        local bufnr = args.buf
        local winid = vim.api.nvim_get_current_win()
        local ok = pcall(vim.treesitter.start, bufnr)
        if not ok then
          return
        end

        vim.wo[winid].foldmethod = "expr"
        vim.wo[winid].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
