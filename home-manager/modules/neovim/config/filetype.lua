local languages = {
  java = "java"
}

for lang,ext in pairs(languages) do
  local moduleName = "custom.ftplugins."..lang
  vim.cmd(string.format([[ autocmd FileType %s lua require("%s").setup() ]], ext, moduleName))
end
