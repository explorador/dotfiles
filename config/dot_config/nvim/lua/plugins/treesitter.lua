-- ~/.config/nvim/lua/plugins/treesitter.lua

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			-- Install parsers
			local ensure_installed = {
				"javascript",
				"typescript",
				"tsx",
				"html",
				"css",
				"scss",
				"json",
				"jsonc",
				"lua",
				"markdown",
				"markdown_inline",
				"yaml",
				"bash",
				"vim",
				"vimdoc",
				"gitignore",
				"regex",
			}

			-- Auto-install missing parsers
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local ft = vim.bo.filetype
					local lang = vim.treesitter.language.get_lang(ft) or ft
					local ok = pcall(vim.treesitter.language.add, lang)
					if not ok then
						vim.schedule(function()
							vim.cmd("TSInstall " .. lang)
						end)
					end
				end,
			})

			-- Install specified parsers on startup
			vim.schedule(function()
				for _, lang in ipairs(ensure_installed) do
					pcall(vim.treesitter.language.add, lang)
				end
			end)

			-- Enable treesitter highlighting
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					pcall(vim.treesitter.start)
				end,
			})
		end,
	},

	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
	},
}
