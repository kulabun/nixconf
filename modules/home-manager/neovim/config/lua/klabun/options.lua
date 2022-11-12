vim.opt.backspace = vim.opt.backspace + { "nostop" } -- Don't stop backspace at insert
vim.opt.clipboard = "unnamedplus" -- Connection to the system clipboard
vim.opt.cmdheight = 0 -- hide command line unless needed
vim.opt.colorcolumn = { 120 } -- Highlight columns to see line length
vim.opt.completeopt = { "menuone", "noselect" } -- Options for insert mode completion
vim.opt.copyindent = true -- Copy the previous indentation on autoindenting
vim.opt.cursorline = true -- Highlight the text line of the cursor
vim.opt.expandtab = true -- Enable the use of space in tab
vim.opt.fileencoding = "utf-8" -- File content encoding for the buffer
vim.opt.fillchars = { eob = " " } -- Disable `~` on nonexistent lines
vim.opt.hidden = true -- Keep abandoned buffers instead of unloading
vim.opt.history = 100 -- Number of commands to remember in a history table
vim.opt.ignorecase = true -- Case insensitive searching
vim.opt.laststatus = 3 -- globalstatus
vim.opt.lazyredraw = true -- lazily redraw screen
-- vim.opt.listchars = { tab = "->", space = "⋅", eol = "↴" } -- Replace invisible characters with provided
vim.opt.listchars = { tab = "->", space = " ", trail = "·" } -- Replace invisible characters with provided
vim.opt.list = true -- Show invisible characters
vim.opt.mouse = "" -- Disable mouse support 
vim.opt.number = true -- Show numberline
vim.opt.numberwidth = 2 -- The size of the linenumbers column
vim.opt.preserveindent = true -- Preserve indent structure as much as possible
vim.opt.pumheight = 10 -- Height of the pop up menu
vim.opt.relativenumber = true -- Show relative numberline
vim.opt.ruler = true -- Display cursor position in the status line
vim.opt.scrolloff = 12 -- Number of lines to keep above and below the cursor
vim.opt.shiftwidth = 2 -- Number of space inserted for indentation
vim.opt.showmode = true -- Enable showing modes in command line
vim.opt.showtabline = 2 -- always display tabline
vim.opt.sidescrolloff = 8 -- Number of columns to keep at the sides of the cursor
vim.opt.signcolumn = "yes" -- Always show the sign column
vim.opt.smartcase = true -- Case sensitivie searching
vim.opt.spell = false -- Disable language spell checks
vim.opt.splitbelow = true -- Splitting a new window below the current one
vim.opt.splitright = true -- Splitting a new window at the right of the current one
vim.opt.swapfile = false -- Disable use of swapfile for the buffer
vim.opt.tabstop = 2 -- Number of space in a tab
vim.opt.termguicolors = true -- Enable 24-bit RGB color in the TUI
vim.opt.textwidth = 0 -- Disable automatic line wrap
vim.opt.timeoutlen = 300 -- Length of time to wait for a mapped sequence
vim.opt.undofile = true -- Enable persistent undo
vim.opt.updatetime = 300 -- Length of time to wait before triggering the plugin
vim.opt.whichwrap = "" -- Don't wrap line on movement
vim.opt.wildignorecase = true -- Ignore case on file path completion
vim.opt.wrap = true -- Visually wraps line into two when it's longer then display width
vim.opt.writebackup = false -- Disable making a backup before overwriting a file
                           
vim.g.autoformat_enabled = true -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
vim.g.autopairs_enabled = true -- enable autopairs at start
vim.g.cmp_enabled = true -- enable completion at start
vim.g.diagnostics_enabled = true -- enable diagnostics at start
vim.g.highlighturl_enabled = true -- highlight URLs by default
vim.g.icons_enabled = true -- disable icons in the UI (disable if no nerd font is available)
vim.g.mapleader = " " -- set leader key
vim.g.nolazyredraw = true -- Don't redraw while executing macros
vim.g.status_diagnostics_enabled = true -- enable diagnostics in statusline

vim.cmd([[
  set nolazyredraw
  set ttyfast
]])
