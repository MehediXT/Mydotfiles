local lspconfig = require("lspconfig")

lspconfig.clangd.setup({
  cmd = { "clangd", "--background-index" },
})