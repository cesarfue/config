return {
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				-- PHP
				"phpactor",
				"php-cs-fixer",
				"phpstan",
				"typescript-language-server",
				"eslint-lsp",
				"prettier",
				"lua-language-server",
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason.nvim" },
		opts = {
			ensure_installed = {
				"phpactor",
				"ts_ls",
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
				relativePatternSupport = true,
			}
			capabilities.workspace.workspaceFolders = true
			capabilities.workspace.configuration = true

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
			local swift_lsp = vim.api.nvim_create_augroup("swift_lsp", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "swift" },
				callback = function()
					local root_dir = vim.fs.dirname(vim.fs.find({ "Package.swift", ".git" }, { upward = true })[1])
					local client = vim.lsp.start({
						name = "sourcekit-lsp",
						cmd = { "sourcekit-lsp" },
						root_dir = root_dir,
						capabilities = capabilities, -- ensure it uses cmp capabilities
					})
					vim.lsp.buf_attach_client(0, client)
				end,
				group = swift_lsp,
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
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					-- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts) -- Added references keybinding
					-- vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>f", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})
		end,
	},
}
