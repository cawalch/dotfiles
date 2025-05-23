-- ~/.config/nvim/lua/core/keymaps.lua
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Normal Mode
-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })

-- Resize windows
map("n", "<M-Up>", ":resize +2<CR>", { desc = "Increase window height" })
map("n", "<M-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<M-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<M-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Buffer navigation
map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Close current buffer" })
map("n", "<leader>bD", ":bufdo bdelete<CR>", { desc = "Close all buffers" })

-- Visual Mode
-- Better indenting
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Terminal Mode
-- Escape terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Escape terminal mode" })

-- Exit Escape
map("i", "jk", "<Esc>", { desc = "Exit insert mode with jk" })
