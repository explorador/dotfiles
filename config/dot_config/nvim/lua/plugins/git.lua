-- ~/.config/nvim/lua/plugins/git.lua

return {
	-- Gitsigns (git decorations in gutter)
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "│" },
					change = { text = "│" },
					delete = { text = "󰍵" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "│" },
				},
				current_line_blame = true,
				current_line_blame_opts = {
					delay = 500,
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]h", gs.next_hunk, { desc = "Next Hunk" })
					map("n", "[h", gs.prev_hunk, { desc = "Prev Hunk" })

					-- Actions
					map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage Hunk" })
					map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset Hunk" })
					map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage Buffer" })
					map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
					map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset Buffer" })
					map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview Hunk" })
					map("n", "<leader>hb", function()
						gs.blame_line({ full = true })
					end, { desc = "Blame Line" })
					map("n", "<leader>hd", function()
						vim.cmd("DiffviewOpen -- " .. vim.fn.expand("%"))
					end, { desc = "Diff This (side-by-side)" })
				end,
			})
		end,
	},

	-- Diffview (side-by-side diffs)
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = { "DiffviewOpen", "DiffviewFileHistory" },
		keys = {
			{ "<leader>gs", "<cmd>DiffviewOpen<cr>", desc = "Git Status (all changes)" },
			{ "<leader>gd", "<cmd>DiffviewOpen -- %<cr>", desc = "Diff Current File" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
			{ "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch History" },
			{ "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Close Diff View" },
		},
		config = function()
			require("diffview").setup({
				enhanced_diff_hl = true,
				view = {
					default = { layout = "diff2_horizontal" },
					file_history = { layout = "diff2_horizontal" },
				},
			})
		end,
	},

	-- Toggleterm (terminal management)
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				size = function(term)
					if term.direction == "horizontal" then
						return 15
					elseif term.direction == "vertical" then
						return vim.o.columns * 0.4
					end
				end,
				open_mapping = [[<C-\>]],
				hide_numbers = true,
				shade_filetypes = {},
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				insert_mappings = true,
				terminal_mappings = true,
				persist_size = true,
				direction = "float",
				close_on_exit = true,
				shell = vim.o.shell,
				float_opts = {
					border = "curved",
					winblend = 0,
				},
			})

			-- Terminal keymaps
			function _G.set_terminal_keymaps()
				local opts = { buffer = 0 }
				vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
				vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
				vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
				vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
				vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
			end

			vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

			-- Lazygit
			local Terminal = require("toggleterm.terminal").Terminal
			local lazygit = Terminal:new({
				cmd = "lazygit",
				dir = "git_dir",
				direction = "float",
				float_opts = {
					border = "curved",
				},
				on_open = function(term)
					vim.cmd("startinsert!")
					vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
				end,
				on_close = function()
					vim.cmd("startinsert!")
				end,
			})

			function _G.lazygit_toggle()
				lazygit:toggle()
			end

			vim.keymap.set("n", "<leader>gg", "<cmd>lua lazygit_toggle()<CR>", { desc = "Lazygit" })


			-- Horizontal terminal
			vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Horizontal Terminal" })
			-- Vertical terminal
			vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Vertical Terminal" })
			-- Floating terminal
			vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { desc = "Float Terminal" })
		end,
	},
}
