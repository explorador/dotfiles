-- ~/.config/nvim/lua/core/options.lua

local opt = vim.opt

-- Disable netrw (we use superfile instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Compatibility fix for older plugins (ft_to_lang was renamed to get_lang)
if vim.treesitter.language.get_lang and not vim.treesitter.language.ft_to_lang then
	vim.treesitter.language.ft_to_lang = vim.treesitter.language.get_lang
end

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"

-- Tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- Line wrapping
opt.wrap = true
opt.linebreak = true  -- Wrap at word boundaries

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard (use system clipboard)
opt.clipboard = "unnamedplus"

-- Swap/backup/undo
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10

-- Update time (for faster diagnostics)
opt.updatetime = 250
opt.timeoutlen = 300

-- Mouse
opt.mouse = "a"

-- Concealment (for markdown, etc.)
opt.conceallevel = 0

-- File encoding
opt.fileencoding = "utf-8"

-- Show matching brackets
opt.showmatch = true

-- Command line
opt.cmdheight = 1
opt.showmode = false  -- We'll use a statusline plugin

-- Fill chars
opt.fillchars = { eob = " " }
