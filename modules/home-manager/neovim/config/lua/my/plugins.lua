M =
{ 
  plugins = {
    -- System
    {'wbthomason/packer.nvim'},
    {'lewis6991/impatient.nvim'},
    {'nathom/filetype.nvim'},
    {'nvim-lua/plenary.nvim'},

    -- UI
    {'https://gitlab.com/__tpb/monokai-pro.nvim'},

    {
      'lewis6991/gitsigns.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
    },

    -- Syntax
    {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = require 'plugins.treesitter',
    },

    -- Completion
    { 'L3MON4D3/LuaSnip' },
    {
      "tzachar/cmp-tabnine",
      run = "./install.sh",
      requires = "hrsh7th/nvim-cmp",
      config = function()
        astronvim.add_user_cmp_source("cmp_tabnine")
        local tabnine = require("cmp_tabnine.config")
        tabnine:setup({
          max_lines = 1000,
          max_num_results = 20,
          sort = true,
          run_on_every_keystroke = true,
          snippet_placeholder = "..",
          ignored_file_types = { -- default is not to ignore
            -- uncomment to ignore in lua:
            -- lua = true
          },
          show_prediction_strength = true,
        })
      end,
    },
    {
      'hrsh7th/nvim-cmp',
      requires = {
        'tzachar/cmp-tabnine',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'onsails/lspkind-nvim',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-nvim-lsp-document-symbol',
        'dmitmel/cmp-cmdline-history',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'rafamadriz/friendly-snippets',
      },
      config = require 'plugins.cmp',
    },
  },
}

return M
