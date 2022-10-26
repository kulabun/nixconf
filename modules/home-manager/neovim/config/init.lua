--              AstroNvim Configuration Table
-- All configuration changes should go inside of the table below

-- You can think of a Lua "table" as a dictionary like data structure the
-- normal format is "key = value". These also handle array like data structures
-- where a value with no key simply has an implicit numeric key
local config = {

	-- Set colorscheme to use
	colorscheme = "monokaipro",

	-- set vim options here (vim.<first_key>.<second_key> =  value)
	options = {
		opt = {
			autoindent = true,
			clipboard = "unnamedplus",
			cmdheight = 1,
			expandtab = true,
			hidden = true,
			ignorecase = true,
			modifiable = true,
			mouse = "a",
			number = true,
			numberwidth = 2,
			relativenumber = true,
			ruler = false,
			scrolloff = 12,
			shiftwidth = 2,
			signcolumn = "auto",
			smartindent = true,
			smarttab = true,
			softtabstop = 4,
			spell = false,
			splitbelow = true,
			splitright = true,
			tabstop = 4,
			textwidth = 0,
			timeoutlen = 400,
			undofile = true,
			updatetime = 250,
			whichwrap = "<,>",
			wildignorecase = true,
			wrap = false,
			wrapmargin = 1,
			formatoptions = "cq",

			-- Highlight columns to see line length
			colorcolumn = { 120 },

			-- Show invisible characters
			list = true,
			listchars = { tab = "->", space = "·", trail = "·" },
		},
		g = {
			mapleader = " ", -- sets vim.g.mapleader
			autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
			cmp_enabled = true, -- enable completion at start
			autopairs_enabled = true, -- enable autopairs at start
			diagnostics_enabled = true, -- enable diagnostics at start
			status_diagnostics_enabled = true, -- enable diagnostics in statusline
			icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
		},
	},
	-- If you need more control, you can use the function()...end notation
	-- options = function(local_vim)
	--   local_vim.opt.relativenumber = true
	--   local_vim.g.mapleader = " "
	--   local_vim.opt.whichwrap = vim.opt.whichwrap - { 'b', 's' } -- removing option from list
	--   local_vim.opt.shortmess = vim.opt.shortmess + { I = true } -- add to option list
	--
	--   return local_vim
	-- end,

	-- Set dashboard header
	header = {
		" █████  ███████ ████████ ██████   ██████",
		"██   ██ ██         ██    ██   ██ ██    ██",
		"███████ ███████    ██    ██████  ██    ██",
		"██   ██      ██    ██    ██   ██ ██    ██",
		"██   ██ ███████    ██    ██   ██  ██████",
		" ",
		"    ███    ██ ██    ██ ██ ███    ███",
		"    ████   ██ ██    ██ ██ ████  ████",
		"    ██ ██  ██ ██    ██ ██ ██ ████ ██",
		"    ██  ██ ██  ██  ██  ██ ██  ██  ██",
		"    ██   ████   ████   ██ ██      ██",
	},

	-- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
	diagnostics = {
		virtual_text = true,
		underline = true,
	},

	-- Extend LSP configuration
	lsp = {
		-- enable servers that you already have installed without mason
		servers = {
			"sumneko_lua",

			-- shell
			"bashls",

			-- nix
			"rnix",

			-- rust
			"rust_analyzer",

			-- python
			--"pyright",

			-- "jsonls",
			-- "yamlls",
		},
		formatting = {
			-- control auto formatting on save
			format_on_save = {
				enabled = true, -- enable or disable format on save globally
				disable_filetypes = { -- disable format on save for specified filetypes
					-- "python",
				},
			},
			disabled = { -- disable formatting capabilities for the listed language servers
				-- "sumneko_lua",
			},
			timeout_ms = 1000, -- default format timeout
			-- filter = function(client) -- fully override the default formatting function
			--   return true
			-- end
		},
		-- easily add or disable built in mappings added during LSP attaching
		mappings = {
			n = {
				-- ["<leader>lf"] = false -- disable formatting keymap
			},
		},
		-- add to the global LSP on_attach function
		-- on_attach = function(client, bufnr)
		-- end,

		-- override the mason server-registration function
		-- server_registration = function(server, opts)
		--   require("lspconfig")[server].setup(opts)
		-- end,

		-- Add overrides for LSP server settings, the keys are the name of the server
		["server-settings"] = {
			-- example for addings schemas to yamlls
			-- yamlls = { -- override table for require("lspconfig").yamlls.setup({...})
			--   settings = {
			--     yaml = {
			--       schemas = {
			--         ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
			--         ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
			--         ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
			--       },
			--     },
			--   },
			-- },
		},
	},

	-- Mapping data with "desc" stored directly by vim.keymap.set().
	--
	-- Please use this mappings table to set keyboard mapping since this is the
	-- lower level configuration and more robust one. (which-key will
	-- automatically pick-up stored data by this setting.)
	mappings = {
		-- first key is the mode
		n = {
			-- second key is the lefthand side of the map
			-- mappings seen under group name "Buffer"
			["<leader>bb"] = { "<cmd>tabnew<cr>", desc = "New tab" },
			["<leader>bc"] = { "<cmd>BufferLinePickClose<cr>", desc = "Pick to close" },
			["<leader>bj"] = { "<cmd>BufferLinePick<cr>", desc = "Pick to jump" },
			["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },
			-- quick save
			-- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
		},
		t = {
			-- setting a mapping to false will disable it
			-- ["<esc>"] = false,
		},
	},

	-- Configure plugins
	plugins = {
		init = {
			{ "https://gitlab.com/__tpb/monokai-pro.nvim" },
			{ "tpope/vim-surround" },
			-- You can disable default plugins as follows:
			-- ["goolord/alpha-nvim"] = { disable = true },

			-- You can also add new plugins here as well:
			-- Add plugins, the packer syntax without the "use"
			-- { "andweeb/presence.nvim" },
			-- {
			--   "ray-x/lsp_signature.nvim",
			--   event = "BufRead",
			--   config = function()
			--     require("lsp_signature").setup()
			--   end,
			-- },

			-- We also support a key value style plugin definition similar to NvChad:
			-- ["ray-x/lsp_signature.nvim"] = {
			--   event = "BufRead",
			--   config = function()
			--     require("lsp_signature").setup()
			--   end,
			-- },
		},
		-- All other entries override the require("<key>").setup({...}) call for default plugins
		["null-ls"] = function(config) -- overrides `require("null-ls").setup(config)`
			-- config variable is the default configuration table for the setup function call
			local null_ls = require("null-ls")

			-- Check supported formatters and linters
			-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
			-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
			config.sources = {
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
			}
			return config -- return final config table
		end,
		treesitter = { -- overrides `require("treesitter").setup(...)`
			ensure_installed = {
				"lua",
				"java",
				"rust",
				"python",
				"bash",

				"markdown",
				"json",
				"yaml",
				"toml",

				"dockerfile",
				"nix",
				"gitignore",

				"hcl",
				"proto",

				"html",
				"pug",
				"css",
				"scss",
				"javascript",
				"tsx",
				"typescript",
			},
		},
		["mason-lspconfig"] = { disable = true },
		["mason-null-ls"] = { disable = true },
		["rafamadriz/friendly-snippets"] = { disable = true },
	},

	-- LuaSnip Options
	luasnip = {
		-- Add paths for including more VS Code style snippets in luasnip
		vscode_snippet_paths = {
			"./lua/user/snippets",
		},
		-- Extend filetypes
		filetype_extend = {
			-- javascript = { "javascriptreact" },
		},
	},

	-- CMP Source Priorities
	-- modify here the priorities of default cmp sources
	-- higher value == higher priority
	-- The value can also be set to a boolean for disabling default sources:
	-- false == disabled
	-- true == 1000
	cmp = {
		source_priority = {
			nvim_lsp = 1000,
			luasnip = 750,
			buffer = 500,
			path = 250,
		},
	},

	-- Modify which-key registration (Use this with mappings table in the above.)
	["which-key"] = {
		-- Add bindings which show up as group name
		register = {
			-- first key is the mode, n == normal mode
			n = {
				-- second key is the prefix, <leader> prefixes
				["<leader>"] = {
					-- third key is the key to bring up next level and its displayed
					-- group name in which-key top level menu
					["b"] = { name = "Buffer" },
				},
			},
		},
	},

	-- This function is run last and is a good place to configuring
	-- augroups/autocommands and custom filetypes also this just pure lua so
	-- anything that doesn't fit in the normal config locations above can go here
	polish = function()
		-- Disable comment new line
		vim.api.nvim_create_autocmd("BufWinEnter", {
			pattern = "*",
			callback = function()
				vim.opt_local.formatoptions:remove({ "c", "r", "o" })
			end,
		})
		-- Set up custom filetypes
		-- vim.filetype.add {
		--   extension = {
		--     foo = "fooscript",
		--   },
		--   filename = {
		--     ["Foofile"] = "fooscript",
		--   },
		--   pattern = {
		--     ["~/%.config/foo/.*"] = "fooscript",
		--   },
		-- }
	end,
}

return config
