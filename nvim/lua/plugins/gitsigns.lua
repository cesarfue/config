return {
	"lewis6991/gitsigns.nvim",
	event = "VeryLazy",
	-- Global keymaps (discoverable via <leader>sk / which-key, even outside a git buffer)
	keys = {
		{ "<leader>ghs", ":Gitsigns stage_hunk<CR>", mode = { "n", "v" }, desc = "Git: Stage Hunk" },
		{ "<leader>ghr", ":Gitsigns reset_hunk<CR>", mode = { "n", "v" }, desc = "Git: Reset Hunk" },
		{ "<leader>ghS", "<cmd>Gitsigns stage_buffer<CR>", desc = "Git: Stage Buffer" },
		{ "<leader>ghu", "<cmd>Gitsigns undo_stage_hunk<CR>", desc = "Git: Undo Stage Hunk" },
		{ "<leader>ghR", "<cmd>Gitsigns reset_buffer<CR>", desc = "Git: Reset Buffer" },
		{ "<leader>ghp", "<cmd>Gitsigns preview_hunk_inline<CR>", desc = "Git: Preview Hunk Inline" },
		{ "<leader>ghd", "<cmd>Gitsigns diffthis<CR>", desc = "Git: Diff This" },
		{ "<leader>ghD", function() require("gitsigns").diffthis("~") end, desc = "Git: Diff This ~" },
		{ "<leader>gb", function() require("gitsigns").blame_line({ full = true }) end, desc = "Git: Blame Line" },
		-- Revue de PR : comparer la marge à la base (ex. origin/main) au lieu de HEAD,
		-- pour voir dans le gutter tout ce que la PR a changé. Appliqué à tous les buffers.
		{
			"<leader>ghb",
			function()
				vim.ui.input({ prompt = "Gitsigns base (def. origin/main): " }, function(ref)
					if ref == nil then
						return
					end
					if ref == "" then
						ref = "origin/main"
					end
					require("gitsigns").change_base(ref, true)
				end)
			end,
			desc = "Git: Set diff base (PR review)",
		},
		{ "<leader>ghB", function() require("gitsigns").change_base(nil, true) end, desc = "Git: Reset diff base (HEAD)" },
	},
	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},
		signs_staged = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
		},
		on_attach = function(buffer)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
			end

      -- stylua: ignore start
      -- Hunk navigation + text object (buffer-local: only meaningful inside a git buffer)
      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Next Hunk")
      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Prev Hunk")
      map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
      map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Git: Select Hunk")
		end,
	},
}
