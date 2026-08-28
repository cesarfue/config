return {
	"regie.nvim",
	dir = vim.fn.expand("~/src/regie.nvim"),
	-- Chargé peu après le démarrage : le veilleur du plugin doit tourner sans
	-- qu'on l'ait invoqué, pour ouvrir la régie dès qu'une conversation travaille
	-- sur le répertoire.
	event = "VeryLazy",
	-- Commandes et raccourcis restent déclarés pour l'usage direct.
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
