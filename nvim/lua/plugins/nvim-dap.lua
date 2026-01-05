---@diagnostic disable: missing-fields
return {
	"mfussenegger/nvim-dap",
	event = "VeryLazy",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
		"leoluz/nvim-dap-go",
	},
	keys = function(_, keys)
		local dap = require("dap")
		local dapui = require("dapui")
		return {
			-- Basic debugging keymaps
			{ "<leader>dC", dap.continue, desc = "Debug: Start/Continue" },
			{ "<leader>di", dap.step_into, desc = "Debug: Step Into" },
			{ "<leader>do", dap.step_over, desc = "Debug: Step Over" },
			{ "<leader>dO", dap.step_out, desc = "Debug: Step Out" },
			{ "<leader>db", dap.toggle_breakpoint, desc = "Debug: Toggle Breakpoint" },
			{ "<leader>dt", dap.terminate, desc = "Terminate" },
			{ "<leader>da", dap.continue, desc = "Run with Args" },
			{
				"<leader>B",
				function()
					dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Debug: Set Breakpoint",
			},
			{ "<F7>", dapui.toggle, desc = "Debug: See last session result." },
			unpack(keys),
		}
	end,
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		------------------------------------------------------------------------
		--                             PHP DAP                               --
		------------------------------------------------------------------------

		dap.adapters.php = {
			type = "executable",
			command = "node",
			args = { vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js" },
		}

		dap.configurations.php = {
			{
				type = "php",
				request = "launch",
				name = "Listen for Xdebug",
				port = 80,
			},
		}

		------------------------------------------------------------------------
		--                           RUST DAP (tests)                        --
		------------------------------------------------------------------------

		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				-- ℹ️ SET THIS PATH:
				command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
				args = { "--port", "${port}" },
			},
		}

		dap.configurations.rust = {
			{
				name = "Debug Rust Test",
				type = "codelldb",
				request = "launch",

				-- find the test binary emitted by cargo
				program = function()
					vim.fn.jobstart("cargo test --no-run", { stdout_buffered = true })

					local output = vim.fn.system("cargo test --no-run --message-format=json")
					for _, line in ipairs(vim.split(output, "\n")) do
						local ok, msg = pcall(vim.json.decode, line, { luanil = { object = true } })
						if ok and msg and msg.executable then
							return msg.executable
						end
					end
					error("Could not find test executable. Run `cargo test --no-run` and try again.")
				end,

				-- ask which test to run
				args = function()
					local name = vim.fn.input("Test name: ")
					if name == "" then
						return {}
					end
					return { name, "--nocapture" }
				end,

				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
		}

		------------------------------------------------------------------------
		--                             Mason + UI                            --
		------------------------------------------------------------------------

		require("mason-nvim-dap").setup({
			automatic_installation = true,
			event = "VeryLazy",
			handlers = {},
		})

		dapui.setup({
			event = "VeryLazy",
			icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			controls = {
				icons = {
					pause = "⏸",
					play = "▶",
					step_into = "⏎",
					step_over = "⏭",
					step_out = "⏮",
					step_back = "b",
					run_last = "▶▶",
					terminate = "⏹",
					disconnect = "⏏",
				},
			},
		})

		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close
	end,
}
