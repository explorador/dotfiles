-- ~/.config/nvim/init.lua

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)

-- Leader key (must be before lazy)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Treesitter compatibility shim (ft_to_lang renamed to get_lang in 0.11+)
if not vim.treesitter.language.ft_to_lang then
	vim.treesitter.language.ft_to_lang = vim.treesitter.language.get_lang
end

-- Load core settings
require("core.options")
require("core.keymaps")

-- Load plugins
require("lazy").setup("plugins", {
	change_detection = { notify = false },
	checker = { enabled = true, notify = false },
})
