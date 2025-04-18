return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	lazy = false,
	config = function()
		local harpoon_ui = require("harpoon.ui")
		-- local harpoon_mark = require("harpoon.mark")

		-- Key mappings
		vim.keymap.set("n", "<leader>pa", function()
			harpoon_mark.add_file()
		end, { desc = "Add file to Harpoon" })

		vim.keymap.set("n", "<leader>ps", function()
			harpoon_ui.toggle_quick_menu()
		end, { desc = "Show Harpoon menu" })

		-- Navigate through Harpoon list sequentially
		vim.keymap.set("n", "<C-n>", function()
			harpoon_ui.nav_prev()
		end, { desc = "Previous Harpoon file" })

		vim.keymap.set("n", "<C-p>", function()
			harpoon_ui.nav_next()
		end, { desc = "Next Harpoon file" })

		vim.keymap.set("n", "<leader>p1", function()
			harpoon_ui.nav_file(1)
		end, { desc = "Harpoon to file 1" })

		vim.keymap.set("n", "<leader>p2", function()
			harpoon_ui.nav_file(2)
		end, { desc = "Harpoon to file 2" })

		vim.keymap.set("n", "<leader>p3", function()
			harpoon_ui.nav_file(3)
		end, { desc = "Harpoon to file 3" })

		vim.keymap.set("n", "<leader>p4", function()
			harpoon_ui.nav_file(4)
		end, { desc = "Harpoon to file 4" })
	end,
}
