M = {
	after = "nvim-lspconfig",
	requires = { "nvim-lua/plenary.nvim" },
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			debug = true,
			sources = {
				-- C
				null_ls.builtins.formatting.clang_format,
				null_ls.builtins.diagnostics.clang_check,

				-- HTML, CSS, JavaScript, Typescript
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.code_actions.eslint,
				null_ls.builtins.diagnostics.tsc,

				-- JSON
				null_ls.builtins.formatting.jq,

				-- Go
				null_ls.builtins.formatting.gofmt,

				-- Rust
				null_ls.builtins.formatting.rustfmt.with({ extra_args = { "--edition=2018" } }),

				-- Nix
				null_ls.builtins.formatting.alejandra,
				null_ls.builtins.code_actions.statix,
				null_ls.builtins.diagnostics.statix,

				-- Toml
				null_ls.builtins.formatting.taplo,

				-- Shell
				null_ls.builtins.formatting.shfmt,
				null_ls.builtins.code_actions.shellcheck,
				null_ls.builtins.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
				null_ls.builtins.diagnostics.zsh,
				null_ls.builtins.hover.printenv,

				-- Yaml

				-- Terraform
				null_ls.builtins.formatting.terraform_fmt,

				-- Python
				null_ls.builtins.formatting.black,

				-- Lua
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.diagnostics.luacheck.with({ extra_args = { "--global vim" } }),

				-- Text, Markdown
				null_ls.builtins.hover.dictionary,

				-- Generic Builtints
				null_ls.builtins.formatting.trim_newlines,
				null_ls.builtins.formatting.trim_whitespace,
				null_ls.builtins.code_actions.gitsigns,
				null_ls.builtins.code_actions.gitrebase,
				null_ls.builtins.completion.luasnip,
				null_ls.builtins.completion.spell,
				null_ls.builtins.diagnostics.todo_comments,
			},
		})
	end,
	on_attach = function()
		-- for 0.8.0 nvim
		--vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ bufnr = bufnr })"
		vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
	end,
}

return M
