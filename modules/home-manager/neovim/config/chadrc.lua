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
	},
	user = {
		--["simrat39/rust-tools.nvim"] = require("custom.plugins.rust-tools"),
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
		["jose-elias-alvarez/null-ls.nvim"] = require("custom.plugins.null-ls"),
	},
}

return M
