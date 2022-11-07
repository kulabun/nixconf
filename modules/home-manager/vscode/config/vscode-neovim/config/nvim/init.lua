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

local function map(mode, keys, exec, opts)
  vim.keymap.set(mode, keys, exec, opts or { silent = true, noremap = true })
end

if vim.g.vscode then
  -- Disable comment new line
  vim.opt.formatoptions:remove({ "c", "r", "o" })
  vim.opt_local.formatoptions:remove({ "c", "r", "o" })

  -- Tabs control
  -- <C-l> and <C-h> to move between tabs, configured in keybindings.json
  -- Shortcuts with modifiers are managed in keybindings.json

  -- Toggle comment
  map("n", "\\", '<Cmd>call VSCodeCall("editor.action.commentLine")<CR>')
  map("x", "\\", '<Cmd>call VSCodeCallVisual("editor.action.commentLine", 0)<CR>')

  -- Lsp actions
  map("n", "<leader>lf", '<Cmd>call VSCodeCall("editor.action.formatDocument")<CR>')
  map("n", "<leader>ld", '<Cmd>call VSCodeCall("editor.action.goToDeclaration")<CR>')
  map("n", "<leader>li", '<Cmd>call VSCodeCall("editor.action.goToImplementation")<CR>')
  
  -- Side and bottom bar toggle does't work well from neovim. It works only for show, not for hide.

  -- settings
  map("n", "<leader>ss", '<Cmd>call VSCodeCall("workbench.action.openApplicationSettingsJson")<CR>')
  map("n", "<leader>sk", '<Cmd>call VSCodeCall("workbench.action.openGlobalKeybindingsFile")<CR>')
  map("n", "<leader>sS", '<Cmd>call VSCodeCall("workbench.action.openGlobalSettings")<CR>')
  map("n", "<leader>sK", '<Cmd>call VSCodeCall("workbench.action.openGlobalKeybindings")<CR>')
  
  -- show keybindings
  map("n", "<leader>k", '<Cmd>call VSCodeCall("workbench.action.openKeyboardShortcuts")<CR>')


  -- show errors
  map("n", "<leader>e", '<Cmd>call VSCodeCall("workbench.action.problems.view")<CR>')
  
  -- show explorer
  map("n", "<leader>o", '<Cmd>call VSCodeCall("workbench.view.explorer")<CR>')
  map("n", "<leader>h", '<Cmd>call VSCodeCall("workbench.action.toggleSidebarVisibility")<CR>')
  
  -- go to next error
  map("n", "L", '<Cmd>call VSCodeCall("editor.action.marker.next")<CR>')
  
  -- go to previous error
  map("n", "H", '<Cmd>call VSCodeCall("editor.action.marker.prev")<CR>')

  -- go to definition
  map("n", "<leader>d", '<Cmd>call VSCodeCall("editor.action.goToDeclaration")<CR>')

  -- go to implementation
  map("n", "<leader>i", '<Cmd>call VSCodeCall("editor.action.goToImplementation")<CR>')

  -- hover signature
  map("n", "K", '<Cmd>call VSCodeCall("editor.action.showHover")<CR>')
  
  -- show documentation
  -- ??
  
  -- find references
  map("n", "<leader>fr", '<Cmd>call VSCodeCall("editor.action.referenceSearch.trigger")<CR>')
  
  -- rename symbol
  map("n", "<leader>n", '<Cmd>call VSCodeCall("editor.action.rename")<CR>')
  
  -- code actions
  map("n", "Q", '<Cmd>call VSCodeCall("editor.action.codeAction")<CR>')
  
  -- refactorings
  map("n", "<leader>r", '<Cmd>call VSCodeCall("editor.action.refactor")<CR>')
  
  -- toggle terminal
  map("n", "<F2>", '<Cmd>call VSCodeCall("workbench.action.terminal.toggleTerminal")<CR>')
  
  -- toggle files explorer
  map("n", "<F1>", '<Cmd>call VSCodeCall("workbench.view.explorer")<CR>')

  -- toggle search
  map("n", "<F3>", '<Cmd>call VSCodeCall("workbench.view.search")<CR>')

  -- toggle source control
  map("n", "<F4>", '<Cmd>call VSCodeCall("workbench.view.scm")<CR>')

  -- show blame
  map("n", "<leader>b", '<Cmd>call VSCodeCall("gitlens.showLineBlame")<CR>')
  
  -- show run tasks
  map("n", "<leader>t", '<Cmd>call VSCodeCall("workbench.action.tasks.runTask")<CR>')

  -- show debug tasks
  map("n", "<leader>dt", '<Cmd>call VSCodeCall("workbench.action.debug.start")<CR>')

  -- generate
  map("n", "<leader>g", '<Cmd>call VSCodeCall("editor.action.quickFix")<CR>')
    
  -- go to recent
  map("n", "<C-e>", '<Cmd>call VSCodeCall("workbench.action.openRecent")<CR>')
  
  -- hide toolbars
  map("n", "<F10>", '<Cmd>call VSCodeCall("workbench.action.toggleActivityBarVisibility")<CR>')
  
  -- close editor
  map("n", "<C-w>", '<Cmd>call VSCodeCall("workbench.action.closeActiveEditor")<CR>')
  
  -- close window
  map("n", "<C-q>", '<Cmd>call VSCodeCall("workbench.action.closeWindow")<CR>')

  -- boo
  map("n", "<leader>bo", '<Cmd>call VSCodeCall("workbench.action.toggleSidebarVisibility")<CR>')

  -- show extensions
  map("n", "<leader>x", '<Cmd>call VSCodeCall("workbench.extensions.action.showExtensions")<CR>')

  -- show snippets
  map("n", "<leader>sn", '<Cmd>call VSCodeCall("editor.action.insertSnippet")<CR>')
  
  map("n", "<leader>h", '<Cmd>call VSCodeCall("workbench.action.toggleZenMode")<CR>')
  
  -- show git
  map("n", "<leader>g", '<Cmd>call VSCodeCall("gitlens.showQuickCommitDetails")<CR>')
  map("n", "<leader>gs", '<Cmd>call VSCodeCall("gitlens.showQuickCommitFileDetails")<CR>')
  map("n", "<leader>gc", '<Cmd>call VSCodeCall("gitlens.showQuickCommitFileDetails")<CR>')
  map("n", "<leader>gl", '<Cmd>call VSCodeCall("gitlens.showQuickFileHistory")<CR>')
  map("n", "<leader>gb", '<Cmd>call VSCodeCall("gitlens.showQuickBranchHistory")<CR>')
  map("n", "<leader>ga", '<Cmd>call VSCodeCall("gitlens.showQuickRepoHistory")<CR>')
  map("n", "<leader>gr", '<Cmd>call VSCodeCall("gitlens.showQuickRepoStatus")<CR>')
  map("n", "<leader>gt", '<Cmd>call VSCodeCall("gitlens.showQuickRepoFileHistory")<CR>')
  map("n", "<leader>gT", '<Cmd>call VSCodeCall("gitlens.showQuickRepoFileHistory")<CR>')
  
  -- -- Move line up and down
  -- map("n", "<A-k>", '<Cmd>call VSCodeCall("editor.action.moveLinesUpAction")<CR>')
  -- map("n", "<A-j>", '<Cmd>call VSCodeCall("editor.action.moveLinesDownAction")<CR>')
  
  -- -- Actions
  -- map("n", "<C-:>", '<Cmd>call VSCodeCall("workbench.action.showCommands")<CR>')
  
  -- -- go to file in path
  -- map("n", "<C-p>", '<Cmd>call VSCodeCall("workbench.action.quickOpen")<CR>')
  
  -- -- go to symbol in path
  -- map("n", "<C-/>", '<Cmd>call VSCodeCall("workbench.action.gotoSymbol")<CR>')
  
  -- -- find in path
  -- map("n", "<C-f>", '<Cmd>call VSCodeCall("workbench.action.findInFiles")<CR>')

  -- -- replace in path
  -- map("n", "<C-S-f>", '<Cmd>call VSCodeCall("workbench.action.replaceInFiles")<CR>')
  
  --   C-A-a - Show commands
  --   C-A-n - New file
  --   C-A-r - Open recent 
  --   C-p - Open file in workspace
  --   C-s - Save file
  --   C-S-s - Save as...
  
  -- VSCode Keybindings
  --  C-. - Code Actions
  --  C-k c - compare with clipboard
  --  C-
    
    
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

  -- vim.api.nvim_set_keymap('n', 'gr',
  --   "<cmd>call VSCodeCall('editor.action.goToReferences')<CR>",
  --   {noremap = true, silent = true})
  -- vim.api.nvim_set_keymap('n', 'gn',
  --   "<cmd>call VSCodeCall('editor.action.rename')<CR>",
  --   {noremap = true, silent = true})
  --
  -- vim.api.nvim_set_keymap('n', ']d',
  --   "<cmd>call VSCodeCall('editor.action.marker.next')<CR>",
  --   {noremap = true, silent = true})
  -- vim.api.nvim_set_keymap('n', '[d',
  --   "<cmd>call VSCodeCall('editor.action.marker.prev')<CR>",
  --   {noremap = true, silent = true})
  -- vim.api.nvim_set_keymap('n', '[c',
  --   "<cmd>call VSCodeCall('workbench.action.editor.previousChange')<CR>",
  --   {noremap = true, silent = true})
  -- vim.api.nvim_set_keymap('n', ']c',
  --   "<cmd>call VSCodeCall('workbench.action.editor.nextChange')<CR>",
  --   {noremap = true, silent = true})
  --
  -- vim.api.nvim_set_keymap('n', '<C-h>',
  --   "<cmd>call VSCodeCall('workbench.action.focusPreviousGroup')<CR>",
  --   {noremap = true, silent = true})
  -- vim.api.nvim_set_keymap('n', '<C-j>',
  --   "<cmd>call VSCodeCall('workbench.action.focusBelowGroup')<CR>",
  --   {noremap = true, silent = true})
  -- vim.api.nvim_set_keymap('n', '<C-k>',
  --   "<cmd>call VSCodeCall('workbench.action.focusAboveGroup')<CR>",
  --   {noremap = true, silent = true})
  -- vim.api.nvim_set_keymap('n', '<C-l>',
  --   "<cmd>call VSCodeCall('workbench.action.focusNextGroup')<CR>",
  --   {noremap = true, silent = true})
  --
  -- vim.api.nvim_set_keymap('n', ']t',
  --   "<cmd>call VSCodeCall('workbench.action.nextEditorInGroup')<CR>",
  --   {noremap = true, silent = true})
  -- vim.api.nvim_set_keymap('n', '[t',
  --   "<cmd>call VSCodeCall('workbench.action.previousEditorInGroup')<CR>",
  --   {noremap = true, silent = true})
  --
  -- vim.api.nvim_set_keymap('n', 'gt',
  --   "<cmd>call VSCodeCall('workbench.action.terminal.toggleTerminal')<CR>",
  --   {noremap = true, silent = true})
else
  -- two lines above works in vscode, the lines below works in neovim
  vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*",
    callback = function()
      vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end,
  })
end
