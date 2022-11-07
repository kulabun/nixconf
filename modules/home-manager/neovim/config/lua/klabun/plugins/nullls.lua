M = {
	root_dir = require("null-ls.utils").root_pattern(".git"),
	config = function()
		local null_ls = require("null-ls")
		require("null-ls").setup({
			sources = {
				-- ----------------------------------------------------
				-- Formatters
				-- ----------------------------------------------------
				-- javascript, typescript, json, css, scss, html, yaml, markdown, graphql
				null_ls.builtins.formatting.prettier,
				-- c
				null_ls.builtins.formatting.clang_format,
				-- json
				null_ls.builtins.formatting.jq,
				-- go
				null_ls.builtins.formatting.gofmt,
				-- rust
				null_ls.builtins.formatting.rustfmt.with({ extra_args = { "--edition=2021" } }),
				-- nix
				null_ls.builtins.formatting.alejandra,
				-- toml
				null_ls.builtins.formatting.taplo,
				-- terraform
				null_ls.builtins.formatting.terraform_fmt,
				-- bash
				null_ls.builtins.formatting.shfmt,
				-- generic
				null_ls.builtins.formatting.trim_newlines,
				null_ls.builtins.formatting.trim_whitespace,
				-- lua
				null_ls.builtins.formatting.stylua,
				-- python
				null_ls.builtins.formatting.black,

				-- ----------------------------------------------------
				-- Diagnostics
				-- ----------------------------------------------------
				-- typescript
				null_ls.builtins.diagnostics.tsc,
				-- c
				null_ls.builtins.diagnostics.clang_check,
				-- nix
				null_ls.builtins.diagnostics.statix,
				-- bash
				null_ls.builtins.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
				null_ls.builtins.diagnostics.zsh,
				-- lua
				null_ls.builtins.diagnostics.luacheck.with({ extra_args = { "--global vim" } }),
				-- todo comments
				null_ls.builtins.diagnostics.todo_comments,

				-- ----------------------------------------------------
				-- Code Actions
				-- ----------------------------------------------------
				-- HTML, CSS, JavaScript, Typescript
				null_ls.builtins.code_actions.eslint,
				-- nix
				null_ls.builtins.code_actions.statix,
				-- bash
				null_ls.builtins.code_actions.shellcheck,
				-- git
				null_ls.builtins.code_actions.gitsigns,
				null_ls.builtins.code_actions.gitrebase,

				-- ----------------------------------------------------
				-- Completions
				-- ----------------------------------------------------
				null_ls.builtins.completion.luasnip,
				null_ls.builtins.completion.spell,

				-- ----------------------------------------------------
				-- Hover
				-- ----------------------------------------------------
				-- Text, Markdown
				null_ls.builtins.hover.dictionary,
				-- bash
				null_ls.builtins.hover.printenv,
			},
		})
	end,
}

return M
