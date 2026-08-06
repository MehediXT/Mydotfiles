local Path = require("plenary.path")

-- helper function to check for a .cformat file up the directory tree
local function has_cformat_file(bufnr)
	local filename = vim.api.nvim_buf_get_name(bufnr)
	local dir = filename ~= "" and vim.fn.fnamemodify(filename, ":p:h") or vim.uv.cwd()

	while dir do
		if Path:new(dir, ".cformat"):exists() then
			return true
		end

		local parent = Path:new(dir):parent().filename
		if parent == dir then
			break
		end
		dir = parent
	end
	return false
end

-- conditional formatter for C/C++
local function c_formatter(bufnr)
	if has_cformat_file(bufnr) then
		return { "clang-format" }
	end
	return {}
end

return {
	"stevearc/conform.nvim",
	event = "VeryLazy",
	opts = {
		formatters_by_ft = {
			c = c_formatter,
			cpp = { "clang-format" },
			css = { "prettier" },
			go = { "golines", "goimports", "gofmt", "gofumpt" },
			h = c_formatter,
			haskell = { "fourmolu" },
			prisma = { "prisma_format" },
			html = { "prettier" },
			javascript = { "biome", "biome-organize-imports" },
			javascriptreact = { "biome", "biome-organize-imports" },
			typescript = { "biome", "biome-organize-imports" },
			typescriptreact = { "biome", "biome-organize-imports" },
			json = { "biome" },
			lua = { "stylua" },
			markdown = { "prettier_md" },

			python = function(bufnr)
				if require("conform").get_formatter_info("ruff_format", bufnr).available then
					return { "ruff_format", "isort" }
				else
					return { "autoflake", "isort", "black" }
				end
			end,

			rmd = { "prettier_md" },
			rust = { "rustfmt", lsp_format = "fallback" },
			sql = { "sleek" },
			sh = { "shfmt" },
			typst = { "prettypst" }, --"typstfmt" },
		},

		formatters = {
			prettier = {
				prepend_args = {
					"--config-precedence",
					"file-override",
					"--print-width",
					"80",
					"--use-tabs",
					"--tab-width",
					"4",
				},
			},
			prettier_md = {
				command = "prettier",
				args = {
					"--no-config",
					"--print-width",
					"80",
					"--tab-width",
					"2",
					"--parser",
					"markdown",
					"--prose-wrap",
					"always",
				},
			},
			prisma_format = {
				command = "prisma",
				args = { "format" },
			},
			prettypst = {
				prepend_args = { "--style=otbs" },
			},
			rustfmt = {
				prepend_args = { "--config", "hard_tabs=true" },
			},
		},
	},
}
