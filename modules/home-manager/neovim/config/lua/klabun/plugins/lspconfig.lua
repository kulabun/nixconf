M = {}

M.config = function()
	local servers = {
		-- lua
		"sumneko_lua",
		-- shell
		"bashls",
		-- nix
		"rnix",
		-- rust
		"rust_analyzer",
		-- python
		"pylsp",
		-- go
		"gopls",
		-- javascript
		"eslint",
		-- typescript
		"tsserver",
		-- html
		"html",
		-- css
		"cssls",
    -- json
		"jsonls",
		-- yaml
		"yamlls",
	}
	has_cmp, cmp = pcall(require, "cmp_nvim_lsp")
	local lsp_config = {}
	if has_cmp then
	  lsp_config["capabilities"] = cmp.default_capabilities()
	end
	for _, lsp in ipairs(servers) do
		require("lspconfig")[lsp].setup(lsp_config)
	end
end

return M
