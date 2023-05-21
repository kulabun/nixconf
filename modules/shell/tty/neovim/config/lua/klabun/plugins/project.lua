M = {}

M.config = function()
  local ok, telescope = pcall(require, "telescope")
  if ok then
    telescope.load_extension("projects")
  end

  require("project_nvim").setup({
    detection_methods = { "pattern" },
    patterns = {
      -- version control
      ".git",
      "_darcs",
      ".hg",
      ".bzr",
      ".svn",
      -- c
      "Makefile",
      -- javascript
      "package.json",
      -- rust
      "Cargo.toml",
      -- go
      "go.mod",
      -- python
      "requirements.txt",
      "pyproject.toml",
      "setup.py",
      -- java
      "mvnw",
      "gradlew",
    },
    manual_mode = false,
    exclude_dirs = {},
    silent_chdir = true,
    scope_chdir = "global",
    datapath = vim.fn.stdpath("data"),
  })
end

return M
