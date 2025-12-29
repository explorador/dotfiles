-- ~/.config/nvim/lua/config/autocmds.lua
-- Custom autocommands

-- Clean up empty [No Name] buffers (fixes Claude Code creating extra buffers)
vim.api.nvim_create_autocmd({ "BufAdd", "BufEnter" }, {
	callback = function()
		vim.schedule(function()
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
					local name = vim.api.nvim_buf_get_name(buf)
					local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
					local is_empty = name == "" and #lines == 1 and lines[1] == ""
					local is_listed = vim.bo[buf].buflisted
					if is_empty and is_listed and buf ~= vim.api.nvim_get_current_buf() then
						vim.api.nvim_buf_delete(buf, { force = true })
					end
				end
			end
		end)
	end,
})

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
