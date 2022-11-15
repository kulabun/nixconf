local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

local packer = require("packer")

packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "single" })
    end,
    prompt_border = "single",
  },
  git = {
    clone_timeout = 600,
  },
  auto_clean = true,
  compile_on_sync = true,
})

packer.startup(function(use)
  -- -----------------------------------------------
  -- System
  -- -----------------------------------------------
  use("wbthomason/packer.nvim") -- package manager
  use("nathom/filetype.nvim") -- speed up file type pluging loading

  -- -----------------------------------------------
  -- UI
  -- -----------------------------------------------
  -- theme
  use({
    "https://gitlab.com/__tpb/monokai-pro.nvim",
    config = require("klabun.plugins.monokaipro").config,
  })
  -- use({
  --   "sainnhe/sonokai",
  --   config = require("klabun.plugins.sonokai").config,
  -- })

  -- notifications, popups
  use({
    "folke/noice.nvim",
    requires = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = require("klabun.plugins.noice").config,
  })
  -- statusbar and tabline
  use({
    "rebelot/heirline.nvim",
    requires = {
      "kyazdani42/nvim-web-devicons",
      "lewis6991/gitsigns.nvim",
    },
    config = require("klabun.plugins.heirline").config,
  })
  -- display LSP status
  use({
    "j-hui/fidget.nvim",
    config = require("klabun.plugins.fidget").config,
    highlights = require("klabun.plugins.fidget").highlights,
  })
  -- quickfix panel
  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = require("klabun.plugins.trouble").config,
  })
  -- add icons to autocomplete menu
  use({
    "onsails/lspkind.nvim",
    config = require("klabun.plugins.lspkind").config,
  })
  use({
    "akinsho/bufferline.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = require("klabun.plugins.bufferline").config,
  })
  -- use({
  --   "feline-nvim/feline.nvim",
  --   requires = {
  --     "kyazdani42/nvim-web-devicons",
  --     "lewis6991/gitsigns.nvim",
  --   },
  --   config = require("klabun.plugins.feline").config,
  -- })

  -- -----------------------------------------------
  -- Git
  -- -----------------------------------------------
  use({
    "lewis6991/gitsigns.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
    },
    config = require("klabun.plugins.gitsigns").config,
  })
  use({
    "akinsho/git-conflict.nvim",
    config = require("klabun.plugins.gitconflict").config,
  })

  -- -----------------------------------------------
  -- Highlight indentation level
  -- -----------------------------------------------
  use({
    "lukas-reineke/indent-blankline.nvim",
    config = require("klabun.plugins.indentblankline").config,
  })

  -- -----------------------------------------------
  -- Terminal
  -- -----------------------------------------------
  use({
    "akinsho/toggleterm.nvim",
    config = require("klabun.plugins.toggleterm").config,
  })

  -- -----------------------------------------------
  -- Syntax
  -- -----------------------------------------------
  use({
    "nvim-treesitter/nvim-treesitter",
    requires = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-context",
      "nvim-treesitter/playground",
    },
    config = require("klabun.plugins.treesitter").config,
  })
  use({
    "folke/todo-comments.nvim", 
    requires = {
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
    },
    config = require("klabun.plugins.todocomments").config,
  })

  -- -----------------------------------------------
  -- Jump the code(easy motion)
  -- -----------------------------------------------
  use({
    "ggandor/leap.nvim",
    config = require("klabun.plugins.leap").config,
  })

  -- -----------------------------------------------
  -- Comments
  -- -----------------------------------------------
  use({
    "numToStr/Comment.nvim",
    config = require("klabun.plugins.comment").config,
  })

  -- -----------------------------------------------
  -- Keymap popup
  -- -----------------------------------------------
  use({
    "folke/which-key.nvim",
    config = require("klabun.plugins.whichkey").config,
  })

  -- -----------------------------------------------
  -- Session management
  -- -----------------------------------------------
  use({
    "Shatur/neovim-session-manager",
    config = require("klabun.plugins.sessionmanager").config,
  })

  -- -----------------------------------------------
  -- Files Manager
  -- -----------------------------------------------
  use({
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    setup = function()
      vim.g.neo_tree_remove_legacy_commands = true
    end,
    config = require("klabun.plugins.neotree").config,
  })

  -- -----------------------------------------------
  -- Fuzzy Search
  -- -----------------------------------------------
  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = require("klabun.plugins.telescope").config,
  })

  -- -----------------------------------------------
  -- Null-ls
  -- -----------------------------------------------
  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    config = require("klabun.plugins.nullls").config,
  })

  -- -----------------------------------------------
  -- Editing
  -- -----------------------------------------------
  use({
    "kylechui/nvim-surround",
    config = require("klabun.plugins.surround").config,
  })

  -- -----------------------------------------------
  -- Editing
  -- -----------------------------------------------
  use({
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu",
    config = require("klabun.plugins.codeactionmenu").config,
  })
  -- use({
  --   "andymass/vim-matchup",
  -- })

  -- -----------------------------------------------
  -- Completion
  -- -----------------------------------------------
  use("github/copilot.vim")
  use({
    "neovim/nvim-lspconfig",
    config = require("klabun.plugins.lspconfig").config,
  })
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-emoji",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "onsails/lspkind-nvim",
    },
    config = require("klabun.plugins.cmp").config,
  })

  if packer_bootstrap then
    require("packer").sync()
  end
end)
