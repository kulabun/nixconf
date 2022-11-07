M = {
  config = function()
    local ok, treesitter = pcall(require, 'nvim-treesitter.configs')
    
    if not ok then
      error("Failed to load treesitter") 
      return
    end

    require("nvim-treesitter.configs").setup {
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
        "typescript"
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
    }
  end,
}

return M
