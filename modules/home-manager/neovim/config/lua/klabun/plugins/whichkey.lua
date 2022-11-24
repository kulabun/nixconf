M = {
  config = function()
    local cfg = {
      key_labels = {
        ["<space>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB",
      },
    }
    require("which-key").setup(cfg)
  end,
}

return M
