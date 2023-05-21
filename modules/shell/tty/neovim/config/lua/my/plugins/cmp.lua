local ok, cmp = pcall(require, 'cmp')

if not ok then
  error("Failed to load cmp")
  return
end

local ok, luasnip = pcall(require, 'luasnip')

if not ok then
  error("Failed to load luasnip")
  return
end

local ok, lspkind = pcall(require, 'lspkind')

if not ok then
  error("Failed to load lspkind")
  return
end

local icons = {
  Class = 'ﴯ',
  Color = '',
  Constant = '',
  Constructor = '⌘',
  Enum = '',
  EnumMember = '',
  Event = '',
  Field = 'ﰠ',
  File = '',
  Folder = '',
  Function = '',
  Interface = '',
  Keyword = '',
  Method = '',
  Module = '',
  Operator = '',
  Property = 'ﰠ',
  Reference = '',
  Snippet = '',
  Struct = 'פּ',
  Text = '',
  TypeParameter = '',
  Unit = '',
  Value = '',
  Variable = '',
}

local menu = {
  buffer = 'Buffer',
  nvim_lsp = 'LSP',
  luasnip = 'Luasnip',
  nvim_lua = 'Lua',
  path = 'Path',
  cmdline = 'Command',
  nvim_lsp_signature_help = 'LSP Signature Help',
  cmdline_history = 'Command History',
}

-- Borrowed from AstroNvim configuration of cmp plugin
local function has_words_before()
  local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
end


cmp.setup {
  experimental = {
    native_menu = false,
    ghost_text = true,
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
    keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
    keyword_length = 1,
  },
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = lspkind.cmp_format {
      mode = 'symbol_text', -- show only symbol annotations
      maxwidth = 75, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...',
      menu = menu,
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function(_, vim_item)
        vim_item.kind = icons[vim_item.kind]
        return vim_item
      end,
    },
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<Up>'] = cmp.mapping.select_prev_item(),
    ['<Down>'] = cmp.mapping.select_next_item(),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 's' }),
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(1), { 'i', 'c' }),
    ['<C-q>'] = cmp.mapping.close(),
    ["<Tab>"] = cmp.mapping(function(fallback)
      -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
      if cmp.visible() then
        local entry = cmp.get_selected_entry()
	      if not entry then
	        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
	      end 
	      cmp.confirm()
        if luasnip.expandable() then
          luasnip.expand()
        end
      else
        fallback()
      end
    end, {"i","s","c",}),
    ['<C-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<CR>'] = cmp.mapping.confirm { select = true },
  },
  sources = {
    { name = 'cmp_tabnine', priority = 1250 },
    { name = 'nvim_lsp_signature_help', priority = 1250 },
    { name = 'luasnip', priority = 1000 },
    { name = 'nvim_lsp', priority = 750 },
    {
      name = 'buffer',
      option = {
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
      priority = 500,
    },
    { name = 'path' },
    { name = 'nvim_lua' },
  },
  preselect = cmp.PreselectMode.None,
}

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  },
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources {
    { name = 'cmdline' },
    { name = 'cmdline_history' },
    { name = 'path' },
  },
})
