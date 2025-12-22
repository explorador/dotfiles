-- ~/.config/nvim/lua/plugins/ui.lua
-- Custom UI plugins and LazyVim overrides

return {
	-- Disable mini.icons, use nvim-web-devicons instead
	{ "nvim-mini/mini.icons", enabled = false },

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
		config = true,
		keys = {
			{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
			{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
			{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
		},
		opts = {
			terminal = {
				split_side = "right",
				split_width_percentage = 0.40,
			},
			diff_opts = {
				auto_close_on_accept = true,
				vertical_split = true,
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
				auto_enable = true,
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

	-- Image support (inline preview in Kitty)
	{
		"3rd/image.nvim",
		ft = { "markdown", "png", "jpg", "jpeg", "gif", "webp", "svg" },
		opts = {
			backend = "kitty",
			processor = "magick_cli",
			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = false,
					download_remote_images = true,
					only_render_image_at_cursor = false,
					filetypes = { "markdown", "vimwiki" },
				},
			},
			max_height_window_percentage = 80,
			max_width_window_percentage = 80,
			hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.svg" },
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

}
