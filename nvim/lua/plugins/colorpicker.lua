return {
	-- Color Picker Plugin
	{
		"ziontee113/color-picker.nvim",
		keys = {
			-- Normal mode color picker
			{ "<leader>cc", "<cmd>PickColor<cr>", mode = "n", desc = "Pick Color (Normal mode)" },
			-- Insert mode color picker
		},
		config = function()
			require("color-picker").setup({
				-- Icons for the color picker
				["icons"] = { "ﱢ", "" },

				-- Border style
				["border"] = "rounded", -- none | single | double | rounded | solid | shadow

				-- Custom keymap for color slider
				["keymap"] = {
					["N"] = "<Plug>ColorPickerSlider5Decrease",
					["O"] = "<Plug>ColorPickerSlider5Increase",
				},

				-- Highlight groups
				["background_highlight_group"] = "Normal",
				["border_highlight_group"] = "FloatBorder",
				["text_highlight_group"] = "Normal",
			})

			-- Remove border background
			vim.cmd([[hi FloatBorder guibg=NONE]])
		end,
	},
}
