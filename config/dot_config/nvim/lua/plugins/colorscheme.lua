-- ~/.config/nvim/lua/plugins/colorscheme.lua

return {
	{
		"Shatur/neovim-ayu",
		priority = 1000,
		config = function()
			require("ayu").setup({
				mirage = true, -- Use mirage variant
				terminal = true,
				overrides = {
					-- Better visual selection
					Visual = { bg = "#34455a" },
					-- Slightly brighter comments
					Comment = { fg = "#707a8c", italic = true },
					-- Lighter NonText for snacks picker paths (indent guides use LineNr instead)
					NonText = { fg = "#707a8c" },
					-- Better diff colors
					DiffAdd = { bg = "#2d3b2d" },
					DiffChange = { bg = "#2d3b4d" },
					DiffDelete = { bg = "#3b2d2d" },
				},
			})
			vim.cmd.colorscheme("ayu")
		end,
	},
}
