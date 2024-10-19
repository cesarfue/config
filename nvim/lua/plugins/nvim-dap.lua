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
			-- Basic debugging keymaps, feel free to change to your liking!
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
			-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
			{ "<F7>", dapui.toggle, desc = "Debug: See last session result." },
			unpack(keys),

			--     { "<leader>db", dap.toggle_breakpoint() end, desc = "Toggle Breakpoint" },
			--     { "<leader>dc", dap.continue() end, desc = "Continue" },
			--     { "<leader>da", dap.continue({ before = get_args }) end, desc = "Run with Args" },
			--     { "<leader>dC", dap.run_to_cursor() end, desc = "Run to Cursor" },
			--     { "<leader>dg", dap.goto_() end, desc = "Go to Line (No Execute)" },
			--     { "<leader>di", dap.step_into() end, desc = "Step Into" },
			--     { "<leader>dj", dap.down() end, desc = "Down" },
			--     { "<leader>dk", dap.up() end, desc = "Up" },
			--     { "<leader>dl", dap.run_last() end, desc = "Run Last" },
			--     { "<leader>do", dap.step_out() end, desc = "Step Out" },
			--     { "<leader>dO", dap.step_over() end, desc = "Step Over" },
			--     { "<leader>dp", dap.pause() end, desc = "Pause" },
			--     { "<leader>dr", dap.repl.toggle() end, desc = "Toggle REPL" },
			--     { "<leader>ds", dap.session() end, desc = "Session" },
			--     { "<leader>dt", dap.terminate() end, desc = "Terminate" },
			--     { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
		}
	end,
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		require("mason-nvim-dap").setup({
			automatic_installation = true,
			event = "VeryLazy",
			handlers = {},
			ensure_installed = {
				"delve",
			},
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
