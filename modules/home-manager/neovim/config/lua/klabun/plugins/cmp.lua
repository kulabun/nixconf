M = {}

M.config = function()
  local cmp = require("cmp")
  local lspkind = require("lspkind")
  vim.cmd("set completeopt=menu,menuone,noselect")
  cmp.setup({
    formatting = {
      format = lspkind.cmp_format({
        mode = "symbol",
        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      }),
    },
    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
    },
    sources = {
      { name = "luasnip", priority = 1500 }, -- snippets
      { name = "path", priority = 1250 }, -- path completion
      { name = "nvim_lsp", priority = 1000 }, -- lsp based completion
      { name = "calc", priority = 300 }, -- calculator
      { name = "buffer", priority = 200 }, -- buffer based completion
      { name = "emoji", priority = 100 }, -- smiles
    },
  })
end

return M
