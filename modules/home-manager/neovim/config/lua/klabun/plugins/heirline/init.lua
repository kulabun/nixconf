local M = {
  config = function()
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")
    local sl = require("klabun.plugins.heirline.statusline")
    local tl = require("klabun.plugins.heirline.tabline")

    local colors = require("monokaipro.colors").setup()
    require('heirline').load_colors(colors)

    local Align = { provider = "%=" }
    local Space = { provider = " " }
    local Split = { provider = " | ", hl = { fg = "gray_dark", bg = "bg_dark" } }

    local statusline = {
      Space,
      sl.vi_mode(), Split, 
      sl.git(), Split,
      sl.diagnostics(), Split,

      Align,

      Split,
      sl.language_server(), Split,
      sl.linter(), Split,
      sl.formatter(), Split,
      sl.treesitter(), Split, 
      sl.copilot(), Split, 
      sl.file_encoding(), Split, 
      sl.file_system(), Split, 
      sl.ruler(), Space, 
    }
    local winbar = {}
    local tabline = {

    }
    require('heirline').setup(statusline, winbar, tabline)
  end
}

return M
