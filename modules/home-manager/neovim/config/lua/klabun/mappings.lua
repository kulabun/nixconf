vim.api.nvim_set_keymap("n", "<Space>", "<Nop>", { noremap = true })
vim.g.mapleader = " "

-- Neotree
vim.api.nvim_set_keymap("n", "<F1>", "<cmd>Neotree filesystem toggle left<cr>", { noremap = true })

-- Terminal
vim.api.nvim_set_keymap("n", "<F2>", "<cmd>ToggleTerm<cr>", { noremap = true })
vim.api.nvim_set_keymap("t", "<F2>", "<cmd>ToggleTerm<cr>", { noremap = true })
vim.api.nvim_set_keymap("t", "<S-Esc>", "<C-\\><C-n>", { noremap = true })

------------------------------------------------------------------------------------------------
-- Bufferline
------------------------------------------------------------------------------------------------
local bufferline = require("bufferline")
vim.keymap.set("n", "g1", function()
  bufferline.go_to_buffer(1, true)
end, {})
vim.keymap.set("n", "g2", function()
  bufferline.go_to_buffer(2, true)
end, {})
vim.keymap.set("n", "g3", function()
  bufferline.go_to_buffer(3, true)
end, {})
vim.keymap.set("n", "g4", function()
  bufferline.go_to_buffer(4, true)
end, {})
vim.keymap.set("n", "g5", function()
  bufferline.go_to_buffer(5, true)
end, {})
vim.keymap.set("n", "g6", function()
  bufferline.go_to_buffer(6, true)
end, {})
vim.keymap.set("n", "g7", function()
  bufferline.go_to_buffer(7, true)
end, {})
vim.keymap.set("n", "g8", function()
  bufferline.go_to_buffer(8, true)
end, {})
vim.keymap.set("n", "g9", function()
  bufferline.go_to_buffer(9, true)
end, {})
vim.keymap.set("n", "g0", function()
  bufferline.go_to_buffer(10, true)
end, {})
vim.keymap.set("n", "gt", function()
  bufferline.pick_buffer()
end, {})
vim.api.nvim_set_keymap("n", "<C-w>", "<cmd>bd<cr>", { noremap = true })

------------------------------------------------------------------------------------------------
-- LSP
------------------------------------------------------------------------------------------------
local lsp = vim.lsp.buf
-- leader keys to use: g t f
-- free commands & _ \
-- !<movement> - pipe selection to shell

vim.keymap.set("n", "<leader>=", lsp.format, {})
-- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "<leader>R", vim.lsp.buf.rename, {})
vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>s", vim.lsp.buf.signature_help, {})
vim.api.nvim_set_keymap("n", "<leader>ca", "<cmd>CodeActionMenu<cr>", {})
vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", {})
vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", {})
vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>TroubleToggle<cr>", {})
vim.api.nvim_set_keymap("n", "<leader>xr", "<cmd>TroubleRefresh<cr>", {})

vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
-- gd -go to definition
-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, {})
-- vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, {})
-- vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, {})
-- vim.keymap.set("n", "<space>wl", function()
--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- end, {})

------------------------------------------------------------------------------------------------
-- Telescope
------------------------------------------------------------------------------------------------
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>tf", telescope.find_files, {})
vim.keymap.set("n", "<leader>th", telescope.help_tags, {})

-- Ex-mode Abbreviations
vim.cmd([[ca "q wq]])
vim.cmd([[ca ps PackerSync]])
vim.cmd([[ca ls LspInfo]])

