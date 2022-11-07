M = {
  config = function()
    require('noice').setup({
      lsp = {
        progress = {
          enabled = false
        },
      },
    })
  end,
}

return M
