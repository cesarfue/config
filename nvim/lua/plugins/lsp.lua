-- ~/.config/nvim/lua/plugins/lsp.lua

return {
	-- Mason: LSP installer
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				-- PHP
				"intelephense", -- or "phpactor"
				"php-cs-fixer",
				"phpstan",

				-- JavaScript/TypeScript
				"typescript-language-server",
				"eslint-lsp",
				"prettier",

				-- General
				"lua-language-server",
			},
		},
	},

	-- Mason LSP Config bridge
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason.nvim" },
		opts = {
			ensure_installed = {
				"intelephense",
				"ts_ls", -- Updated TypeScript language server
				"eslint",
				"lua_ls",
			},
			automatic_installation = true,
		},
	},

	-- LSP Configuration
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason.nvim",
			"mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp", -- LSP completion source
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- PHP LSP Setup
			lspconfig.intelephense = {
				capabilities = capabilities,
				settings = {
					intelephense = {
						files = {
							maxSize = 1000000,
						},
						format = {
							braces = "allman",
						},
					},
				},
			}

			-- TypeScript/JavaScript LSP Setup
			-- lspconfig.ts_ls.setup({
			-- 	capabilities = capabilities,
			-- 	settings = {
			-- 		typescript = {
			-- 			preferences = {
			-- 				disableSuggestions = false,
			-- 			},
			-- 		},
			-- 	},
			-- })

			-- -- ESLint LSP Setup
			lspconfig.eslint.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					-- Enable ESLint auto-fix on save
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						command = "EslintFixAll",
					})
				end,
			})

			-- Lua LSP Setup (for Neovim config)
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
					},
				},
			})

			-- Global LSP keybindings
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf }

					-- Keybindings
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set("n", "<leader>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<leader>f", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})
		end,
	},

	-- Optional: Better LSP UI
	{
		"glepnir/lspsaga.nvim",
		event = "LspAttach",
		config = function()
			require("lspsaga").setup({
				ui = {
					border = "rounded",
				},
				lightbulb = {
					enable = false, -- Disable if you find it distracting
				},
			})
		end,
	},
	-- Optional: Show LSP progress
	{
		"j-hui/fidget.nvim",
		opts = {},
	},
}
