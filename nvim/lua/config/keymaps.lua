local map = vim.keymap.set

vim.g.tmux_resizer_no_mappings = 1

map("n", "<leader>yy", "<cmd>Yazi<cr>", { silent = true, desc = "Open Yazi" })
map("n", "<leader>oo", "<cmd>Oil<cr>", { silent = true, desc = "Open Oil" })

-- Tmux resize mappings
map("n", "<A-Left>", "<cmd>TmuxResizeLeft<cr>", { silent = true, desc = "Resize Tmux pane left" })
map("n", "<A-h>", "<cmd>TmuxResizeLeft<cr>", { silent = true, desc = "Resize Tmux pane left" })
map("n", "<A-Down>", "<cmd>TmuxResizeDown<cr>", { silent = true, desc = "Resize Tmux pane down" })
map("n", "<A-j>", "<cmd>TmuxResizeDown<cr>", { silent = true, desc = "Resize Tmux pane down" })
map("n", "<A-Up>", "<cmd>TmuxResizeUp<cr>", { silent = true, desc = "Resize Tmux pane up" })
map("n", "<A-k>", "<cmd>TmuxResizeUp<cr>", { silent = true, desc = "Resize Tmux pane up" })
map("n", "<A-Right>", "<cmd>TmuxResizeRight<cr>", { silent = true, desc = "Resize Tmux pane right" })
map("n", "<A-l>", "<cmd>TmuxResizeRight<cr>", { silent = true, desc = "Resize Tmux pane right" })

-- File
vim.api.nvim_set_keymap(
  "n",
  "<leader>df",
  "<cmd>!rm %:p<cr>",
  { noremap = true, silent = true, desc = "Delete current file and buffer" }
)

-- Obsidian
map("n", "<leader>ot", "<cmd>ObsidianToday<cr>", { desc = "Obsidian today" })
map("n", "<leader>oc", "<cmd>ObsidianNew<cr>", { desc = "Obsidian new" })
-- map("n", "<leader>oo", '<cmd>ObsidianNewFromTemplate "Zettelkasten.md"<cr>', { des = "Obsidian new note" })

-- Move Lines
map("n", "<A-[>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "<A-]>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("i", "<A-[>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-]>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-[>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-]>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-Left>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<S-Right>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bD", "<cmd>bd<cr>", { desc = "Delete Buffer and Window" })
map("n", "<leader>bd", "<cmd>bp<bar>sp<bar>bn<bar>bd<cr>", { desc = "Delete buffer" })
-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

--keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- lazy
map("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- windows
map("n", "<leader>w", "<c-w>", { desc = "Windows", remap = true })
map("n", "<leader>_", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Bookmark keymaps for marks.nvim
-- Set bookmarks with <leader>b + number
map('n', '<leader>b1', ':lua require("marks").set_bookmark1()<CR>', { desc = "Set bookmark 1" })
map('n', '<leader>b2', ':lua require("marks").set_bookmark2()<CR>', { desc = "Set bookmark 2" })
map('n', '<leader>b3', ':lua require("marks").set_bookmark3()<CR>', { desc = "Set bookmark 3" })
map('n', '<leader>b4', ':lua require("marks").set_bookmark4()<CR>', { desc = "Set bookmark 4" })
map('n', '<leader>b5', ':lua require("marks").set_bookmark5()<CR>', { desc = "Set bookmark 5" })
map('n', '<leader>b6', ':lua require("marks").set_bookmark6()<CR>', { desc = "Set bookmark 6" })
map('n', '<leader>b7', ':lua require("marks").set_bookmark7()<CR>', { desc = "Set bookmark 7" })
map('n', '<leader>b8', ':lua require("marks").set_bookmark8()<CR>', { desc = "Set bookmark 8" })
map('n', '<leader>b9', ':lua require("marks").set_bookmark9()<CR>', { desc = "Set bookmark 9" })
map('n', '<leader>b0', ':lua require("marks").set_bookmark0()<CR>', { desc = "Set bookmark 0" })

-- Go to bookmarks with <leader> + number
map('n', '<leader>1', ':lua require("marks").next_bookmark1()<CR>', { desc = "Go to bookmark 1" })
map('n', '<leader>2', ':lua require("marks").next_bookmark2()<CR>', { desc = "Go to bookmark 2" })
map('n', '<leader>3', ':lua require("marks").next_bookmark3()<CR>', { desc = "Go to bookmark 3" })
map('n', '<leader>4', ':lua require("marks").next_bookmark4()<CR>', { desc = "Go to bookmark 4" })
map('n', '<leader>5', ':lua require("marks").next_bookmark5()<CR>', { desc = "Go to bookmark 5" })
map('n', '<leader>6', ':lua require("marks").next_bookmark6()<CR>', { desc = "Go to bookmark 6" })
map('n', '<leader>7', ':lua require("marks").next_bookmark7()<CR>', { desc = "Go to bookmark 7" })
map('n', '<leader>8', ':lua require("marks").next_bookmark8()<CR>', { desc = "Go to bookmark 8" })
map('n', '<leader>9', ':lua require("marks").next_bookmark9()<CR>', { desc = "Go to bookmark 9" })
map('n', '<leader>0', ':lua require("marks").next_bookmark0()<CR>', { desc = "Go to bookmark 0" })
map('n', '<C-n>', ':lua require("marks").next_bookmark()<CR>', { desc = "Next bookmark" })
map('n', '<C-p>', ':lua require("marks").prev_bookmark()<CR>', { desc = "Previous bookmark" })
map('n', '<leader>bd', ':lua require("marks").delete_bookmark()<CR>', { desc = "Delete bookmark" })
map('n', '<leader>ba', ':lua require("marks").delete_buf()<CR>', { desc = "Delete all bookmarks in buffer" })
map('n', '<leader>bl', ':lua require("marks").bookmark_toggle()<CR>', { desc = "List bookmarks" })
