M = {}

M.config = function()
  require("bufferline").setup({
    options = {
      numbers = "ordinal",
      max_name_length = 20,
      max_prefix_length = 15,
    },
  })
end

return M
