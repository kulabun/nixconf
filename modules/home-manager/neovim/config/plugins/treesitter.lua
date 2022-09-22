local M = {
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
    
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  indent = {
    enable = true,
  },
}


return M
