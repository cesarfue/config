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
		vim.opt_local.conceallevel = 2
		-- Make sure automatic formatting is enabled
		vim.opt_local.formatoptions:append("t")

		vim.keymap.set("n", "<leader>z", function()
			local line = vim.fn.getline(".")
			if line:match("^#+%s") then
				-- On a header: go to next line, toggle fold, come back
				vim.cmd("normal! j")
				vim.cmd("normal! za")
				vim.cmd("normal! k")
			else
				vim.cmd("normal! za")
			end
		end, { buffer = true, desc = "Toggle fold" })
	end,
})

-- Markdown fold by headers
function _G.markdown_foldexpr()
	local line = vim.fn.getline(vim.v.lnum)
	-- Header stays visible, not folded
	local hashes = line:match("^(#+)%s")
	if hashes then
		return tostring(#hashes - 1)
	end
	-- Line after a header starts the fold
	local prev = vim.fn.getline(vim.v.lnum - 1)
	local prev_hashes = prev:match("^(#+)%s")
	if prev_hashes then
		return ">" .. #prev_hashes
	end
	return "="
end

vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup("markdown_fold"),
	pattern = "*.md",
	callback = function()
		vim.opt_local.foldmethod = "expr"
		vim.opt_local.foldexpr = "v:lua.markdown_foldexpr()"
		vim.opt_local.foldenable = true
		vim.opt_local.foldlevel = 99
	end,
})
