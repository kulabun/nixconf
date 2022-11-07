require 'my.core.utils'
--require 'my.core.settings'
require 'my.core.packer'

-- my.settings
-- plugins
--  tree-sitter
--  lsp
--  telescope
--  nvim-tree
--  nvim-notify
--  trouble
--  dashboard
--  lspkind
--  nvim-cmp
--  nvim-autopairs
--  nvim-colorizer
--  nvim-comment
--  nvim-dap
--  nvim-dap-ui
--  nvim-lspconfig


local ok, settings = pcall(require, "my.settings")
if not ok then
  error("Failed to read settings")
  return
end

for group_key, group in pairs(settings.options) do
    for key, value in pairs(group) do
      vim[group_key][key] = value
    end
end

local sources = {
  'my.core.packer',
}

for _, source in ipairs(sources) do
  local ok, res = pcall(require, source)
  if not ok then
    error('Failed to load ' .. source .. '\n\n' .. res)
  end
  
  if res["init"] then
    res.init(settings)
  end
end

local ok, _ = pcall(vim.cmd, "colorscheme " .. settings.colorscheme)
if not ok then
  error("Colorscheme " .. settings.colorscheme .. " not found!")
end


local sources = {
--  'lsp',
--  'mappings',
  'my.autocmds',
--  'plugins',
}

for _, source in ipairs(sources) do
  local ok, err = pcall(require, source)
  if not ok then
    error('Failed to load ' .. source .. '\n\n' .. err)
  end
end


