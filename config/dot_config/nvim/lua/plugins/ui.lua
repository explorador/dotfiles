-- ~/.config/nvim/lua/plugins/ui.lua

return {
	-- Claude Code integration
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
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

	-- Snacks.nvim (required by claudecode.nvim)
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {},
	},

	-- Minimap
	{
		"Isrothy/neominimap.nvim",
		version = "v3.*.*",
		lazy = false,
		keys = {
			{ "<leader>nm", "<cmd>Neominimap toggle<cr>", desc = "Toggle Minimap" },
			{ "<leader>nf", "<cmd>Neominimap toggleFocus<cr>", desc = "Toggle Minimap Focus" },
			{ "<leader>nr", "<cmd>Neominimap refresh<cr>", desc = "Refresh Minimap" },
		},
		init = function()
			vim.g.neominimap = {
				auto_enable = true,
				layout = "float",
				float = {
					minimap_width = 15,
					window_border = "rounded",
				},
				exclude_filetypes = { "help", "neo-tree", "toggleterm", "alpha", "lazy", "yazi" },
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
			{ "<leader>fy", "<cmd>Yazi toggle<cr>", desc = "Resume last Yazi session" },
		},
		opts = {
			open_for_directories = true,
			keymaps = {
				show_help = "<f1>",
			},
		},
	},

	-- Image support (inline preview)
	{
		"3rd/image.nvim",
		ft = { "png", "jpg", "jpeg", "gif", "webp" },
		event = "BufReadPre *.png,*.jpg,*.jpeg,*.gif,*.webp",
		opts = {
			backend = "kitty",
			processor = "magick_cli",
			integrations = {
				markdown = { enabled = true },
				neorg = { enabled = false },
			},
			max_width = 100,
			max_height = 30,
			max_height_window_percentage = 50,
			max_width_window_percentage = 50,
			hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
		},
	},

	-- Statusline
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "ayu_mirage",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					globalstatus = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff" },
					lualine_c = { { "filename", path = 1 } },
					lualine_x = { "diagnostics", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},

	-- Bufferline (tabs)
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("bufferline").setup({
				options = {
					mode = "buffers",
					diagnostics = "nvim_lsp",
					diagnostics_indicator = function(_, _, diagnostics_dict)
						local s = " "
						for e, n in pairs(diagnostics_dict) do
							local sym = e == "error" and " " or (e == "warning" and " " or " ")
							s = s .. n .. sym
						end
						return s
					end,
					offsets = {
						{
							filetype = "neo-tree",
							text = "File Explorer",
							highlight = "Directory",
							separator = true,
						},
					},
					show_buffer_close_icons = true,
					show_close_icon = false,
					separator_style = "thin",
				},
			})
		end,
	},

	-- File explorer (neo-tree)
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			"3rd/image.nvim",
		},
		lazy = false,
		keys = {
			{ "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle Explorer" },
			{ "<leader>E", "<cmd>Neotree reveal<CR>", desc = "Reveal in Explorer" },
		},
		init = function()
			-- Open Neo-tree on startup
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					if vim.fn.argc() == 0 then
						vim.schedule(function()
							vim.cmd("Neotree show")
						end)
					end
				end,
			})
		end,
		config = function()

			require("neo-tree").setup({
				close_if_last_window = true,
				enable_git_status = true,
				enable_diagnostics = true,
				window = {
					width = 35,
					mappings = {
						["<space>"] = "none",
						["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
					},
				},
				filesystem = {
					filtered_items = {
						visible = true,
						hide_dotfiles = false,
						hide_gitignored = false,
						hide_by_name = { "node_modules", ".git" },
					},
					follow_current_file = { enabled = true },
					use_libuv_file_watcher = true,
				},
			})
		end,
	},

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("ibl").setup({
				indent = { char = "│" },
				scope = { enabled = true },
				exclude = {
					filetypes = { "help", "dashboard", "neo-tree", "lazy" },
				},
			})
		end,
	},

	-- Which key (keybinding hints)
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			local wk = require("which-key")
			wk.setup({
				plugins = { spelling = { enabled = true } },
				win = { border = "rounded" },
			})
			wk.add({
				{ "<leader>f", group = "Find" },
				{ "<leader>g", group = "Git" },
				{ "<leader>c", group = "Code" },
				{ "<leader>d", group = "Diagnostics" },
				{ "<leader>b", group = "Buffer" },
			})
		end,
	},

	-- Colorizer (show colors inline)
	{
		"NvChad/nvim-colorizer.lua",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("colorizer").setup({
				filetypes = { "*" },
				user_default_options = {
					tailwind = true,
					css = true,
					css_fn = true,
					mode = "background",
				},
			})
		end,
	},

	-- Smooth scrolling
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup({
				easing_function = "quadratic",
			})
		end,
	},

	-- Dashboard
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			dashboard.section.header.val = {
				"                                                     ",
				"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
				"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
				"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
				"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
				"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
				"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
				"                                                     ",
			}

			dashboard.section.buttons.val = {
				dashboard.button("f", "󰈞  Find file", ":Telescope find_files<CR>"),
				dashboard.button("n", "  New file", ":ene <BAR> startinsert<CR>"),
				dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
				dashboard.button("p", "  Projects", ":Telescope projects<CR>"),
				dashboard.button("g", "󰊢  Lazygit", ":lua require('toggleterm.terminal').Terminal:new({cmd='lazygit', direction='float'}):toggle()<CR>"),
				dashboard.button("c", "  Config", ":e $MYVIMRC<CR>"),
				dashboard.button("q", "  Quit", ":qa<CR>"),
			}

			alpha.setup(dashboard.config)
		end,
	},

	-- Noice (better UI for messages, cmdline, popupmenu)
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = true,
				},
			})
		end,
	},
}
