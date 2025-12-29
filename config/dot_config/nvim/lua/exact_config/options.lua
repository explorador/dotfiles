-- ~/.config/nvim/lua/config/options.lua
-- Custom options (LazyVim sets most defaults already)

local opt = vim.opt

-- Line wrapping (LazyVim disables by default)
opt.wrap = true
opt.linebreak = true

-- Concealment (keep visible for markdown)
opt.conceallevel = 0

-- Filetype detection for chezmoi templates
vim.filetype.add({
	pattern = {
		[".*%.zsh%.tmpl"] = "zsh",
		["dot_zshrc%.tmpl"] = "zsh",
	},
})
