return {
	"nvim-telescope/telescope-file-browser.nvim",
	dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	vim.keymap.set("n", "<space><space>", ":Telescope file_browser<CR>"),

	require("telescope").setup({
		extensions = {
			file_browser = {
				depth = 5,
				grouped = false,
				display_stat = false,
			},
		},
	}),
}
