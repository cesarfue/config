return {
	"rmagatti/auto-session",
	lazy = false,

	---enables autocomplete for opts
	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
		suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		-- Continue session restore even if there are errors
		continue_restore_on_error = true,
		-- Bypass session save when there are errors
		bypass_save_filetypes = { "alpha", "dashboard", "netrw", "terminal" },
		pre_restore_cmds = {
			function()
				-- Close all terminals before restoring session
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					if vim.bo[buf].buftype == "terminal" then
						pcall(vim.api.nvim_buf_delete, buf, { force = true })
					end
				end
				-- Stop LSP clients
				for _, client in pairs(vim.lsp.get_clients()) do
					pcall(vim.lsp.stop_client, client.id)
				end
			end,
		},
		post_restore_cmds = {
			function()
				-- Clean up any terminal buffers that made it through restoration
				vim.defer_fn(function()
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
							pcall(vim.api.nvim_buf_delete, buf, { force = true })
						end
					end
				end, 100)
			end,
		},
		session_lens = {
			load_on_setup = true,
		},
	},
}
