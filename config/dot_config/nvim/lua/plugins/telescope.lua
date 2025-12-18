-- ~/.config/nvim/lua/plugins/telescope.lua

return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "master",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					path_display = { "truncate" },
					prompt_prefix = "   ",
					selection_caret = "  ",
					sorting_strategy = "ascending",
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.55,
						},
						vertical = {
							mirror = false,
						},
						width = 0.87,
						height = 0.80,
						preview_cutoff = 120,
					},
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<Esc>"] = actions.close,
						},
					},
					file_ignore_patterns = {
						"node_modules",
						".git/",
						"dist/",
						"build/",
						"%.lock",
					},
				},
				pickers = {
					find_files = {
						hidden = true,
					},
					live_grep = {
						additional_args = function()
							return { "--hidden" }
						end,
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})

			telescope.load_extension("fzf")

			-- Keymaps
			local keymap = vim.keymap.set
			local builtin = require("telescope.builtin")

			keymap("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
			keymap("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
			keymap("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
			keymap("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
			keymap("n", "<leader>fr", builtin.oldfiles, { desc = "Recent Files" })
			keymap("n", "<leader>fc", builtin.grep_string, { desc = "Find Word Under Cursor" })
			keymap("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document Symbols" })
			keymap("n", "<leader>fS", builtin.lsp_workspace_symbols, { desc = "Workspace Symbols" })
			keymap("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
			keymap("n", "<leader>fp", "<cmd>Telescope projects<CR>", { desc = "Projects" })

			-- Git (telescope)
			keymap("n", "<leader>gC", builtin.git_commits, { desc = "Git Commits (telescope)" })
			keymap("n", "<leader>gb", builtin.git_branches, { desc = "Git Branches" })
		end,
	},

	-- Project management
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({
				detection_methods = { "pattern", "lsp" },
				patterns = { ".git", "package.json", "tsconfig.json", ".nvim" },
				show_hidden = true,
			})
			require("telescope").load_extension("projects")
		end,
	},
}
