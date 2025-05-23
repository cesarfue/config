return {
	"williamboman/mason.nvim",
	event = "VeryLazy",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},

	opts = {
		ensure_installed = {
			"html",
			"cssls",
			"tailwindcss",
			"svelte",
			"lua_ls",
			"graphql",
			"emmet_ls",
			"prismals",
			"pyright",
			"clangd",
			"dockerls",
			"marksman",
			"ts_ls",
			"eslint",
			"prettier", -- prettier formatter
			"stylua", -- lua formatter
			"eslint_d",
			"rust_analyzer",
			"jdtls",
		},
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	},

	-- config = function()
	-- 	-- import mason
	-- 	local mason = require("mason")
	--
	-- 	-- import mason-lspconfig
	-- 	local mason_lspconfig = require("mason-lspconfig")
	--
	-- 	local mason_tool_installer = require("mason-tool-installer")
	--
	-- 	-- enable mason and configure icons
	-- 	mason.setup({})
	--
	-- 	mason_lspconfig.setup({
	-- 		-- list of servers for mason to install
	-- 	})

	-- 		mason_tool_installer.setup({
	-- 			ensure_installed = {
	-- 			},
	-- 		})
	-- 	end,
}
