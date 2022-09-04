local M = {}

M.diffview = {
  n = {
    ["<leader>gv"] = { "<cmd> :DiffviewOpen<CR>", "Open DiffView", opts = { nowait = true } },
    ["<leader>gx"] = { "<cmd> :DiffviewClose<CR>", "Close DiffView" },
    ["<leader>gh"] = { "<cmd> :DiffviewFileHistory %<CR>", "Open File History", opts = { nowait = true } },
  },
}

M.telescope = {
  n = {
    ["<C-t>"] = { ":Telescope <CR>" },
    ["<C-p>"] = { ":Telescope find_files<CR>" },
    ["<C-f>"] = { ":Telescope live_grep<CR>" },
    ["<C-b>"] = { ":Telescope buffers<CR>" },
  },
}

M.hop = {
  n = {
    ["f"] = { "<cmd>lua require'hop'.hint_words({})<cr>" },
    ["F"] = { "<cmd>lua require'hop'.hint_char1({})<cr>" },
  },
  v = {
    ["f"] = { "<cmd>lua require'hop'.hint_words({})<cr>" },
    ["F"] = { "<cmd>lua require'hop'.hint_char1({})<cr>" },
  },
}

M.null_ls = {
  n = {
    ["<C-l>"] = { "<cmd>lua vim.lsp.buf.formatting()<cr>" },
  },
}

M.trouble = {
  n = {
    ["<C-q>"] = { "<cmd> TroubleToggle <CR>", "[Custom] toggle LSP errors window" },
  },
}

M.general = {
  n = {
    ["<C-w>"] = { ":bd<cr>", "[Custom] close buffer" },
    ["<C-j>"] = { ":bprevious<cr>", "[Custom] previous buffer" },
    ["<C-k>"] = { ":bnext<cr>", "[Custom] next buffer" },
  },
  v = {
    ["Y"] = { '"+y' },
  },
}

return M
