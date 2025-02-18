return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	lazy = false,
	config = function()
		local harpoon_ui = require("harpoon.ui")
		local harpoon_mark = require("harpoon.mark")

		-- Key mappings
		vim.keymap.set("n", "<leader>p", function()
			harpoon_mark.add_file()
		end, { desc = "Add file to Harpoon" })

		vim.keymap.set("n", "<C-p>", function()
			harpoon_ui.toggle_quick_menu()
		end, { desc = "Show Harpoon menu" })

		-- Navigate through Harpoon list sequentially
		vim.keymap.set("n", "<C-a>", function()
			harpoon_ui.nav_prev()
		end, { desc = "Previous Harpoon file" })

		vim.keymap.set("n", "<C-t>", function()
			harpoon_ui.nav_next()
		end, { desc = "Next Harpoon file" })

		-- Uncomment these if needed
		-- vim.keymap.set("n", "<C-n>", function()
		--   harpoon_ui.nav_file(1)
		-- end, { desc = "Harpoon to file 1" })

		-- vim.keymap.set("n", "<C-e>", function()
		--   harpoon_ui.nav_file(2)
		-- end, { desc = "Harpoon to file 2" })

		-- vim.keymap.set("n", "<C-i>", function()
		--   harpoon_ui.nav_file(3)
		-- end, { desc = "Harpoon to file 3" })

		-- vim.keymap.set("n", "<C-o>", function()
		--   harpoon_ui.nav_file(4)
		-- end, { desc = "Harpoon to file 4" })
	end,
}
