return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  opts = {
    settings = {
      tsserver_file_preferences = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      complete_function_calls = true,
    },
    capabilities = {
      offsetEncoding = { "utf-16" },
    },
    on_attach = function(client, bufnr)
      -- Set offset encoding for this client
      if client.server_capabilities then
        client.server_capabilities.positionEncoding = "utf-16"
      end
    end,
  },
}
