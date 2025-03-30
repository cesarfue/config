--
local function augroup(name)
	return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end
--
---- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})
--
---- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		-- Enable soft wrapping for markdown files
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true -- Break at word boundaries
		vim.opt_local.breakindent = true -- Preserve indentation when wrapping
		--
		vim.opt_local.textwidth = 80
		-- Make sure automatic formatting is enabled
		vim.opt_local.formatoptions:append("t")
		-- If you want automatic formatting as you type:
		vim.opt_local.formatoptions:append("a")
	end,
})
