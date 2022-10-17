local M = {}

M.disabled = {
  n = {
    ["<leader>v"] = "",
    ["<leader>h"] = "",
    ["<leader>t"] = "",
    ["<leader>tt"] = "",
    ["<leader>fm"] = "",
  },
}

-- M.diffview = {
	-- n = {
-- 		["<C-g>v"] = { "<cmd> :DiffviewOpen<CR>", "Open DiffView", opts = { nowait = true } },
-- 		["<C-g>b"] = { "<cmd> :Gitsigns blame_line<CR>", "Show git blame for current line", opts = { nowait = true } },
-- 		["<C-g>w"] = { "<cmd> :DiffviewClose<CR>", "Close DiffView" },
-- 		["<C-g>h"] = { "<cmd> :DiffviewFileHistory %<CR>", "Open File History", opts = { nowait = true } },
-- 	},
-- }
--
M.telescope = {
  n = {
    -- ["<C-t>"] = { ":Telescope <CR>" },
    -- ["<C-p>"] = { ":Telescope find_files<CR>" },
    -- ["<C-b>"] = { ":Telescope buffers<CR>" },
    --
    -- ["<C-S-f>"] = { ":Telescope live_grep<CR>" },
    -- ["<C-f>"] = { ":Telescope current_buffer_fuzzy_find<CR>" },
  },
}

-- M.hop = {
-- 	n = {
-- 		["f"] = { "<cmd>lua require'hop'.hint_words({})<cr>" },
-- 		["F"] = { "<cmd>lua require'hop'.hint_char1({})<cr>" },
-- 	},
-- 	v = {
-- 		["f"] = { "<cmd>lua require'hop'.hint_words({})<cr>" },
-- 		["F"] = { "<cmd>lua require'hop'.hint_char1({})<cr>" },
-- 	},
-- }

M.null_ls = {
  n = {
    ["="] = { "<cmd>lua vim.lsp.buf.formatting()<cr>" },
  },
}

-- M.trouble = {
-- 	n = {
-- 		["<C-q>"] = { "<cmd> TroubleToggle <CR>", "[Custom] toggle LSP errors window" },
-- 	},
-- }

M.general = {
  n = {
    -- ["<C-l>"] = { ":bn<cr>", "[Custom] next buffer" },
    -- ["<C-h>"] = { ":bp<cr>", "[Custom] previous buffer" },
    -- ["<C-w>"] = { ":bd<cr>", "[Custom] close buffer" },
    -- ["<C-A-w>"] = { ":bd!<cr>", "[Custom] close buffer" },

    -- ["<leader>c"] = {
    -- 	"<cmd>lua require('Comment.api').toggle.linewise.current()<CR>",
    -- 	"蘒  toggle comment",
    -- },
  },
  v = {
    -- ["Y"] = { '"+y' },
    -- ["<leader>c"] = {
    -- 	"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
    -- 	"蘒  toggle comment",
    -- },
  },
}

return M
