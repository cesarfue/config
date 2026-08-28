return {
	"regie.nvim",
	dir = vim.fn.expand("~/src/regie.nvim"),
	-- Commandes et raccourcis sont déclarés ici pour que lazy les connaisse avant
	-- d'avoir chargé le plugin : sans cela, seuls ceux listés répondent dans un
	-- Neovim qui vient de démarrer.
	cmd = {
		"Regie",
		"RegieWatch",
		"RegieUnwatch",
		"RegieResume",
		"RegieContinue",
		"RegieNext",
		"RegiePrev",
		"RegieLatest",
		"RegiePin",
		"RegieUnpin",
		"RegieClose",
		"RegieRestart",
	},
	keys = {
		{ "<leader>vw", desc = "Regie : suivre la conversation du terminal" },
		{ "<leader>vv", desc = "Regie : ouvrir la régie" },
		{ "<leader>vr", desc = "Regie : reprendre une conversation" },
		{ "<leader>vp", desc = "Regie : geler / relancer la caméra" },
		{ "<leader>vP", desc = "Regie : suspendre / relancer l'agent" },
		{ "<leader>vx", desc = "Regie : interrompre le tour" },
		{ "<leader>vn", desc = "Regie : changement suivant" },
		{ "<leader>vN", desc = "Regie : changement précédent" },
	},
	dependencies = { "karb94/neoscroll.nvim" },
	opts = {},
}
