-- ~/.config/nvim/lua/config/autocmds.lua
-- Custom autocommands

-- Enable scroll sync for all diff views
vim.api.nvim_create_autocmd("OptionSet", {
	pattern = "diff",
	callback = function()
		if vim.v.option_new == "1" then
			vim.wo.scrollbind = true
			vim.wo.cursorbind = true
		end
	end,
})
