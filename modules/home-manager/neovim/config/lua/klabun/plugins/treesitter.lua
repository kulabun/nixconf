M = {
  config = function()
    local ok, treesitter = pcall(require, "nvim-treesitter.configs")

    if not ok then
      error("Failed to load treesitter")
      return
    end

    treesitter.setup({
      ensure_installed = {
        "vim",

        -- programming
        "bash",
        "lua",
        "java",
        "rust",
        "python",
        "go",
        "gomod",
        "c",

        -- documents
        "markdown",
        "markdown_inline",

        -- data representation
        "json",
        "yaml",
        "toml",

        -- nix
        "nix",

        -- terraform
        "hcl",

        -- web dev
        "html",
        "pug",
        "css",
        "scss",
        "javascript",
        "tsx",
        "typescript",

        -- other
        "dockerfile",
        "gitignore",
        "proto",
        "regex",
        "comment",
      },
      sync_install = true,
      indent = {
        enable = true,
      },
      autotag = {
        enable = true,
      },
      rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = 1000,
      },
      context_commentstring = {
        enable = true,
      },
      matchup = {
        enable = true,
      },
      highlight = {
        enable = true,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },
      refactor = {
        navigation = {
          enable = true,
          keymaps = {
            goto_definition_lsp_fallback = "gd",
          },
        },
      },
    })
  end,
}

return M
