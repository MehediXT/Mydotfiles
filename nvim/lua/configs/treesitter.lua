return function(_, opts)
  opts = opts or {}
  opts.ensure_installed = opts.ensure_installed or {}

  vim.list_extend(opts.ensure_installed, {
    "c",
    "cpp",
    "lua",
    "vim",
    "vimdoc",
    "markdown",
  })

  opts.highlight = vim.tbl_deep_extend("force", { enable = true }, opts.highlight or {})
  opts.indent = vim.tbl_deep_extend("force", { enable = true }, opts.indent or {})

  return opts
end
