return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>,", ":Telescope find_files<CR>", desc = "Find files" },
			{ "<leader>/", ":Telescope live_grep<CR>", desc = "Live grep" },
			{ "<leader>sk", ":Telescope keymaps<CR>", desc = "Show Keymaps" },
			{ "<leader>ss", ":Telescope lsp_document_symbols<CR>", desc = "Document Symbols" },
			{ "<leader>sS", ":Telescope lsp_workspace_symbols<CR>", desc = "Workspace Symbols" },
		},
	},

	{
		"nvim-telescope/telescope-file-browser.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					file_browser = {
						depth = 5,
						grouped = false,
						display_stat = false,
					},
				},
			})
		end,
		keys = {
			{ "<space><space>", ":Telescope file_browser<CR>", desc = "File browser" },
		},
	},
}
