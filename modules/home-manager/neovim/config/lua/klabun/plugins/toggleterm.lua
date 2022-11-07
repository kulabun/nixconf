M = {
  config = function()
    require("toggleterm").setup{
      size = 20,
      autochdir = true, -- when neovim changes it current directory the terminal will change it's own when next it's opened
      direction = 'float',
      close_on_exit = true, -- close the terminal window when the process exits
      auto_scroll = true, -- automatically scroll to the bottom on terminal output
    }
  end
}

return M
