M = {
  config = function() 
    vim.cmd[[colorscheme monokaipro]]
    vim.g.monokaipro_flat_term = true
    --vim.g.monokaipro_filter = "default"
    --vim.g.monokaipro_italic_functions = true
    --vim.g.monokaipro_sidebars = { "vista_kind", "packer" }
  end
}

return M
