return {
  -- {
  --   "rebelot/kanagawa.nvim",
  --   lazy = false,
  --   priority = 1000,
  -- },
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
  },
  {
    "nvim-lua/plenary.nvim",
    config = function()
      local function set_colorscheme()
        vim.g.everforest_background = "soft"
        vim.cmd("colorscheme everforest")
        vim.fn.system("kitty +kitten themes --reload-in=all Everforest Light Soft")
      end
      set_colorscheme()
      vim.api.nvim_create_autocmd("OptionSet", {
        pattern = "background",
        callback = set_colorscheme,
      })
    end,
  },
}
