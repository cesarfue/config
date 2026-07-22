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
		-- Persiste la quickfix list dans la session (auto-session ne le fait pas par défaut).
		-- La fonction renvoie une commande qui reconstruit la liste, écrite dans le fichier
		-- de session et rejouée à la restauration.
		save_extra_cmds = {
			function()
				local qf = vim.fn.getqflist()
				if vim.tbl_isempty(qf) then
					return nil
				end
				local title = vim.fn.getqflist({ title = 1 }).title
				local items = {}
				for _, it in ipairs(qf) do
					local fname = (it.bufnr and it.bufnr > 0) and vim.api.nvim_buf_get_name(it.bufnr) or ""
					if fname ~= "" then
						items[#items + 1] = string.format(
							"{'filename': %s, 'lnum': %d, 'col': %d, 'text': %s}",
							vim.fn.string(fname),
							it.lnum or 1,
							it.col or 1,
							vim.fn.string(it.text or "")
						)
					end
				end
				if #items == 0 then
					return nil
				end
				return {
					string.format(
						"call setqflist([], 'r', {'title': %s, 'items': [%s]})",
						vim.fn.string(title),
						table.concat(items, ", ")
					),
				}
			end,
		},
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
