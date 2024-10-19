return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		{ "yavorski/lualine-macro-recording.nvim" },
		{ "nvim-tree/nvim-web-devicons" },
	},
	-- config = function()
	-- 	require("lualine").setup()
	-- end,
	opts = {
		sections = {
			-- add to section of your choice
			lualine_c = { "macro_recording", "%S" },
		},
	},
}
