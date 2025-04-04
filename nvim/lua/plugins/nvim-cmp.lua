return {
	"hrsh7th/nvim-cmp",
	event = "VeryLazy",
	dependencies = {
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
		"hrsh7th/cmp-nvim-lsp",
		{
			"L3MON4D3/LuaSnip",
			-- follow latest release.
			version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
			-- install jsregexp (optional!).
			build = "make install_jsregexp",
		},
		"saadparwaiz1/cmp_luasnip", -- for autocompletion
		"rafamadriz/friendly-snippets", -- useful snippets
		"onsails/lspkind.nvim", -- vs-code like pictograms
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")
		-- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
		require("luasnip.loaders.from_vscode").lazy_load()

		cmp.setup({
			completion = {
				completeopt = "menu,menuone,preview,noselect",
			},
			snippet = { -- configure how nvim-cmp interacts with snippet engine
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-Up>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-Down>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				-- ["<C-b>"] = cmp.mapping.scroll_docs(-4),
				-- ["<C-f>"] = cmp.mapping.scroll_docs(4),
				-- ["<C-l>"] = cmp.mapping.complete(), -- show completion suggestions
				["<C-Left>"] = cmp.mapping.abort(), -- close completion window
				["<C-h>"] = cmp.mapping.abort(), -- close completion window
				["<C-Right>"] = cmp.mapping.confirm({ select = true }),
				["<C-l>"] = cmp.mapping.confirm({ select = true }),
			}),
			-- sources for autocompletion
			sources = cmp.config.sources({
				{ name = "nvim_lsp", max_item_count = 20 },
				{ name = "luasnip", max_item_count = 4 }, -- snippets
				{ name = "buffer", max_item_count = 20 }, -- text within current buffer
				{ name = "path", max_item_count = 20 }, -- file system paths
			}),
		})
	end,
}
