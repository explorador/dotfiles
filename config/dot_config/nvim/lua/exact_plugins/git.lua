-- ~/.config/nvim/lua/plugins/git.lua

return {
	-- Gitsigns (enable current line blame by default)
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			current_line_blame = true,
		},
	},

	-- Snacks git keybindings
	{
		"folke/snacks.nvim",
		keys = {
			{ "<leader>gp", function() vim.fn.system("gh pr view --web") end, desc = "Open PR in Browser" },
			{ "<leader>gP", function() Snacks.picker.gh_pr({ search = "draft:false" }) end, desc = "GitHub Pull Requests (open)" },
		},
	},

	-- Diffview (side-by-side diffs)
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = { "DiffviewOpen", "DiffviewFileHistory" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git Diff View" },
			{ "<leader>gD", "<cmd>DiffviewOpen origin/HEAD<cr>", desc = "Diff vs Origin" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
			{ "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch History" },
			{ "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Close Diff View" },
		},
		opts = {
			enhanced_diff_hl = true,
			view = {
				default = { layout = "diff2_horizontal" },
				file_history = { layout = "diff2_horizontal" },
			},
		},
	},
}
