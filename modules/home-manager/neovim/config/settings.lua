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

opt.autoindent = true
opt.clipboard = "unnamedplus"
opt.cmdheight = 1
opt.expandtab = true
opt.hidden = true
opt.ignorecase = true
opt.modifiable = true
opt.mouse = "a"
opt.number = true
opt.numberwidth = 2
opt.ruler = false
opt.scrolloff = 12
opt.shiftwidth = 2
opt.smartindent = true
opt.smarttab = true
opt.softtabstop = 4
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 4
opt.textwidth = 0
opt.timeoutlen = 400
opt.undofile = true
opt.updatetime = 250
opt.whichwrap = "<,>"
opt.wrapmargin = 1
opt.wildignorecase = true
