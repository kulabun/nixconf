M = {
  config = function()
    require('neogit').setup {
      disable_signs = false,
      integrations = {
        diffview = true
      },
      signs = {
        -- { CLOSED, OPENED }
        section = { ">", "v" },
        item = { ">", "v" },
        hunk = { "", "" },
      },
    }
  end
}

return M
