return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		use_default_keymaps = false,
		keymaps = {
			["g?"] = { "actions.show_help", mode = "n" },
			["<CR>"] = { "actions.select", mode = "n" },
			["<leader>o|>"] = { "actions.select", opts = { vertical = true } },
			["<leader>o->"] = { "actions.select", opts = { horizontal = true } },
			-- ["<leader>os"] = { "actions.select", opts = { tab = true } },
			["<leader>op"] = "actions.preview",
			["<leader>oc"] = { "actions.close", mode = "n" },
			["<leader>or"] = "actions.refresh",
			["-"] = { "actions.parent", mode = "n" },
			["_"] = { "actions.open_cwd", mode = "n" },
			["`"] = { "actions.cd", mode = "n" },
			["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
			["gs"] = { "actions.change_sort", mode = "n" },
			["gx"] = "actions.open_external",
			["<leader>oth"] = { "actions.toggle_hidden", mode = "n" },
			["<leader>ott"] = { "actions.toggle_trash", mode = "n" },
		},
	},
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
}
