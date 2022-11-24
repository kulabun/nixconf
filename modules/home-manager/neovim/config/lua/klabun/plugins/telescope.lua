M = {
  config = function()
    local telescope = require('telescope')
    telescope.setup({
    })
    telescope.load_extension("ui-select")
  end,
}

return M
