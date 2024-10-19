return {
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"sainnhe/everforest",
		lazy = false,
		priority = 1000,
	},
	{
		"nvim-lua/plenary.nvim",
		-- lazy = false,
		-- priority = 1000,
		config = function()
			local function set_colorscheme()
				if vim.o.background == "light" then
					vim.g.everforest_background = "soft"
					-- vim.g.everforest_better_performance = 1
					vim.cmd("colorscheme everforest")
					vim.fn.system("kitty +kitten themes --reload-in=all Everforest Light Soft")
				else
					vim.cmd("colorscheme kanagawa")
					vim.fn.system("kitty +kitten themes --reload-in=all Kanagawa")
				end
			end
			set_colorscheme()
			vim.api.nvim_create_autocmd("OptionSet", {
				pattern = "background",
				callback = set_colorscheme,
			})
		end,
	},
}
