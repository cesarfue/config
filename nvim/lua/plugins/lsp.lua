return {
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				-- PHP
				"phpactor", -- Using phpactor instead of intelephense
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
				"phpactor", -- Using phpactor instead of intelephense
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
			
			-- Enhanced capabilities with file watching
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			capabilities.offsetEncoding = { "utf-16" }
			
			-- Enable file watching and workspace features
			capabilities.workspace = capabilities.workspace or {}
			capabilities.workspace.didChangeWatchedFiles = {
				dynamicRegistration = true,
				relativePatternSupport = true
			}
			capabilities.workspace.workspaceFolders = true
			capabilities.workspace.configuration = true
			
			-- TypeScript/JavaScript Language Server
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				init_options = {
					hostInfo = "neovim",
					preferences = {
						includePackageJsonAutoImports = "auto",
						providePrefixAndSuffixTextForRename = true,
					}
				},
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = 'all',
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = 'all',
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
				},
			})
			
			-- ESLint
			lspconfig.eslint.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						command = "EslintFixAll",
					})
				end,
			})
			
			-- PHP Actor
			lspconfig.phpactor.setup({
				capabilities = capabilities,
				init_options = {
					["language_server_phpstan.enabled"] = false,
					["language_server_psalm.enabled"] = false,
				}
			})
			
			-- Lua Language Server
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})
			
			-- LSP Attach autocmd
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf }
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if client and client.server_capabilities then
						client.server_capabilities.positionEncoding = "utf-16"
					end
					
					-- Keybindings
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts) -- Added references keybinding
					vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>f", function()
						vim.lsp.buf.format { async = true }
					end, opts)
				end,
			})
		end,
	},
}
