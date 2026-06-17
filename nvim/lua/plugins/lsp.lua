return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- PHP
        "phpactor",
        "php-cs-fixer",
        "phpstan",

        -- JS / TS / TSX / Nest
        "typescript-language-server",
        "eslint",
        "prettier",
        "tailwindcss-language-server",
        "nxls", -- optional for NestJS/Nx monorepos

        -- Svelte
        "svelte-language-server",

        -- Lua
        "lua-language-server",
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "eslint",
        "lua_ls",
        "tailwindcss",
        "svelte",
      },

      automatic_installation = true,
    },
    dependencies = {
      { "williamboman/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },

  -- Setup LSP servers
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Completion capabilities, with utf-16 to stay consistent with typescript-tools
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      capabilities.offsetEncoding = { "utf-16" }

      -- Lua
      vim.lsp.config.lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        capabilities = capabilities,
        root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      }
      vim.lsp.enable("lua_ls")

      -- ESLint
      vim.lsp.config.eslint = {
        cmd = { "vscode-eslint-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "svelte", "astro" },
        capabilities = capabilities,
        root_markers = { ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json", "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs" },
      }
      vim.lsp.enable("eslint")

      -- TailwindCSS
      vim.lsp.config.tailwindcss = {
        cmd = { "tailwindcss-language-server", "--stdio" },
        filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
        capabilities = capabilities,
        root_markers = { "tailwind.config.js", "tailwind.config.ts", "tailwind.config.cjs", "package.json", ".git" },
      }
      vim.lsp.enable("tailwindcss")

      -- Svelte
      vim.lsp.config.svelte = {
        cmd = { "svelteserver", "--stdio" },
        filetypes = { "svelte" },
        capabilities = capabilities,
        root_markers = { "svelte.config.js", "package.json", ".git" },
      }
      vim.lsp.enable("svelte")

      -- Nx / NestJS (optional)
      vim.lsp.config.nxls = {
        cmd = { "nxls", "--stdio" },
        filetypes = { "json" },
        capabilities = capabilities,
        root_markers = { "nx.json", ".git" },
      }
      vim.lsp.enable("nxls")

      -- Swift (sourcekit-lsp, started on demand)
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

      -- LSP keymaps + utf-16 position encoding
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
