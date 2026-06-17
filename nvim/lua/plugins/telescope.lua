-- Remplit la quickfix list avec les fichiers modifiés par un commit (ou une range),
-- puis l'ouvre via Telescope. Range = contient ".." (ex: main..HEAD, main...HEAD).
local function git_changed_files_to_qf()
  vim.ui.input({ prompt = "Commit / range (def. HEAD): " }, function(ref)
    if ref == nil then
      return
    end
    if ref == "" then
      ref = "HEAD"
    end

    local root = vim.trim(vim.fn.system({ "git", "rev-parse", "--show-toplevel" }))
    if vim.v.shell_error ~= 0 then
      vim.notify("Pas un dépôt git", vim.log.levels.ERROR)
      return
    end

    local cmd
    if ref:find("%.%.") then
      cmd = { "git", "-C", root, "diff", "--name-only", ref }
    else
      cmd = { "git", "-C", root, "diff-tree", "--no-commit-id", "--name-only", "-r", ref }
    end

    local files = vim.fn.systemlist(cmd)
    if vim.v.shell_error ~= 0 then
      vim.notify("git: " .. table.concat(files, "\n"), vim.log.levels.ERROR)
      return
    end

    local items = {}
    for _, f in ipairs(files) do
      if f ~= "" then
        items[#items + 1] = { filename = root .. "/" .. f, lnum = 1, col = 1, text = f }
      end
    end

    if #items == 0 then
      vim.notify("Aucun fichier modifié dans " .. ref, vim.log.levels.WARN)
      return
    end

    vim.fn.setqflist({}, " ", { title = "Fichiers modifiés: " .. ref, items = items })
    require("telescope.builtin").quickfix()
  end)
end

return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "ThePrimeagen/harpoon",
      event = "VeryLazy",
    },
    keys = {
      { "<leader><leader>", ":Telescope find_files<CR>",                    desc = "Find files" },
      { "<leader>.", function() require("telescope.builtin").find_files({ hidden = true, no_ignore = true, file_ignore_patterns = {} }) end, desc = "Find files (hidden)" },
      { "<leader>/",        ":Telescope live_grep<CR>",                     desc = "Live grep" },
      { "<leader>sk",       ":Telescope keymaps<CR>",                       desc = "Show Keymaps" },
      { "<leader>sS",       ":Telescope lsp_document_symbols<CR>",          desc = "Document Symbols" },
      { "<leader>ss",       ":Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Workspace Symbols" },
      { "<leader>sr",       ":Telescope lsp_references<CR>",                desc = "Show references" },
      { "<leader>si",       ":Telescope lsp_incoming_calls<CR>",            desc = "Show incoming calls" },
      { "<leader>so",       ":Telescope lsp_outgoing_calls<CR>",            desc = "Show outgoing calls" },
      { "<leader>sT",       ":Telescope treesitter<CR>",                    desc = "Show treesitter" },
      { "<leader>gs",       ":Telescope git_status<CR>",                    desc = "Git status" },
      { "<leader>gq",       git_changed_files_to_qf,                        desc = "Git: Changed files of commit/range -> quickfix" },
      { "<leader>Wl",       "<cmd>SessionSearch<CR>",                       desc = "Session search" },
      { "<leader>Wd",       ":SessionDelete<CR>",                           desc = "Delete Session" },
      { "<leader>sb",       ":Telescope marks<CR>",                         desc = "Show bookmarks" },
      { "<leader>sq",       ":Telescope quickfix<CR>",                      desc = "Quickfix list" },

    },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "/Library", "node_modules", "vendor", ".git" },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
      })
    end,
  },
}
