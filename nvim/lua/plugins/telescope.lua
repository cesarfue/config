return {
	{
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			"ThePrimeagen/harpoon",
			event = "VeryLazy",
		},
		keys = {
			{ "<leader><leader>", ":Telescope find_files<CR>", desc = "Find files" },
			{ "<leader>/", ":Telescope live_grep<CR>", desc = "Live grep" },
			{ "<leader>sk", ":Telescope keymaps<CR>", desc = "Show Keymaps" },
			{ "<leader>sS", ":Telescope lsp_document_symbols<CR>", desc = "Document Symbols" },
			{ "<leader>ss", ":Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Workspace Symbols" },
			{ "<leader>sr", ":Telescope lsp_references<CR>", desc = "Show references" },
			{ "<leader>si", ":Telescope lsp_incoming_calls<CR>", desc = "Show incoming calls" },
			{ "<leader>so", ":Telescope lsp_outgoing_calls<CR>", desc = "Show outgoing calls" },
			{ "<leader>st", ":Telescope treesitter<CR>", desc = "Show treesitter" },
			{ "<leader>gs", ":Telescope git_status<CR>", desc = "Git status" },
			{ "<leader>Wl", "<cmd>SessionSearch<CR>", desc = "Session search" },
			{ "<leader>Wd", ":SessionDelete<CR>", desc = "Delete Session" },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = { "/Library", "node_modules", "var", "vendor" }, -- Add folders you want to ignore
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		event = "VeryLazy",
		config = function()
			require("telescope").setup({
				extensions = {
					file_browser = {
						depth = 7,
						grouped = false,
						display_stat = false,
						select_buffer = true,
						git_status = true,
					},
				},
			})
		end,
		keys = {
			{ "<space>,", ":Telescope file_browser<CR>", desc = "File browser" },
		},
	},
}
