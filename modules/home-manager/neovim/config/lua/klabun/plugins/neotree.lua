M = {
  config = function()
    require("neo-tree").setup({
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = true,
          hide_gitignored = false,
          hide_hidden = true,
          hide_by_name = {
            "node_modules",
            ".git",
            ".cache",
            ".DS_Store",
            ".vscode",
            ".idea",
            "target",
            "dist",
            "build",
            "vendor",
            "bin",
            "obj",
            "out",
          },
          hide_by_pattern = {
            "*.class",
            "*.o",
          },
          always_show = {
            ".gitignored",
          },
          never_show = {},
          never_show_by_pattern = {},
        },
      },
    })
  end,
}

return M
