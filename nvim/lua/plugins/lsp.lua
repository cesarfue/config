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
				"svelte-language-server",
				"tailwindcss-language-server",
				"glsl-analyzer",
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
				"svelte",
				"tailwindcss",
				"glsl_analyzer",
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
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local mason_lspconfig = require("mason-lspconfig")

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			capabilities.offsetEncoding = { "utf-16" }
			capabilities.workspace = capabilities.workspace or {}
			capabilities.workspace.didChangeWatchedFiles = {
				dynamicRegistration = true,
				relativePatternSupport = true,
			}
			capabilities.workspace.workspaceFolders = true
			capabilities.workspace.configuration = true

			-- mason-lspconfig v2: pass handlers directly to setup().
			mason_lspconfig.setup({
			handlers = {
				function(server_name)
					lspconfig[server_name].setup({ capabilities = capabilities })
				end,
				-- TypeScript: exclude svelte (svelte-language-server handles TS internally)
				["ts_ls"] = function()
					lspconfig.ts_ls.setup({
						capabilities = capabilities,
						filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
					})
				end,
				-- Lua: needs diagnostics globals + workspace config
				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
								workspace = {
									library = vim.api.nvim_get_runtime_file("", true),
									checkThirdParty = false,
								},
								telemetry = { enable = false },
							},
						},
					})
				end,
			}})

			local swift_lsp = vim.api.nvim_create_augroup("swift_lsp", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "swift" },
				callback = function()
					local root_dir = vim.fs.dirname(vim.fs.find({ "Package.swift", ".git" }, { upward = true })[1])
					local client = vim.lsp.start({
						name = "sourcekit-lsp",
						cmd = { "sourcekit-lsp" },
						root_dir = root_dir,
						capabilities = capabilities,
					})
					vim.lsp.buf_attach_client(0, client)
				end,
				group = swift_lsp,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf }
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if client and client.server_capabilities then
						client.server_capabilities.positionEncoding = "utf-16"
					end

					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
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
