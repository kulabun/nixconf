local M = {}

M.ui = {
	theme = "chadracula",
}

M.mappings = require("custom.mappings")

M.plugins = {
	remove = {
		"windwp/nvim-autopairs",
		"williamboman/mason.nvim",
		"williamboman/nvim-lsp-installer",
	},
	override = {
		["nvim-treesitter/nvim-treesitter"] = require("custom.plugins.treesitter"),
		-- ["williamboman/mason.nvim"] = require("custom.plugins.mason"),
	},
	user = {
		["simrat39/rust-tools.nvim"] = require("custom.plugins.rust-tools"),
		["wakatime/vim-wakatime"] = {},
		["sindrets/diffview.nvim"] = {
			after = "plenary.nvim",
			config = function()
				require("diffview").setup()
			end,
		},
		["nvim-lua/plenary.nvim"] = { module = "" },
		["phaazon/hop.nvim"] = {
			branch = "v2",
			config = function()
				require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
			end,
		},
		["neovim/nvim-lspconfig"] = {
			config = function()
				require("plugins.configs.lspconfig")
				require("custom.plugins.lspconfig")
			end,
		},
		["mfussenegger/nvim-jdtls"] = {},
		["folke/trouble.nvim"] = {},
		["jose-elias-alvarez/null-ls.nvim"] = {
			after = "nvim-lspconfig",
			config = function()
				local b = require("null-ls").builtins
				require("null-ls").setup({
					debug = true,
					sources = {
						-- Web stack, JSON, YAML, markdown, graphql
						--b.formatting.prettier
						--b.formatting.deno_fmt.with { filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" } },
						--JSON
						b.formatting.jq,

						-- Lua
						b.formatting.stylua,
						b.diagnostics.luacheck.with({ extra_args = { "--global vim" } }),

						-- Shell
						b.formatting.shfmt,
						b.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),

						-- Rust
						b.formatting.rustfmt.with({ extra_args = { "--edition=2018" } }),
					},
					-- format on save
					on_attach = function()
						-- for 0.8.0 nvim
						--vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ bufnr = bufnr })"
						vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
					end,
				})
			end,
		},
	},
}

return M
