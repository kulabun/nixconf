local M = {}

M.diffview = {
	n = {
		["<leader>gv"] = { "<cmd> :DiffviewOpen<CR>", "Open DiffView", opts = { nowait = true } },
		["<leader>gx"] = { "<cmd> :DiffviewClose<CR>", "Close DiffView" },
		["<leader>gh"] = { "<cmd> :DiffviewFileHistory %<CR>", "Open File History", opts = { nowait = true } },
	},
}

M.telescope = {
	n = {
		["<C-t>"] = { ":Telescope <CR>" },
		["<C-p>"] = { ":Telescope find_files<CR>" },
		["<C-b>"] = { ":Telescope buffers<CR>" },

		["<C-S-f>"] = { ":Telescope live_grep<CR>" },
		["<C-f>"] = { ":Telescope current_buffer_fuzzy_find<CR>" },
	},
}

M.hop = {
	n = {
		["f"] = { "<cmd>lua require'hop'.hint_words({})<cr>" },
		["F"] = { "<cmd>lua require'hop'.hint_char1({})<cr>" },
	},
	v = {
		["f"] = { "<cmd>lua require'hop'.hint_words({})<cr>" },
		["F"] = { "<cmd>lua require'hop'.hint_char1({})<cr>" },
	},
}

M.null_ls = {
	n = {
		["<C-l>"] = { "<cmd>lua vim.lsp.buf.formatting()<cr>" },
	},
}

M.trouble = {
	n = {
		["<C-q>"] = { "<cmd> TroubleToggle <CR>", "[Custom] toggle LSP errors window" },
	},
}

M.general = {
	n = {
		["<C-w>"] = { ":bd<cr>", "[Custom] close buffer" },
		["<C-j>"] = { ":bprevious<cr>", "[Custom] previous buffer" },
		["<C-k>"] = { ":bnext<cr>", "[Custom] next buffer" },
		["<leader>c"] = {
			"<cmd>lua require('Comment.api').toggle.linewise.current()<CR>",
			"蘒  toggle comment",
		},
	},
	v = {
		["Y"] = { '"+y' },
		["<leader>c"] = {
			"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
			"蘒  toggle comment",
		},
	},
}

return M
