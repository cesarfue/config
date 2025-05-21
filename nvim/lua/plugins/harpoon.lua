return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
	lazy = false,
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		-- Telescope integration function
		local conf = require("telescope.config").values
		local function toggle_telescope(harpoon_files)
			local file_paths = {}
			for _, item in ipairs(harpoon_files.items) do
				table.insert(file_paths, item.value)
			end
			require("telescope.pickers")
				.new({}, {
					prompt_title = "Harpoon",
					finder = require("telescope.finders").new_table({
						results = file_paths,
					}),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
				})
				:find()
		end

		-- Existing keymaps
		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end, { desc = "Add file to Harpoon" })

		vim.keymap.set("n", "<leader>.", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Show Harpoon menu" })

		-- -- New Telescope keymap
		-- vim.keymap.set("n", "<leader>.", function()
		-- 	toggle_telescope(harpoon:list())
		-- end, { desc = "Open Harpoon with Telescope" })

		-- Navigate through Harpoon list sequentially
		vim.keymap.set("n", "<C-n>", function()
			harpoon:list():prev()
		end, { desc = "Previous Harpoon file" })

		vim.keymap.set("n", "<C-p>", function()
			harpoon:list():next()
		end, { desc = "Next Harpoon file" })

		-- Direct navigation to files by index
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
