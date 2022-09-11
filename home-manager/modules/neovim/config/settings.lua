local opt = vim.opt

-- Relative numbers for jumps
opt.relativenumber = true

-- Highlight columns to see line length
opt.colorcolumn = { 120 }

-- Show invisible characters
opt.list = true
opt.listchars = { tab = "->", space = "·", trail = "·" }

opt.formatoptions = "cq"

vim.g.luasnippets_path = "~/.config/nvim/lua/custom/snippets"

vim.g.mapleader = "t"

opt.whichwrap = "<,>,[,]"
