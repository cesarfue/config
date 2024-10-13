-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
	-- NOTE: Yes, you can install new plugins here!
	"mfussenegger/nvim-dap",
	-- NOTE: And you can specify dependencies as well
	dependencies = {
		-- Creates a beautiful debugger UI
		"rcarriga/nvim-dap-ui",

		-- Required dependency for nvim-dap-ui
		"nvim-neotest/nvim-nio",

		-- Installs the debug adapters for you
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",

		-- Add your own debuggers here
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
			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_installation = true,

			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {},

			-- You'll need to check that you have the required things installed
			-- online, please don't ask me how to install them :)
			ensure_installed = {
				-- Update this to ensure that you have the debuggers for the langs you want
				"delve",
			},
		})

		-- Dap UI setup
		-- For more information, see |:help nvim-dap-ui|
		dapui.setup({
			-- Set icons to characters that are more likely to work in every terminal.
			--    Feel free to remove or use ones that you like more! :)
			--    Don't feel like these are good choices.
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

		-- Install golang specific config
		require("dap-go").setup({
			delve = {
				-- On Windows delve must be run attached or it crashes.
				-- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
				detached = vim.fn.has("win32") == 0,
			},
		})
	end,
}

-- return {
-- 	"mfussenegger/nvim-dap",
-- 	recommended = true,
-- 	desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",
--
-- 	dependencies = {
-- 		"rcarriga/nvim-dap-ui",
-- 		-- virtual text for the debugger
-- 		{
-- 			"theHamsta/nvim-dap-virtual-text",
-- 			opts = {},
-- 		},
-- 	},
--
--   -- stylua: ignore
--   keys = {
--     { "<leader>d", "", desc = "+debug", mode = {"n", "v"} },
--     { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
--     { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
--     { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
--     { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
--     { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
--     { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
--     { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
--     { "<leader>dj", function() require("dap").down() end, desc = "Down" },
--     { "<leader>dk", function() require("dap").up() end, desc = "Up" },
--     { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
--     { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
--     { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
--     { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
--     { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
--     { "<leader>ds", function() require("dap").session() end, desc = "Session" },
--     { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
--     { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
--   },
--
-- 	config = function()
-- 		-- load mason-nvim-dap here, after all adapters have been setup
-- 		-- if LazyVim.has("mason-nvim-dap.nvim") then
-- 		    require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
-- 		-- end
--
-- 		vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
--
-- 		-- for name, sign in pairs(LazyVim.config.icons.dap) do
-- 		--     sign = type(sign) == "table" and sign or { sign }
-- 		--     vim.fn.sign_define(
-- 		--         "Dap" .. name,
-- 		--         { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
-- 		--     )
-- 		-- end
--
-- 		-- setup dap config by VsCode launch.json file
-- 		local vscode = require("dap.ext.vscode")
-- 		-- local json = require("plenary.json")
-- 		-- vscode.json_decode = function(str)
-- 		--     return vim.json.decode(json.json_strip_comments(str))
-- 		-- end
--
-- 		-- Extends dap.configurations with entries read from .vscode/launch.json
-- 		if vim.fn.filereadable(".vscode/launch.json") then
-- 			vscode.load_launchjs()
-- 		end
-- 	end,
-- }
