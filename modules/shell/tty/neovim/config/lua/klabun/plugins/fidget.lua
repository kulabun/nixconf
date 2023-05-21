M = {}

M.config = function()
  require("fidget").setup({  
    window = { 
      blend = 0,
      zindex = 1000, -- without this, the text will be dimmed by the statusline
    } 
  })
end

return M
