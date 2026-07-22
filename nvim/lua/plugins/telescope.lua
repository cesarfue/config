-- Config partagée du picker quickfix : liste à gauche / aperçu à droite, fenêtre large,
-- et chemin complet affiché en une seule colonne (pas la colonne nom de fichier tronquée).
-- Utilisée à la fois par `:Telescope quickfix` (<leader>sq) et par <leader>gq ci-dessous.
local quickfix_picker_opts = {
  layout_strategy = "horizontal",
  layout_config = { width = 0.95, height = 0.9, preview_width = 0.4 },
  entry_maker = function(item)
    local filename = item.filename
    if not filename and item.bufnr and item.bufnr > 0 then
      filename = vim.api.nvim_buf_get_name(item.bufnr)
    end
    local display = (item.text ~= nil and item.text ~= "") and item.text or filename
    return {
      value = item,
      ordinal = display,
      display = display,
      filename = filename,
      lnum = item.lnum,
      col = item.col,
    }
  end,
}

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
    require("telescope.builtin").quickfix(quickfix_picker_opts)
  end)
end

return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    branch = "master",
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
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "/Library", "node_modules", "vendor", ".git" },
          -- Libellés explicites (visibles via `?` en mode normal / `<C-/>` en insertion
          -- dans un picker). Reprennent le comportement par défaut de Telescope.
          mappings = {
            i = {
              ["<Tab>"] = { actions.toggle_selection + actions.move_selection_worse, type = "action", opts = { desc = "Cocher/décocher (sélection multiple)" } },
              ["<S-Tab>"] = { actions.toggle_selection + actions.move_selection_better, type = "action", opts = { desc = "Cocher/décocher (vers le haut)" } },
              ["<M-q>"] = { actions.send_selected_to_qflist + actions.open_qflist, type = "action", opts = { desc = "Sélection cochée -> quickfix" } },
              ["<C-q>"] = { actions.send_to_qflist + actions.open_qflist, type = "action", opts = { desc = "Tous les résultats -> quickfix" } },
            },
            n = {
              ["<Tab>"] = { actions.toggle_selection + actions.move_selection_worse, type = "action", opts = { desc = "Cocher/décocher (sélection multiple)" } },
              ["<S-Tab>"] = { actions.toggle_selection + actions.move_selection_better, type = "action", opts = { desc = "Cocher/décocher (vers le haut)" } },
              ["<M-q>"] = { actions.send_selected_to_qflist + actions.open_qflist, type = "action", opts = { desc = "Sélection cochée -> quickfix" } },
              ["<C-q>"] = { actions.send_to_qflist + actions.open_qflist, type = "action", opts = { desc = "Tous les résultats -> quickfix" } },
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
          quickfix = quickfix_picker_opts,
        },
      })
    end,
  },
}
