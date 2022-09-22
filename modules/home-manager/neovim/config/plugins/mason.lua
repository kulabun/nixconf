local M = {
  -- For nixos binary installed this way can fail with file not found error due to libraries linking issues
  ensure_installed = {
    -- nix
    "rnix-lsp",
  },
}

return M
