local M = {
  config = function()
    local heirline = require("heirline")

    local colors = require("monokaipro.colors").setup()
    heirline.load_colors(colors)

    local statusline = require("klabun.plugins.heirline.statusline")
    heirline.setup(statusline)
  end
}

return M
