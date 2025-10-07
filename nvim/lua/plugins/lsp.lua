return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
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
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  }

  -- {
  --   "neovim/nvim-lspconfig",
  --   dependencies = {
  --     "williamboman/mason.nvim",
  --     "williamboman/mason-lspconfig.nvim",
  --     "hrsh7th/cmp-nvim-lsp",
  --   },
  --   config = function()
  --     -- ✅ Safe hybrid fallback (works in all versions)
  --     local ok, lspconfig = pcall(function()
  --       return vim.lsp.config or require("lspconfig")
  --     end)
  --     if not ok or not lspconfig then
  --       vim.notify("Failed to load lspconfig", vim.log.levels.ERROR)
  --       return
  --     end
  --
  --     -- === Capabilities ===
  --     local capabilities = require("cmp_nvim_lsp").default_capabilities()
  --     capabilities.offsetEncoding = { "utf-16" }
  --     capabilities.workspace = {
  --       didChangeWatchedFiles = { dynamicRegistration = true, relativePatternSupport = true },
  --       workspaceFolders = true,
  --       configuration = true,
  --     }
  --
  --     -- === Helper: safe root_dir ===
  --     local function safe_root(patterns)
  --       return function(fname)
  --         local found = vim.fs.find(patterns, { upward = true, path = fname })
  --         if type(found) == "table" then found = found[1] end
  --         return found and vim.fs.dirname(found) or vim.loop.cwd()
  --       end
  --     end
  --
  --     -- === Servers ===
  --     local servers = {
  --       lua_ls = {
  --         settings = {
  --           Lua = {
  --             diagnostics = { globals = { "vim" } },
  --             workspace = {
  --               library = vim.api.nvim_get_runtime_file("", true),
  --               checkThirdParty = false,
  --             },
  --             telemetry = { enable = false },
  --           },
  --         },
  --       },
  --       eslint = {
  --         root_dir = safe_root({
  --           ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json", "package.json", ".git",
  --         }),
  --       },
  --       ts_ls = {
  --         root_dir = safe_root({
  --           "tsconfig.json", "package.json", "jsconfig.json", ".git",
  --         }),
  --       },
  --       phpactor = {},
  --     }
  --
  --     for name, opts in pairs(servers) do
  --       opts.capabilities = capabilities
  --       local server = (vim.lsp.config and vim.lsp.config[name]) or require("lspconfig")[name]
  --       if server then
  --         server.setup(opts)
  --       else
  --         vim.notify("LSP server not found: " .. name, vim.log.levels.WARN)
  --       end
  --     end
  --
  --     -- === Swift (manual LSP) ===
  --     vim.api.nvim_create_autocmd("FileType", {
  --       pattern = "swift",
  --       callback = function()
  --         local root_dir = vim.fs.root(0, { "Package.swift", ".git" }) or vim.loop.cwd()
  --         vim.lsp.start({
  --           name = "sourcekit-lsp",
  --           cmd = { "sourcekit-lsp" },
  --           root_dir = root_dir,
  --           capabilities = capabilities,
  --         })
  --       end,
  --     })
  --
  --     -- === LSP Keymaps ===
  --     vim.api.nvim_create_autocmd("LspAttach", {
  --       group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  --       callback = function(ev)
  --         local opts = { buffer = ev.buf }
  --         vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  --         vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  --         vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  --         vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  --         vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  --         vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
  --         vim.keymap.set("n", "<leader>f", function()
  --           vim.lsp.buf.format({ async = true })
  --         end, opts)
  --       end,
  --     })
  --   end,
  -- },
  --
  -- -- === Auto-session (safe restore) ===
  -- {
  --   "rmagatti/auto-session",
  --   opts = {
  --     pre_restore_cmds = {
  --       function()
  --         pcall(vim.cmd, "LspStop eslint")
  --         pcall(vim.cmd, "LspStop ts_ls")
  --       end,
  --     },
  --     auto_save_enabled = true,
  --     auto_restore_enabled = true,
  --   },
  -- },
}
