return {
	"rmagatti/auto-session",
	lazy = false,

	---enables autocomplete for opts
	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
		suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		-- log_level = 'debug',
		-- Continue session restore even if there are errors
		continue_restore_on_error = true,
		-- Bypass session save when there are errors
		bypass_save_filetypes = { "alpha", "dashboard" },
	},
}
