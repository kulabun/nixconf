M = {
  options = {
    opt = {
      backspace = vim.opt.backspace + { "nostop" }, -- Don't stop backspace at insert
      clipboard = "unnamedplus", -- Connection to the system clipboard
      cmdheight = 0, -- hide command line unless needed
      colorcolumn = { 120 }, -- Highlight columns to see line length
      completeopt = { "menuone", "noselect" }, -- Options for insert mode completion
      copyindent = true, -- Copy the previous indentation on autoindenting
      cursorline = true, -- Highlight the text line of the cursor
      expandtab = true, -- Enable the use of space in tab
      fileencoding = "utf-8", -- File content encoding for the buffer
      fillchars = { eob = " " }, -- Disable `~` on nonexistent lines
      hidden = true, -- Keep abandoned buffers instead of unloading
      history = 100, -- Number of commands to remember in a history table
      ignorecase = true, -- Case insensitive searching
      laststatus = 3, -- globalstatus
      lazyredraw = true, -- lazily redraw screen
      listchars = { tab = "->", space = "·", trail = "·" }, -- Replace invisible characters with provided
      list = true, -- Show invisible characters
      mouse = "", -- Disable mouse support
      number = true, -- Show numberline
      numberwidth = 2, -- The size of the linenumbers column
      preserveindent = true, -- Preserve indent structure as much as possible
      pumheight = 10, -- Height of the pop up menu
      relativenumber = true, -- Show relative numberline
      ruler = true, -- Display cursor position in the status line
      scrolloff = 12, -- Number of lines to keep above and below the cursor
      shiftwidth = 2, -- Number of space inserted for indentation
      showmode = true, -- Enable showing modes in command line
      showtabline = 2, -- always display tabline
      --sidescrolloff = 8, -- Number of columns to keep at the sides of the cursor
      signcolumn = "yes", -- Always show the sign column
      smartcase = true, -- Case sensitivie searching
      spell = false, -- Disable language spell checks
      splitbelow = true, -- Splitting a new window below the current one
      splitright = true, -- Splitting a new window at the right of the current one
      swapfile = false, -- Disable use of swapfile for the buffer
      tabstop = 2, -- Number of space in a tab
      termguicolors = true, -- Enable 24-bit RGB color in the TUI
      textwidth = 0, -- Disable automatic line wrap
      timeoutlen = 300, -- Length of time to wait for a mapped sequence
      undofile = true, -- Enable persistent undo
      updatetime = 300, -- Length of time to wait before triggering the plugin
      whichwrap = "", -- Don't wrap line on movement
      wildignorecase = true, -- Ignore case on file path completion
      wrap = true, -- Visually wraps line into two when it's longer then display width
      writebackup = false, -- Disable making a backup before overwriting a file
    },
    g = {
      autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
      autopairs_enabled = true, -- enable autopairs at start
      cmp_enabled = true, -- enable completion at start
      diagnostics_enabled = true, -- enable diagnostics at start
      highlighturl_enabled = true, -- highlight URLs by default
      icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available)
      load_black = false, -- disable black
      loaded_2html_plugin = true, -- disable 2html
      loaded_getscriptPlugin = true, -- disable getscript
      loaded_getscript = true, -- disable getscript
      loaded_gzip = true, -- disable gzip
      loaded_logipat = true, -- disable logipat
      loaded_matchit = true, -- disable matchit
      loaded_netrwFileHandlers = true, -- disable netrw
      loaded_netrwPlugin = true, -- disable netrw
      loaded_netrwSettngs = true, -- disable netrw
      loaded_remote_plugins = true, -- disable remote plugins
      loaded_tarPlugin = true, -- disable tar
      loaded_tar = true, -- disable tar
      loaded_vimballPlugin = true, -- disable vimball
      loaded_vimball = true, -- disable vimball
      loaded_zipPlugin = true, -- disable zip
      loaded_zip = true, -- disable zip
      mapleader = " ", -- set leader key
      status_diagnostics_enabled = true, -- enable diagnostics in statusline
      zipPlugin = false, -- disable zip
    },
  },
}

for group_key, group in pairs(M.options) do
  for key, value in pairs(group) do
    vim[group_key][key] = value
  end
end

-- Disable comment new line
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})
