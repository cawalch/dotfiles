-- ~/.config/nvim/lua/core/options.lua
local opt = vim.opt
local fn = vim.fn

-- General
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.swapfile = false

-- Persistent undo
opt.undofile = true
opt.undodir = fn.stdpath("data") .. "/undodir"

-- Appearance
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.showmode = false

-- Tabs & Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Performance & Behavior
opt.updatetime = 250
opt.timeoutlen = 500
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.listchars = { tab = "▸ ", trail = "·", nbsp = "␣", eol = "↴" }
opt.fillchars = { eob = " " }

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Command line
opt.wildmenu = true
opt.wildmode = "longest:full,full"

-- File ops
opt.autoread = true

-- Security
opt.modeline = false

-- Display
opt.showcmd = false
