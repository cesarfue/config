return {
	"lukas-reineke/indent-blankline.nvim",
	-- event = { "BufReadPre", "BufNewFile" },
	event = "VeryLazy",
	main = "ibl",
	opts = {
		-- indent = {
		-- 	char = "│",
		-- 	tab_char = "│",
		-- },
		scope = { show_start = false, show_end = false },
		exclude = {
			filetypes = {
				"help",
				"alpha",
				"dashboard",
				"neo-tree",
				"Trouble",
				"trouble",
				"lazy",
				"mason",
				"notify",
				"toggleterm",
				"lazyterm",
			},
		},
	},
}
