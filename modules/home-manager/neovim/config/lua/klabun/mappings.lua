vim.api.nvim_set_keymap("n", "<Space>", "<Nop>", { noremap = true })
vim.g.mapleader = " "

-- Telescope
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope.find_files, {})
vim.keymap.set("n", "<leader>fg", telescope.live_grep, {})
vim.keymap.set("n", "<leader>fb", telescope.buffers, {})
vim.keymap.set("n", "<leader>fh", telescope.help_tags, {})

-- Neotree
vim.api.nvim_set_keymap("n", "<F1>", "<cmd>Neotree filesystem toggle left<cr>", { noremap = true })

-- Terminal
vim.api.nvim_set_keymap("n", "<F2>", "<cmd>ToggleTerm<cr>", { noremap = true })
vim.api.nvim_set_keymap("t", "<F2>", "<cmd>ToggleTerm<cr>", { noremap = true })

-- Lsp
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, {})
