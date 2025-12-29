-- ~/.config/nvim/lua/plugins/ui.lua
-- Custom UI plugins and LazyVim overrides

return {
	-- Snacks customization (ayu colorscheme doesn't have snacks integration)
	{
		"folke/snacks.nvim",
		opts = {
			indent = {
				indent = {
					hl = "LineNr", -- Use subtle LineNr color instead of NonText
				},
			},
		},
	},

	-- Disable mini.icons, use nvim-web-devicons instead
	{ "nvim-mini/mini.icons", enabled = false },

	-- Disable old nvim-cmp bridge (using blink.cmp instead)
	{ "hrsh7th/cmp-nvim-lsp", enabled = false },

	-- nvim-web-devicons for file icons
	{
		"nvim-tree/nvim-web-devicons",
		lazy = false,
		opts = {},
	},

	-- Which-key at bottom (classic style)
	{
		"folke/which-key.nvim",
		opts = {
			preset = "classic",
		},
	},

	-- Claude Code integration
	{
		"coder/claudecode.nvim",
		lazy = false, -- Must load on startup for WebSocket server to register before Claude Code CLI starts
		keys = {
			{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
			{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
			{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
		},
		opts = {
			terminal = {
				provider = "none", -- Use external terminal (tmux) instead of Neovim split
			},
			diff_opts = {
				layout = "vertical",
				open_in_new_tab = true, -- Open diffs in new tab to avoid splitting
				on_new_file_reject = "close_window",
			},
		},
	},

	-- Minimap
	{
		"Isrothy/neominimap.nvim",
		version = "v3.*.*",
		lazy = false,
		keys = {
			{ "<leader>nm", "<cmd>Neominimap Toggle<cr>", desc = "Toggle Minimap" },
			{ "<leader>nf", "<cmd>Neominimap ToggleFocus<cr>", desc = "Toggle Minimap Focus" },
			{ "<leader>nr", "<cmd>Neominimap Refresh<cr>", desc = "Refresh Minimap" },
		},
		init = function()
			vim.g.neominimap = {
				auto_enable = false,
				layout = "float",
				float = {
					minimap_width = 15,
					window_border = "rounded",
				},
				exclude_filetypes = { "help", "neo-tree", "toggleterm", "snacks_dashboard", "lazy", "yazi" },
				treesitter = { enabled = true },
				git = { enabled = true },
				diagnostic = { enabled = true },
				search = { enabled = true },
			}
		end,
	},

	-- Yazi file manager
	{
		"mikavilpas/yazi.nvim",
		event = "VeryLazy",
		keys = {
			{ "<leader>y", "<cmd>Yazi<cr>", desc = "Open Yazi (current file)" },
			{ "<leader>Y", "<cmd>Yazi cwd<cr>", desc = "Open Yazi (cwd)" },
		},
		opts = {
			open_for_directories = false,
			keymaps = {
				show_help = "<f1>",
			},
		},
	},


	-- Neo-tree customization (uses LazyVim neo-tree extra)
	{
		"nvim-neo-tree/neo-tree.nvim",
		opts = {
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_by_name = { "node_modules", ".git" },
				},
			},
		},
	},

	-- Smooth scrolling
	{
		"karb94/neoscroll.nvim",
		opts = {
			easing_function = "quadratic",
		},
	},

	-- Override lualine theme
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				theme = "ayu_mirage",
			},
		},
	},

	-- Disable markdown linting
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				markdown = {},
			},
		},
	},

	-- Markdown rendering (re-enable features LazyVim disables)
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			heading = {
				enabled = true,
				sign = false,
				icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
			},
			checkbox = {
				enabled = true,
			},
			bullet = {
				enabled = true,
			},
			quote = {
				enabled = true,
			},
		},
	},

}
