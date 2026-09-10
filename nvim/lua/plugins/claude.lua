return {
	"regie.nvim",
	dir = vim.fn.expand("~/src/regie.nvim"),
	-- Chargé peu après le démarrage : le veilleur du plugin doit tourner sans
	-- qu'on l'ait invoqué, pour ouvrir la régie dès qu'une conversation travaille
	-- sur le répertoire.
	event = "VeryLazy",
	-- Commandes et raccourcis restent déclarés pour l'usage direct.
	cmd = {
		"RegieWatch",
		"RegieUnwatch",
		"RegieFollow",
		"RegieWalk",
		"RegieWalkStop",
		"RegieNotes",
		"RegieNotesClear",
		"RegieFirst",
		"RegieNext",
		"RegiePrev",
		"RegieLatest",
		"RegiePin",
		"RegieUnpin",
		"RegieClose",
	},
	keys = {
		{ "<leader>vw", desc = "Regie : ouvrir la régie et suivre la conversation du terminal" },
		{ "<leader>vr", desc = "Regie : choisir la conversation à suivre" },
		{ "<leader>vp", desc = "Regie : geler / relancer la caméra" },
		{ "<leader>vg", desc = "Regie : dérouler la visite guidée des changements" },
		{ "<leader>vc", desc = "Regie : masquer / afficher les notes de l'agent" },
		{ "<leader>vn", desc = "Regie : changement suivant" },
		{ "<leader>vN", desc = "Regie : changement précédent" },
	},
	dependencies = { "karb94/neoscroll.nvim" },
	opts = {},
}
