return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	lazy = false,
	config = function()
		local harpoon = require("harpoon")

		harpoon:setup()

		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end, { desc = "Add file to Harpoon" })

		vim.keymap.set("n", "<leader>.", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Show Harpoon menu" })

		vim.keymap.set("n", "<C-n>", function()
			harpoon:list():next()
		end, { desc = "Next Harpoon file" })

		vim.keymap.set("n", "<C-p>", function()
			harpoon:list():prev()
		end, { desc = "Previous Harpoon file" })

		vim.keymap.set("n", "<leader>p1", function()
			harpoon:list():select(1)
		end, { desc = "Harpoon to file 1" })

		vim.keymap.set("n", "<leader>p2", function()
			harpoon:list():select(2)
		end, { desc = "Harpoon to file 2" })

		vim.keymap.set("n", "<leader>p3", function()
			harpoon:list():select(3)
		end, { desc = "Harpoon to file 3" })

		vim.keymap.set("n", "<leader>p4", function()
			harpoon:list():select(4)
		end, { desc = "Harpoon to file 4" })
	end,
}
