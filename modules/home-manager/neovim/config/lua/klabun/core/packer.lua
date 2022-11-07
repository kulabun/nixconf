local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = vim.fn.system {
	  'git',
	  'clone',
	  '--depth',
	  '1',
	  'https://github.com/wbthomason/packer.nvim',
	  install_path,
	}
end

vim.cmd [[packadd packer.nvim]]

local ok, packer = pcall(require, 'packer')

if not ok then
  error "Failed to load packer"
	return
end

packer.init {
	display = {
	  open_fn = function()
	    return require('packer.util').float { border = 'single' }
	  end,
	  prompt_border = 'single',
	},
	git = {
	  clone_timeout = 600,
	},
	auto_clean = true,
	compile_on_sync = false,
}

packer.startup(function(use)
  if settings['plugins'] then
    for _, plugin in ipairs(settings.plugins) do
      use(plugin)
    end
    if PACKER_BOOTSTRAP then
      require('packer').sync()
    end
  end
end)

