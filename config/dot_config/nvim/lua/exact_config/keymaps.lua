-- ~/.config/nvim/lua/config/keymaps.lua
-- Custom keymaps (LazyVim provides most defaults)

local map = vim.keymap.set

-- Better escape
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Keep cursor centered
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up centered" })
map("n", "n", "nzzzv", { desc = "Next search centered" })
map("n", "N", "Nzzzv", { desc = "Prev search centered" })

-- Paste without losing register
map("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Select all
map("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Better join (keep cursor position)
map("n", "J", "mzJ`z", { desc = "Join lines" })
