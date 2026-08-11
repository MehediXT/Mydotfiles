return function(_, opts)
  opts = opts or {}
  opts.ensure_installed = opts.ensure_installed or {}
  opts.auto_install = true

  local parsers = {
    "c",
    "cpp",
    -- Web stack: JavaScript parses .js and .jsx; TSX parses React TypeScript.
    "html",
    "htmldjango",
    "css",
    "javascript",
    "jsdoc",
    "typescript",
    "tsx",
    "python",
    "lua",
    "vim",
    "vimdoc",
    "markdown",
  }

  -- NvChad already requests a few parsers. Avoid duplicate installation jobs
  -- while extending its list with the languages used by this config.
  for _, parser in ipairs(parsers) do
    if not vim.tbl_contains(opts.ensure_installed, parser) then
      table.insert(opts.ensure_installed, parser)
    end
  end

  opts.highlight = vim.tbl_deep_extend("force", { enable = true }, opts.highlight or {})
  opts.highlight.additional_vim_regex_highlighting = { "python" }
  opts.indent = vim.tbl_deep_extend("force", { enable = true }, opts.indent or {})

  return opts
end
