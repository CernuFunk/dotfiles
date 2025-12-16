-- ╔═══════════════════════════════════════════════════════════╗
-- ║                    Neovim Options                         ║
-- ╚═══════════════════════════════════════════════════════════╝

local opt = vim.opt

-- General
opt.encoding = "utf-8"
opt.fileformat = "unix"
opt.mouse = "a"
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.swapfile = false
opt.backup = false
opt.undofile = true -- Persistent undo
opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes" -- Always show sign column
opt.cursorline = true
opt.termguicolors = true
opt.showmode = false -- Don't show mode (lualine shows it)
opt.cmdheight = 1
opt.scrolloff = 8 -- Minimal lines to keep above/below cursor
opt.sidescrolloff = 8
opt.pumheight = 10 -- Max items in popup menu

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }

-- Backspace behavior
opt.backspace = { "indent", "eol", "start" }

-- Fold
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false -- Don't fold by default
