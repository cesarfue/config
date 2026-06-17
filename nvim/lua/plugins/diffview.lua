return {
	"sindrets/diffview.nvim",
	cmd = {
		"DiffviewOpen",
		"DiffviewClose",
		"DiffviewToggleFiles",
		"DiffviewFocusFiles",
		"DiffviewFileHistory",
	},
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git: Diff working tree" },
		-- Diff against a chosen ref/range: type e.g. main, HEAD~2, abc..def, main...HEAD
		{ "<leader>gD", ":DiffviewOpen ", desc = "Git: Diff against ref/range…" },
		{ "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Git: Close diffview" },
		-- History: current file (normal) / selected lines (visual) -> who changed what
		{ "<leader>gl", "<cmd>DiffviewFileHistory %<cr>", desc = "Git: File history (current file)" },
		{ "<leader>gl", ":DiffviewFileHistory<cr>", mode = "v", desc = "Git: History of selection" },
		-- History: whole repo
		{ "<leader>gL", "<cmd>DiffviewFileHistory<cr>", desc = "Git: Repo history" },
	},
	opts = {
		enhanced_diff_hl = true,
	},
}
