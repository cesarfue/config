return {
	{
		"echasnovski/mini.surround",
		opts = {
			mappings = {
				add = "gsa", -- Add surrounding in Normal and Visual modes
				delete = "gsd", -- Delete surrounding
				find = "gsf", -- Find surrounding (to the right)
				find_left = "gsF", -- Find surrounding (to the left)
				highlight = "gsh", -- Highlight surrounding
				replace = "gsr", -- Replace surrounding
				update_n_lines = "gsn", -- Update `n_lines`
			},
		},
	},
	{
		"echasnovski/mini.pairs",
		opts = {
			modes = { insert = true, command = true, terminal = false },
			-- skip autopair when next character is one of these
			skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
			-- skip autopair when the cursor is inside these treesitter nodes
			skip_ts = { "string" },
			-- skip autopair when next character is closing pair
			-- and there are more closing pairs than opening pairs
			skip_unbalanced = true,
			-- better deal with markdown code blocks
			markdown = true,
		},
	},
	{ "echasnovski/mini.ai" },
	-- {
	-- 	"echasnovski/mini.comment",
	-- 	event = "VeryLazy",
	-- 	opts = {
	-- 		options = {
	-- 			custom_commentstring = function()
	-- 				return require("ts_context_commentstring.internal").calculate_commentstring()
	-- 					or vim.bo.commentstring
	-- 			end,
	-- 		},
	-- 	},
	-- },
	-- {
	-- 	"JoosepAlviste/nvim-ts-context-commentstring",
	-- 	lazy = true,
	-- 	opts = {
	-- 		enable_autocmd = false,
	-- 	},
	-- },
}
