-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/konstantin/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/konstantin/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/konstantin/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/konstantin/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/konstantin/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Comment.nvim"] = {
    config = { "\27LJ\2\ni\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\nextra\1\0\0\1\0\3\nbelow\bgco\beol\bgcA\nabove\bgcO\nsetup\fComment\frequire\0" },
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  LuaSnip = {
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-calc"] = {
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/cmp-calc",
    url = "https://github.com/hrsh7th/cmp-calc"
  },
  ["cmp-emoji"] = {
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/cmp-emoji",
    url = "https://github.com/hrsh7th/cmp-emoji"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["copilot.vim"] = {
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/copilot.vim",
    url = "https://github.com/github/copilot.vim"
  },
  ["fidget.nvim"] = {
    config = { "\27LJ\2\n_\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\vwindow\1\0\0\1\0\2\vzindex\3è\a\nblend\3\0\nsetup\vfidget\frequire\0" },
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/fidget.nvim",
    url = "https://github.com/j-hui/fidget.nvim"
  },
  ["filetype.nvim"] = {
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/filetype.nvim",
    url = "https://github.com/nathom/filetype.nvim"
  },
  ["git-conflict.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17git-conflict\frequire\0" },
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/git-conflict.nvim",
    url = "https://github.com/akinsho/git-conflict.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["heirline.nvim"] = {
    config = { "\27LJ\2\nµ\5\0\0\16\0\25\0W6\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0026\2\0\0'\4\3\0B\2\2\0026\3\0\0'\5\4\0B\3\2\0026\4\0\0'\6\5\0B\4\2\0029\4\6\4B\4\1\0026\5\0\0'\a\a\0B\5\2\0029\5\b\5\18\a\4\0B\5\2\0015\5\t\0005\6\n\0005\a\v\0005\b\f\0=\b\r\a4\b\26\0>\6\1\b9\t\14\2B\t\1\2>\t\2\b>\a\3\b9\t\15\2B\t\1\2>\t\4\b>\a\5\b9\t\16\2B\t\1\2>\t\6\b>\a\a\b>\5\b\b>\a\t\b9\t\17\2B\t\1\2>\t\n\b>\a\v\b9\t\18\2B\t\1\2>\t\f\b>\a\r\b9\t\19\2B\t\1\2>\t\14\b>\a\15\b9\t\20\2B\t\1\2>\t\16\b>\a\17\b9\t\21\2B\t\1\2>\t\18\b>\a\19\b9\t\22\2B\t\1\2>\t\20\b>\a\21\b9\t\23\2B\t\1\2>\t\22\b>\a\23\b9\t\24\2B\t\1\2>\t\24\b>\6\25\b4\t\0\0004\n\0\0006\v\0\0'\r\a\0B\v\2\0029\v\6\v\18\r\b\0\18\14\t\0\18\15\n\0B\v\4\1K\0\1\0\nruler\16file_system\18file_encoding\fcopilot\15treesitter\14formatter\vlinter\20language_server\16diagnostics\bgit\fvi_mode\ahl\1\0\2\afg\14gray_dark\abg\fbg_dark\1\0\1\rprovider\b | \1\0\1\rprovider\6 \1\0\1\rprovider\a%=\16load_colors\rheirline\nsetup\22monokaipro.colors$klabun.plugins.heirline.tabline'klabun.plugins.heirline.statusline\19heirline.utils\24heirline.conditions\frequire\0" },
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/heirline.nvim",
    url = "https://github.com/rebelot/heirline.nvim"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\2\nw\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\25show_current_context\2\31show_current_context_start\2\nsetup\21indent_blankline\frequire\0" },
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["leap.nvim"] = {
    config = { "\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\25add_default_mappings\tleap\frequire\0" },
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/leap.nvim",
    url = "https://github.com/ggandor/leap.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/lspkind-nvim",
    url = "https://github.com/onsails/lspkind-nvim"
  },
  ["lspkind.nvim"] = {
    config = { "\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\tinit\flspkind\frequire\0" },
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/lspkind.nvim",
    url = "https://github.com/onsails/lspkind.nvim"
  },
  ["monokai-pro.nvim"] = {
    config = { "\27LJ\2\na\0\0\3\0\5\0\t6\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\0\0009\0\3\0+\1\2\0=\1\4\0K\0\1\0\25monokaipro_flat_term\6g\27colorscheme monokaipro\bcmd\bvim\0" },
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/monokai-pro.nvim",
    url = "https://gitlab.com/__tpb/monokai-pro.nvim"
  },
  ["neo-tree.nvim"] = {
    config = { "\27LJ\2\n\v\0\0\1\0\0\0\1K\0\1\0\0" },
    loaded = true,
    needs_bufread = false,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/opt/neo-tree.nvim",
    url = "https://github.com/nvim-neo-tree/neo-tree.nvim"
  },
  ["neovim-session-manager"] = {
    config = { "\27LJ\2\n\v\0\0\1\0\0\0\1K\0\1\0\0" },
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/neovim-session-manager",
    url = "https://github.com/Shatur/neovim-session-manager"
  },
  ["noice.nvim"] = {
    config = { "\27LJ\2\nf\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\blsp\1\0\0\rprogress\1\0\0\1\0\1\fenabled\1\nsetup\nnoice\frequire\0" },
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/noice.nvim",
    url = "https://github.com/folke/noice.nvim"
  },
  ["nui.nvim"] = {
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/nui.nvim",
    url = "https://github.com/MunifTanjim/nui.nvim"
  },
  ["null-ls.nvim"] = {
    config = { "\27LJ\2\næ\a\0\0\t\0-\0\0016\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\1\0B\1\2\0029\1\2\0015\3+\0004\4\30\0009\5\3\0009\5\4\0059\5\5\5>\5\1\0049\5\3\0009\5\4\0059\5\6\5>\5\2\0049\5\3\0009\5\4\0059\5\a\5>\5\3\0049\5\3\0009\5\4\0059\5\b\5>\5\4\0049\5\3\0009\5\4\0059\5\t\0059\5\n\0055\a\f\0005\b\v\0=\b\r\aB\5\2\2>\5\5\0049\5\3\0009\5\4\0059\5\14\5>\5\6\0049\5\3\0009\5\4\0059\5\15\5>\5\a\0049\5\3\0009\5\4\0059\5\16\5>\5\b\0049\5\3\0009\5\4\0059\5\17\5>\5\t\0049\5\3\0009\5\4\0059\5\18\5>\5\n\0049\5\3\0009\5\4\0059\5\19\5>\5\v\0049\5\3\0009\5\4\0059\5\20\5>\5\f\0049\5\3\0009\5\4\0059\5\21\5>\5\r\0049\5\3\0009\5\22\0059\5\23\5>\5\14\0049\5\3\0009\5\22\0059\5\24\5>\5\15\0049\5\3\0009\5\22\0059\5\25\5>\5\16\0049\5\3\0009\5\22\0059\5\26\0059\5\n\0055\a\27\0B\5\2\2>\5\17\0049\5\3\0009\5\22\0059\5\28\5>\5\18\0049\5\3\0009\5\22\0059\5\29\0059\5\n\0055\a\31\0005\b\30\0=\b\r\aB\5\2\2>\5\19\0049\5\3\0009\5\22\0059\5 \5>\5\20\0049\5\3\0009\5!\0059\5\"\5>\5\21\0049\5\3\0009\5!\0059\5\25\5>\5\22\0049\5\3\0009\5!\0059\5\26\5>\5\23\0049\5\3\0009\5!\0059\5#\5>\5\24\0049\5\3\0009\5!\0059\5$\5>\5\25\0049\5\3\0009\5%\0059\5&\5>\5\26\0049\5\3\0009\5%\0059\5'\5>\5\27\0049\5\3\0009\5(\0059\5)\5>\5\28\0049\5\3\0009\5(\0059\5*\5>\5\29\4=\4,\3B\1\2\1K\0\1\0\fsources\1\0\0\rprintenv\15dictionary\nhover\nspell\fluasnip\15completion\14gitrebase\rgitsigns\veslint\17code_actions\18todo_comments\1\0\0\1\2\0\0\17--global vim\rluacheck\bzsh\1\0\1\23diagnostics_format\16#{m} [#{c}]\15shellcheck\vstatix\16clang_check\btsc\16diagnostics\nblack\vstylua\20trim_whitespace\18trim_newlines\nshfmt\18terraform_fmt\ntaplo\14alejandra\15extra_args\1\0\0\1\2\0\0\19--edition=2021\twith\frustfmt\ngofmt\ajq\17clang_format\rprettier\15formatting\rbuiltins\nsetup\fnull-ls\frequire\0" },
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\n†\6\0\0\n\0'\0F6\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0026\2\3\0009\2\4\2'\4\5\0B\2\2\0019\2\6\0005\4\v\0005\5\t\0009\6\a\0015\b\b\0B\6\2\2=\6\n\5=\5\f\0045\5\15\0009\6\r\0009\6\14\6B\6\1\2=\6\16\0059\6\r\0009\6\17\6B\6\1\2=\6\18\0059\6\r\0009\6\19\6)\büÿB\6\2\2=\6\20\0059\6\r\0009\6\19\6)\b\4\0B\6\2\2=\6\21\0059\6\r\0009\6\22\6B\6\1\2=\6\23\0059\6\r\0009\6\24\6B\6\1\2=\6\25\0059\6\r\0009\6\26\0065\b\29\0009\t\27\0009\t\28\t=\t\30\bB\6\2\2=\6\31\5=\5\r\0044\5\a\0005\6 \0>\6\1\0055\6!\0>\6\2\0055\6\"\0>\6\3\0055\6#\0>\6\4\0055\6$\0>\6\5\0055\6%\0>\6\6\5=\5&\4B\2\2\1K\0\1\0\fsources\1\0\2\tname\nemoji\rpriority\3d\1\0\2\tname\vbuffer\rpriority\3È\1\1\0\2\tname\tcalc\rpriority\3¬\2\1\0\2\tname\rnvim_lsp\rpriority\3è\a\1\0\2\tname\tpath\rpriority\3â\t\1\0\2\tname\fluasnip\rpriority\3Ü\v\t<CR>\rbehavior\1\0\1\vselect\2\fReplace\20ConfirmBehavior\fconfirm\n<C-e>\nclose\14<C-Space>\rcomplete\n<C-f>\n<C-d>\16scroll_docs\n<C-n>\21select_next_item\n<C-p>\1\0\0\21select_prev_item\fmapping\15formatting\1\0\0\vformat\1\0\0\1\0\3\18ellipsis_char\b...\tmode\vsymbol\rmaxwidth\0032\15cmp_format\nsetup*set completeopt=menu,menuone,noselect\bcmd\bvim\flspkind\bcmp\frequire\0" },
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\n“\2\0\0\n\0\v\0\0295\0\0\0006\1\1\0006\3\2\0'\4\3\0B\1\3\0037\2\4\0007\1\5\0004\1\0\0006\2\5\0\15\0\2\0X\3\4€6\2\4\0009\2\a\2B\2\1\2=\2\6\0016\2\b\0\18\4\0\0B\2\2\4X\5\a€6\a\2\0'\t\t\0B\a\2\0028\a\6\a9\a\n\a\18\t\1\0B\a\2\1E\5\3\3R\5÷\127K\0\1\0\nsetup\14lspconfig\vipairs\25default_capabilities\17capabilities\fhas_cmp\bcmp\17cmp_nvim_lsp\frequire\npcall\1\a\0\0\16sumneko_lua\vbashls\trnix\18rust_analyzer\vjsonls\vyamlls\0" },
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-notify"] = {
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/nvim-notify",
    url = "https://github.com/rcarriga/nvim-notify"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\nÔ\4\0\0\6\0\21\0\0316\0\0\0006\2\1\0'\3\2\0B\0\3\3\14\0\0\0X\2\4€6\2\3\0'\4\4\0B\2\2\1K\0\1\0006\2\1\0'\4\2\0B\2\2\0029\2\5\0025\4\a\0005\5\6\0=\5\b\0045\5\t\0=\5\n\0045\5\v\0=\5\f\0045\5\r\0=\5\14\0045\5\15\0=\5\16\0045\5\17\0=\5\18\0045\5\19\0=\5\20\4B\2\2\1K\0\1\0\14highlight\1\0\2\venable\2&additional_vim_regex_highlighting\1\fmatchup\1\0\1\venable\2\26context_commentstring\1\0\1\venable\2\frainbow\1\0\3\venable\2\18extended_mode\2\19max_file_lines\3è\a\fautotag\1\0\1\venable\2\vindent\1\0\1\venable\2\21ensure_installed\1\0\1\17sync_install\2\1\27\0\0\tbash\blua\tjava\trust\vpython\ago\ngomod\6c\rmarkdown\tjson\tyaml\ttoml\bnix\bhcl\thtml\bpug\bcss\tscss\15javascript\btsx\15typescript\15dockerfile\14gitignore\nproto\nregex\fcomment\nsetup\30Failed to load treesitter\nerror\28nvim-treesitter.configs\frequire\npcall\0" },
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/popup.nvim",
    url = "https://github.com/nvim-lua/popup.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n;\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\14telescope\frequire\0" },
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["toggleterm.nvim"] = {
    config = { "\27LJ\2\n}\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\5\16auto_scroll\2\18close_on_exit\2\14autochdir\2\14direction\nfloat\tsize\3\20\nsetup\15toggleterm\frequire\0" },
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/toggleterm.nvim",
    url = "https://github.com/akinsho/toggleterm.nvim"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\2\n\v\0\0\1\0\0\0\1K\0\1\0\0" },
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\n;\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\14which-key\frequire\0" },
    loaded = true,
    path = "/home/konstantin/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Setup for: neo-tree.nvim
time([[Setup for neo-tree.nvim]], true)
try_loadstring("\27LJ\2\nA\0\0\2\0\3\0\0056\0\0\0009\0\1\0+\1\2\0=\1\2\0K\0\1\0$neo_tree_remove_legacy_commands\6g\bvim\0", "setup", "neo-tree.nvim")
time([[Setup for neo-tree.nvim]], false)
time([[packadd for neo-tree.nvim]], true)
vim.cmd [[packadd neo-tree.nvim]]
time([[packadd for neo-tree.nvim]], false)
-- Config for: neovim-session-manager
time([[Config for neovim-session-manager]], true)
try_loadstring("\27LJ\2\n\v\0\0\1\0\0\0\1K\0\1\0\0", "config", "neovim-session-manager")
time([[Config for neovim-session-manager]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: noice.nvim
time([[Config for noice.nvim]], true)
try_loadstring("\27LJ\2\nf\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\blsp\1\0\0\rprogress\1\0\0\1\0\1\fenabled\1\nsetup\nnoice\frequire\0", "config", "noice.nvim")
time([[Config for noice.nvim]], false)
-- Config for: heirline.nvim
time([[Config for heirline.nvim]], true)
try_loadstring("\27LJ\2\nµ\5\0\0\16\0\25\0W6\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0026\2\0\0'\4\3\0B\2\2\0026\3\0\0'\5\4\0B\3\2\0026\4\0\0'\6\5\0B\4\2\0029\4\6\4B\4\1\0026\5\0\0'\a\a\0B\5\2\0029\5\b\5\18\a\4\0B\5\2\0015\5\t\0005\6\n\0005\a\v\0005\b\f\0=\b\r\a4\b\26\0>\6\1\b9\t\14\2B\t\1\2>\t\2\b>\a\3\b9\t\15\2B\t\1\2>\t\4\b>\a\5\b9\t\16\2B\t\1\2>\t\6\b>\a\a\b>\5\b\b>\a\t\b9\t\17\2B\t\1\2>\t\n\b>\a\v\b9\t\18\2B\t\1\2>\t\f\b>\a\r\b9\t\19\2B\t\1\2>\t\14\b>\a\15\b9\t\20\2B\t\1\2>\t\16\b>\a\17\b9\t\21\2B\t\1\2>\t\18\b>\a\19\b9\t\22\2B\t\1\2>\t\20\b>\a\21\b9\t\23\2B\t\1\2>\t\22\b>\a\23\b9\t\24\2B\t\1\2>\t\24\b>\6\25\b4\t\0\0004\n\0\0006\v\0\0'\r\a\0B\v\2\0029\v\6\v\18\r\b\0\18\14\t\0\18\15\n\0B\v\4\1K\0\1\0\nruler\16file_system\18file_encoding\fcopilot\15treesitter\14formatter\vlinter\20language_server\16diagnostics\bgit\fvi_mode\ahl\1\0\2\afg\14gray_dark\abg\fbg_dark\1\0\1\rprovider\b | \1\0\1\rprovider\6 \1\0\1\rprovider\a%=\16load_colors\rheirline\nsetup\22monokaipro.colors$klabun.plugins.heirline.tabline'klabun.plugins.heirline.statusline\19heirline.utils\24heirline.conditions\frequire\0", "config", "heirline.nvim")
time([[Config for heirline.nvim]], false)
-- Config for: toggleterm.nvim
time([[Config for toggleterm.nvim]], true)
try_loadstring("\27LJ\2\n}\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\5\16auto_scroll\2\18close_on_exit\2\14autochdir\2\14direction\nfloat\tsize\3\20\nsetup\15toggleterm\frequire\0", "config", "toggleterm.nvim")
time([[Config for toggleterm.nvim]], false)
-- Config for: indent-blankline.nvim
time([[Config for indent-blankline.nvim]], true)
try_loadstring("\27LJ\2\nw\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\25show_current_context\2\31show_current_context_start\2\nsetup\21indent_blankline\frequire\0", "config", "indent-blankline.nvim")
time([[Config for indent-blankline.nvim]], false)
-- Config for: null-ls.nvim
time([[Config for null-ls.nvim]], true)
try_loadstring("\27LJ\2\næ\a\0\0\t\0-\0\0016\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\1\0B\1\2\0029\1\2\0015\3+\0004\4\30\0009\5\3\0009\5\4\0059\5\5\5>\5\1\0049\5\3\0009\5\4\0059\5\6\5>\5\2\0049\5\3\0009\5\4\0059\5\a\5>\5\3\0049\5\3\0009\5\4\0059\5\b\5>\5\4\0049\5\3\0009\5\4\0059\5\t\0059\5\n\0055\a\f\0005\b\v\0=\b\r\aB\5\2\2>\5\5\0049\5\3\0009\5\4\0059\5\14\5>\5\6\0049\5\3\0009\5\4\0059\5\15\5>\5\a\0049\5\3\0009\5\4\0059\5\16\5>\5\b\0049\5\3\0009\5\4\0059\5\17\5>\5\t\0049\5\3\0009\5\4\0059\5\18\5>\5\n\0049\5\3\0009\5\4\0059\5\19\5>\5\v\0049\5\3\0009\5\4\0059\5\20\5>\5\f\0049\5\3\0009\5\4\0059\5\21\5>\5\r\0049\5\3\0009\5\22\0059\5\23\5>\5\14\0049\5\3\0009\5\22\0059\5\24\5>\5\15\0049\5\3\0009\5\22\0059\5\25\5>\5\16\0049\5\3\0009\5\22\0059\5\26\0059\5\n\0055\a\27\0B\5\2\2>\5\17\0049\5\3\0009\5\22\0059\5\28\5>\5\18\0049\5\3\0009\5\22\0059\5\29\0059\5\n\0055\a\31\0005\b\30\0=\b\r\aB\5\2\2>\5\19\0049\5\3\0009\5\22\0059\5 \5>\5\20\0049\5\3\0009\5!\0059\5\"\5>\5\21\0049\5\3\0009\5!\0059\5\25\5>\5\22\0049\5\3\0009\5!\0059\5\26\5>\5\23\0049\5\3\0009\5!\0059\5#\5>\5\24\0049\5\3\0009\5!\0059\5$\5>\5\25\0049\5\3\0009\5%\0059\5&\5>\5\26\0049\5\3\0009\5%\0059\5'\5>\5\27\0049\5\3\0009\5(\0059\5)\5>\5\28\0049\5\3\0009\5(\0059\5*\5>\5\29\4=\4,\3B\1\2\1K\0\1\0\fsources\1\0\0\rprintenv\15dictionary\nhover\nspell\fluasnip\15completion\14gitrebase\rgitsigns\veslint\17code_actions\18todo_comments\1\0\0\1\2\0\0\17--global vim\rluacheck\bzsh\1\0\1\23diagnostics_format\16#{m} [#{c}]\15shellcheck\vstatix\16clang_check\btsc\16diagnostics\nblack\vstylua\20trim_whitespace\18trim_newlines\nshfmt\18terraform_fmt\ntaplo\14alejandra\15extra_args\1\0\0\1\2\0\0\19--edition=2021\twith\frustfmt\ngofmt\ajq\17clang_format\rprettier\15formatting\rbuiltins\nsetup\fnull-ls\frequire\0", "config", "null-ls.nvim")
time([[Config for null-ls.nvim]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\2\n\v\0\0\1\0\0\0\1K\0\1\0\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Config for: leap.nvim
time([[Config for leap.nvim]], true)
try_loadstring("\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\25add_default_mappings\tleap\frequire\0", "config", "leap.nvim")
time([[Config for leap.nvim]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\n†\6\0\0\n\0'\0F6\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0026\2\3\0009\2\4\2'\4\5\0B\2\2\0019\2\6\0005\4\v\0005\5\t\0009\6\a\0015\b\b\0B\6\2\2=\6\n\5=\5\f\0045\5\15\0009\6\r\0009\6\14\6B\6\1\2=\6\16\0059\6\r\0009\6\17\6B\6\1\2=\6\18\0059\6\r\0009\6\19\6)\büÿB\6\2\2=\6\20\0059\6\r\0009\6\19\6)\b\4\0B\6\2\2=\6\21\0059\6\r\0009\6\22\6B\6\1\2=\6\23\0059\6\r\0009\6\24\6B\6\1\2=\6\25\0059\6\r\0009\6\26\0065\b\29\0009\t\27\0009\t\28\t=\t\30\bB\6\2\2=\6\31\5=\5\r\0044\5\a\0005\6 \0>\6\1\0055\6!\0>\6\2\0055\6\"\0>\6\3\0055\6#\0>\6\4\0055\6$\0>\6\5\0055\6%\0>\6\6\5=\5&\4B\2\2\1K\0\1\0\fsources\1\0\2\tname\nemoji\rpriority\3d\1\0\2\tname\vbuffer\rpriority\3È\1\1\0\2\tname\tcalc\rpriority\3¬\2\1\0\2\tname\rnvim_lsp\rpriority\3è\a\1\0\2\tname\tpath\rpriority\3â\t\1\0\2\tname\fluasnip\rpriority\3Ü\v\t<CR>\rbehavior\1\0\1\vselect\2\fReplace\20ConfirmBehavior\fconfirm\n<C-e>\nclose\14<C-Space>\rcomplete\n<C-f>\n<C-d>\16scroll_docs\n<C-n>\21select_next_item\n<C-p>\1\0\0\21select_prev_item\fmapping\15formatting\1\0\0\vformat\1\0\0\1\0\3\18ellipsis_char\b...\tmode\vsymbol\rmaxwidth\0032\15cmp_format\nsetup*set completeopt=menu,menuone,noselect\bcmd\bvim\flspkind\bcmp\frequire\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\n“\2\0\0\n\0\v\0\0295\0\0\0006\1\1\0006\3\2\0'\4\3\0B\1\3\0037\2\4\0007\1\5\0004\1\0\0006\2\5\0\15\0\2\0X\3\4€6\2\4\0009\2\a\2B\2\1\2=\2\6\0016\2\b\0\18\4\0\0B\2\2\4X\5\a€6\a\2\0'\t\t\0B\a\2\0028\a\6\a9\a\n\a\18\t\1\0B\a\2\1E\5\3\3R\5÷\127K\0\1\0\nsetup\14lspconfig\vipairs\25default_capabilities\17capabilities\fhas_cmp\bcmp\17cmp_nvim_lsp\frequire\npcall\1\a\0\0\16sumneko_lua\vbashls\trnix\18rust_analyzer\vjsonls\vyamlls\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: lspkind.nvim
time([[Config for lspkind.nvim]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\tinit\flspkind\frequire\0", "config", "lspkind.nvim")
time([[Config for lspkind.nvim]], false)
-- Config for: fidget.nvim
time([[Config for fidget.nvim]], true)
try_loadstring("\27LJ\2\n_\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\vwindow\1\0\0\1\0\2\vzindex\3è\a\nblend\3\0\nsetup\vfidget\frequire\0", "config", "fidget.nvim")
time([[Config for fidget.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\nÔ\4\0\0\6\0\21\0\0316\0\0\0006\2\1\0'\3\2\0B\0\3\3\14\0\0\0X\2\4€6\2\3\0'\4\4\0B\2\2\1K\0\1\0006\2\1\0'\4\2\0B\2\2\0029\2\5\0025\4\a\0005\5\6\0=\5\b\0045\5\t\0=\5\n\0045\5\v\0=\5\f\0045\5\r\0=\5\14\0045\5\15\0=\5\16\0045\5\17\0=\5\18\0045\5\19\0=\5\20\4B\2\2\1K\0\1\0\14highlight\1\0\2\venable\2&additional_vim_regex_highlighting\1\fmatchup\1\0\1\venable\2\26context_commentstring\1\0\1\venable\2\frainbow\1\0\3\venable\2\18extended_mode\2\19max_file_lines\3è\a\fautotag\1\0\1\venable\2\vindent\1\0\1\venable\2\21ensure_installed\1\0\1\17sync_install\2\1\27\0\0\tbash\blua\tjava\trust\vpython\ago\ngomod\6c\rmarkdown\tjson\tyaml\ttoml\bnix\bhcl\thtml\bpug\bcss\tscss\15javascript\btsx\15typescript\15dockerfile\14gitignore\nproto\nregex\fcomment\nsetup\30Failed to load treesitter\nerror\28nvim-treesitter.configs\frequire\npcall\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n;\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\14telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: monokai-pro.nvim
time([[Config for monokai-pro.nvim]], true)
try_loadstring("\27LJ\2\na\0\0\3\0\5\0\t6\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\0\0009\0\3\0+\1\2\0=\1\4\0K\0\1\0\25monokaipro_flat_term\6g\27colorscheme monokaipro\bcmd\bvim\0", "config", "monokai-pro.nvim")
time([[Config for monokai-pro.nvim]], false)
-- Config for: neo-tree.nvim
time([[Config for neo-tree.nvim]], true)
try_loadstring("\27LJ\2\n\v\0\0\1\0\0\0\1K\0\1\0\0", "config", "neo-tree.nvim")
time([[Config for neo-tree.nvim]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\2\n;\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\14which-key\frequire\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)
-- Config for: git-conflict.nvim
time([[Config for git-conflict.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17git-conflict\frequire\0", "config", "git-conflict.nvim")
time([[Config for git-conflict.nvim]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
try_loadstring("\27LJ\2\ni\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\nextra\1\0\0\1\0\3\nbelow\bgco\beol\bgcA\nabove\bgcO\nsetup\fComment\frequire\0", "config", "Comment.nvim")
time([[Config for Comment.nvim]], false)

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
