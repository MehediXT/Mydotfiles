return {
	"neovim/nvim-lspconfig",
	config = function()
		require("nvchad.configs.lspconfig").defaults()

		vim.lsp.config("clangd", {
			on_attach = function(client, _)
				client.server_capabilities.semanticTokensProvider = nil
			end,
			cmd = {
				"clangd",
				"--header-insertion=iwyu",
				"--header-insertion-decorators=0",
				"--clang-tidy",
			},
		})

		local servers = {
			"html",
			"cssls",
			"clangd",
			"lua_ls",
			"biome",
			"gopls",
			"ruff",
			"prismals",
			"taplo",
			"jdtls",
		}
		vim.lsp.enable(servers)
	end,
}
