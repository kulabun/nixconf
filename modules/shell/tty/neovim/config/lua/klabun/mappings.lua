  -- VIM Default Keybindings
  --   Normal mode
  --
  --     -- Navigation
  --     C-o - jump to previous cursor position
  --     C-i - jump to next cursor position
  --
  --     -- Movement
  --     * - search forward word under cursor
  --     # - search backward word under cursor
  --     f<char> - move to next occurence of <char> 
  --     t<char> - move to before next occurence of <char>
  --     F<char> - move to previous occurence of <char> 
  --     T<char> - move to after previous occurence of <char> 
  --     ; - repeat last f, t, F, or T
  --     w - move to the begining of the word(space or punctuation separated, forward
  --     b - move to the begining of the word(space or punctuation separated), backward
  --     e - move to end of word, forward
  --     ge - move to end of word, backward
  --     W - move to the begining of the work(space separated), forward
  --     B - move to the begining of the word(space separated), backward
  --     E - move to the end of the word(space separated), forward 
  --     gE - move to the end of the word(space separated), backward
  --     / - search forward
  --     ? - search backward
  --     n - repeat last search forward
  --     N - repeat last search backward
  --     m<char> - set mark <char>
  --     `<char> - jump to the mark <char>
  --
  --     
  --     Free: Q, U, 
  --     Can be remappend: H, L, S, M,
  --     Learn: z,Z,C-<key>  
  --
  --     -- Editing 
  --     c<move> - change text to the <move> direction
  --     d<move> - delete text to the <move> direction
  --     cc - delete line and enter insert mode
  --     dd - delete line
  --     C - change to end of line
  --     D - delete to end of line
  --     i - enter insert mode before cursor 
  --     a - enter insert mode after cursor
  --     I - enter insert mode at beginning of line
  --     A - enter insert mode at end of line
  --     r - change character under cursor
  --     R - enter replace mode
  --     o - move to a line below and enter insert mode
  --     O - move to a line above and enter insert mode
  --     p - paste after cursor
  --     P - paste before cursor
  --     x - delete character under cursor
  --     X - delete character before cursor
  --     . - repeat last change
  --
  --     y<move> - yank text to the <move> direction
  --     Y - yank to the end of line
  --     u - undo
  --     C-r - redo
  --
  --     J - join line below to current line
  --
  --     K - show documentation for word under cursor
  --
  --     ~ - toggle case of character under cursor
  --     guu - make line lowercase
  --     gUU - make line uppercase
  --     
  --     v - enter visual mode
  --     V - enter visual line mode
  --     C-v - enter visual block mode 

vim.g.mapleader = " "
vim.api.nvim_set_keymap("n", "<Space>", "<Nop>", { noremap = true })

local telescope = require("telescope")
local fun = require("klabun.functions")
local wk = require("which-key")

------------------------------------------------------------------------------------------------
-- Normal Mode
------------------------------------------------------------------------------------------------
wk.register({
	["<leader>f"] = {
		name = "+File",
		a = { "<cmd>enew<cr>", "New File" },
		o = { fun.open_project_file, "Open File in Workspace" },
		e = { fun.recent_project_files, "Open Recent File" },
		p = { fun.recent_projects, "Open Workspace" },
		f = { fun.grep_in_project, "Find In Workspace(grep)" },
		s = { fun.symbol_in_project, "Find In Workspace" },
	},
	["<leader>z"] = {
		name = "+Vim Operations",
		c = { "<cmd>Telescope commands<cr>", "VIM Commands" },
		r = { "<cmd>Telescope reloader<cr>", "Relead VIM module" },
		o = { "<cmd>Telescope vim_options<cr>", "VIM Options" },
		t = { "<cmd>Telescope help_tags<cr>", "Help VIM tags" },
	},
	["<F1>"] = { "<cmd>Neotree toggle float<cr>", "Neotree toggle" },
	["<F2>"] = { "<cmd>ToggleTerm<cr>", "Terminal toggle" },
	["<F3>"] = { "<cmd>Telescope keymaps<cr>", "Telescope" },
	["<F4>"] = { "<cmd>Telescope<cr>", "Telescope" },
}, { mode = "n" })


------------------------------------------------------------------------------------------------
-- Terminal Mode
------------------------------------------------------------------------------------------------
wk.register({
	["<F1>"] = { "<cmd>Neotree toggle float<cr>", "Neotree toggle" },
	["<F2>"] = { "<cmd>ToggleTerm<cr>", "Terminal toggle" },
	["<F3>"] = { "<cmd>Telescope keymaps<cr>", "Telescope" },
	["<F4>"] = { "<cmd>Telescope<cr>", "Telescope" },
	-- ["<F3>"] = { "<cmd>Telescope<cr>", "Telescope" },
}, { mode = "t" })
------------------------------------------------------------------------------------------------
-- Telescope
------------------------------------------------------------------------------------------------
local ts = require("telescope.builtin")
-- vim.keymap.set("n", "gt", telescope.find_files, {})
vim.keymap.set("n", "gr", ts.lsp_references, {})
vim.keymap.set("n", "<leader>th", ts.help_tags, {})

-- Neotree
vim.api.nvim_set_keymap("n", "<F1>", "<cmd>Neotree filesystem toggle left<cr>", { noremap = true })

-- Terminal
vim.api.nvim_set_keymap("n", "<F2>", "<cmd>ToggleTerm<cr>", { noremap = true })
vim.api.nvim_set_keymap("t", "<F2>", "<cmd>ToggleTerm<cr>", { noremap = true })
vim.api.nvim_set_keymap("t", "<S-Esc>", "<C-\\><C-n>", { noremap = true })

------------------------------------------------------------------------------------------------
-- Bufferline
------------------------------------------------------------------------------------------------
local bl = require("bufferline")
vim.keymap.set("n", "g1", function()
	bl.go_to_buffer(1, true)
end, {})
vim.keymap.set("n", "g2", function()
	bl.go_to_buffer(2, true)
end, {})
vim.keymap.set("n", "g3", function()
	bl.go_to_buffer(3, true)
end, {})
vim.keymap.set("n", "g4", function()
	bl.go_to_buffer(4, true)
end, {})
vim.keymap.set("n", "g5", function()
	bl.go_to_buffer(5, true)
end, {})
vim.keymap.set("n", "g6", function()
	bl.go_to_buffer(6, true)
end, {})
vim.keymap.set("n", "g7", function()
	bl.go_to_buffer(7, true)
end, {})
vim.keymap.set("n", "g8", function()
	bl.go_to_buffer(8, true)
end, {})
vim.keymap.set("n", "g9", function()
	bl.go_to_buffer(9, true)
end, {})
vim.keymap.set("n", "g0", function()
	bl.go_to_buffer(10, true)
end, {})
-- vim.keymap.set("n", "gt", function()
--   bufferline.pick_buffer()
-- end, {})
vim.api.nvim_set_keymap("n", "<C-w>", "<cmd>bd<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "gx", "<cmd>bd<cr>", { noremap = true })

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
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", {})
vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", {})
vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>TroubleToggle<cr>", {})
vim.api.nvim_set_keymap("n", "<leader>xr", "<cmd>TroubleRefresh<cr>", {})

vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
-- gd -go to definition
-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
-- vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, {})
-- vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, {})
-- vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, {})
-- vim.keymap.set("n", "<space>wl", function()
--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- end, {})

-- Ex-mode Abbreviations
vim.cmd([[
fun! SetupCommandAlias(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun
call SetupCommandAlias("ps","PackerSync")
call SetupCommandAlias("ls","LspInfo")
call SetupCommandAlias("chk","checkhealth")
]])
vim.cmd([[ cnoreabbrev <expr> "q ((getcmdtype() is# ':' && getcmdline() is# '"q')?('wq'):('"q')) ]])
