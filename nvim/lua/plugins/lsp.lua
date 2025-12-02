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
    config = function()
      -- Lua
      vim.lsp.config.lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
      }
      vim.lsp.enable("lua_ls")

      -- ESLint
      vim.lsp.config.eslint = {
        cmd = { "vscode-eslint-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "svelte", "astro" },
        root_markers = { ".eslintrc", ".eslintrc.js", ".eslintrc.json", "eslint.config.js", "package.json", ".git" },
      }
      vim.lsp.enable("eslint")

      -- TailwindCSS
      vim.lsp.config.tailwindcss = {
        cmd = { "tailwindcss-language-server", "--stdio" },
        filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
        root_markers = { "tailwind.config.js", "tailwind.config.ts", "tailwind.config.cjs", "package.json", ".git" },
      }
      vim.lsp.enable("tailwindcss")

      -- Nx / NestJS (optional)
      vim.lsp.config.nxls = {
        cmd = { "nxls", "--stdio" },
        filetypes = { "json" },
        root_markers = { "nx.json", ".git" },
      }
      vim.lsp.enable("nxls")
    end,
  },
}
