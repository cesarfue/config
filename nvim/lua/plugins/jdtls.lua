return {
	"mfussenegger/nvim-jdtls",
	dependencies = { "folke/which-key.nvim" },
	ft = { "java" }, -- Add any additional Java filetypes you use
	opts = function()
		local cmd = { vim.fn.exepath("jdtls") }
		table.insert(cmd, "-Dlog.protocol=false")
		table.insert(cmd, "-Dlog.level=OFF")
		-- Check if mason.nvim is available
		local has_mason = pcall(require, "mason-registry")
		if has_mason then
			local mason_registry = require("mason-registry")
			if mason_registry.is_installed("jdtls") then
				local lombok_jar = mason_registry.get_package("jdtls"):get_install_path() .. "/lombok.jar"
				table.insert(cmd, string.format("--jvm-arg=-javaagent:%s", lombok_jar))
			end
		end

		-- Use lspconfig's root_dir function for Java projects
		local root_dir_fn
		local status_ok, lspconfig = pcall(require, "lspconfig")
		if status_ok then
			root_dir_fn =
				lspconfig.util.root_pattern("build.xml", "pom.xml", "settings.gradle", "settings.gradle.kts", ".git")
		else
			root_dir_fn = function(fname)
				local root_markers = { "build.xml", "pom.xml", "settings.gradle", "settings.gradle.kts", ".git" }
				local dirname = vim.fn.expand("%:p:h")
				for _, marker in ipairs(root_markers) do
					local root = vim.fn.finddir(marker, dirname .. ";")
					if root ~= "" then
						return vim.fn.fnamemodify(root, ":h")
					end
					root = vim.fn.findfile(marker, dirname .. ";")
					if root ~= "" then
						return vim.fn.fnamemodify(root, ":h")
					end
				end
				return nil
			end
		end

		return {
			-- How to find the root dir for a given filename
			root_dir = root_dir_fn,

			-- How to find the project name for a given root dir
			project_name = function(root_dir)
				return root_dir and vim.fs.basename(root_dir)
			end,

			-- Where are the config and workspace dirs for a project?
			jdtls_config_dir = function(project_name)
				return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
			end,
			jdtls_workspace_dir = function(project_name)
				return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
			end,

			-- How to run jdtls
			cmd = cmd,
			full_cmd = function(opts)
				local fname = vim.api.nvim_buf_get_name(0)
				local root_dir = opts.root_dir(fname)
				local project_name = opts.project_name(root_dir)
				local cmd = vim.deepcopy(opts.cmd)
				if project_name then
					vim.list_extend(cmd, {
						"-configuration",
						opts.jdtls_config_dir(project_name),
						"-data",
						opts.jdtls_workspace_dir(project_name),
					})
				end
				return cmd
			end,

			-- These depend on nvim-dap
			dap = { hotcodereplace = "auto", config_overrides = {} },
			dap_main = {}, -- Set to false to disable main class scan for performance
			test = true,
			-- settings = {
			-- 	java = {
			-- 		inlayHints = {
			-- 			parameterNames = {
			-- 				enabled = "none",
			-- 			},
			-- 		},
			-- 	},
			-- },
		}
	end,
	config = function(_, opts)
		-- Helper function to extend or override tables
		local function extend_or_override(default, override)
			if not override then
				return default
			end
			local result = vim.deepcopy(default)
			for k, v in pairs(override) do
				result[k] = v
			end
			return result
		end

		-- Find the extra bundles for DAP
		local bundles = {} ---@type string[]
		local has_mason = pcall(require, "mason-registry")
		local has_dap = pcall(require, "dap")

		if has_mason then
			local mason_registry = require("mason-registry")
			if opts.dap and has_dap and mason_registry.is_installed("java-debug-adapter") then
				local java_dbg_pkg = mason_registry.get_package("java-debug-adapter")
				local java_dbg_path = java_dbg_pkg:get_install_path()
				local jar_patterns = {
					java_dbg_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
				}
				-- java-test also depends on java-debug-adapter
				if opts.test and mason_registry.is_installed("java-test") then
					local java_test_pkg = mason_registry.get_package("java-test")
					local java_test_path = java_test_pkg:get_install_path()
					vim.list_extend(jar_patterns, {
						java_test_path .. "/extension/server/*.jar",
					})
				end
				for _, jar_pattern in ipairs(jar_patterns) do
					for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), "\n")) do
						table.insert(bundles, bundle)
					end
				end
			end
		end

		local function attach_jdtls()
			local fname = vim.api.nvim_buf_get_name(0)

			-- Get capabilities from cmp-nvim-lsp for consistency with your lspconfig
			local capabilities = nil
			local has_cmp = pcall(require, "cmp_nvim_lsp")
			if has_cmp then
				capabilities = require("cmp_nvim_lsp").default_capabilities()
			end

			-- Configuration can be augmented and overridden by opts.jdtls
			local config = extend_or_override({
				cmd = opts.full_cmd(opts),
				root_dir = opts.root_dir(fname),
				init_options = {
					bundles = bundles,
				},
				settings = opts.settings,
				capabilities = capabilities,
			}, opts.jdtls or {})

			-- Existing server will be reused if the root_dir matches
			require("jdtls").start_or_attach(config)
		end

		-- Attach the jdtls for each java buffer
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "java" },
			callback = attach_jdtls,
		})

		-- Setup Java-specific actions after the lsp is fully attached
		-- This runs AFTER your general LspAttach autocmd from lspconfig
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("JavaLSPConfig", {}),
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client and client.name == "jdtls" then
					local wk = require("which-key")

					-- Register additional Java-specific keymaps
					-- These don't conflict with your existing LSP keymaps
					wk.register({
						["<leader>cx"] = { name = "Java Extract" },
						["<leader>cxv"] = { require("jdtls").extract_variable_all, "Extract Variable" },
						["<leader>cxc"] = { require("jdtls").extract_constant, "Extract Constant" },
						["<leader>cj"] = { name = "Java" },
						["<leader>cjs"] = { require("jdtls").super_implementation, "Goto Super" },
						["<leader>cjS"] = { require("jdtls.tests").goto_subjects, "Goto Subjects" },
						["<leader>cjo"] = { require("jdtls").organize_imports, "Organize Imports" },
					}, { buffer = args.buf })

					-- Visual mode keymaps for Java-specific actions
					wk.register({
						["<leader>cx"] = { name = "Java Extract" },
						["<leader>cxm"] = {
							[[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
							"Extract Method",
						},
						["<leader>cxv"] = {
							[[<ESC><CMD>lua require('jdtls').extract_variable_all(true)<CR>]],
							"Extract Variable",
						},
						["<leader>cxc"] = {
							[[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]],
							"Extract Constant",
						},
					}, { mode = "v", buffer = args.buf })

					-- DAP integration for Java
					if has_mason and has_dap then
						local mason_registry = require("mason-registry")
						if opts.dap and mason_registry.is_installed("java-debug-adapter") then
							-- Custom init for Java debugger
							require("jdtls").setup_dap(opts.dap)
							if opts.dap_main then
								require("jdtls.dap").setup_dap_main_class_configs(opts.dap_main)
							end

							-- Java Test require Java debugger to work
							if opts.test and mason_registry.is_installed("java-test") then
								-- Custom keymaps for Java test runner
								wk.register({
									["<leader>tj"] = { name = "Java Test" },
									["<leader>tja"] = {
										function()
											require("jdtls.dap").test_class({
												config_overrides = type(opts.test) ~= "boolean"
														and opts.test.config_overrides
													or nil,
											})
										end,
										"Run All Test",
									},
									["<leader>tjn"] = {
										function()
											require("jdtls.dap").test_nearest_method({
												config_overrides = type(opts.test) ~= "boolean"
														and opts.test.config_overrides
													or nil,
											})
										end,
										"Run Nearest Test",
									},
									["<leader>tjp"] = { require("jdtls.dap").pick_test, "Pick Test to Run" },
								}, { buffer = args.buf })
							end
						end
					end

					-- User can set additional keymaps in opts.on_attach
					if opts.on_attach then
						opts.on_attach(args)
					end
				end
			end,
		})

		-- Avoid race condition by calling attach the first time
		attach_jdtls()
	end,
}
