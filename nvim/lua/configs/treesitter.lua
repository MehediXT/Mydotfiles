return function(_, opts)
  opts = opts or {}
  opts.ensure_installed = opts.ensure_installed or {}
  opts.auto_install = true

  vim.list_extend(opts.ensure_installed, {
    "c",
    "cpp",
    "python",
    "lua",
    "vim",
    "vimdoc",
    "markdown",
  })

  opts.highlight = vim.tbl_deep_extend("force", { enable = true }, opts.highlight or {})
  opts.highlight.additional_vim_regex_highlighting = { "python" }
  opts.indent = vim.tbl_deep_extend("force", { enable = true }, opts.indent or {})

  return opts
end
