local opt = vim.opt

opt.shada = "'1000,f1"

vim.env.JAVA_HOME = "/opt/homebrew/opt/openjdk@21"
opt.relativenumber = true
opt.number = true
opt.autoread = true

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.smartindent = true
opt.wrap = false
opt.confirm = true
opt.conceallevel = 2
-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true
-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "light" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspaopt.shada = "'100,<50,s10,h,f1"ce on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

opt.list = false
opt.linebreak = true
opt.shiftround = true
opt.mouse = "a"
opt.pumheight = 20
opt.pumblend = 10
opt.showmode = true
opt.sidescrolloff = 8
opt.wildmode = "longest:full,full"
opt.scrolloff = 10
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.o.undodir = os.getenv("HOME") .. "/.config/nvim/undodir"
vim.o.undofile = true
