-- core/keymaps.lua
local map = vim.keymap.set

-- Comments
map("n", "<C-/>", "gcc", { desc = "Toggle comment line", remap = true })
map("v", "<C-/>", "gc", { desc = "Toggle comment selection", remap = true })

-- Quick npm/node commands
map("n", "<leader>nr", function()
  vim.cmd "split | terminal npm run dev"
end, { desc = "npm run dev" })

map("n", "<leader>nt", function()
  vim.cmd "split | terminal npm test"
end, { desc = "npm test" })

-- Reload config
local function reload_config()
  for name, _ in pairs(package.loaded) do
    if name:match "^config" or name:match "^plugins" then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
  vim.notify("Configuration reloaded! 🚀", vim.log.levels.INFO, {
    title = "Neovim Config",
  })
end

map("n", "<leader>rr", reload_config, { desc = "Reload configuration" })

-- Window navigation (CHANGED: Use different key for vertical movement)
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-Up>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Quickfix navigation
map("n", "[q", ":cprev<CR>", { desc = "Previous quickfix" })
map("n", "]q", ":cnext<CR>", { desc = "Next quickfix" })

-- Buffer management
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
-- Use Shift + h/l for buffer navigation
map("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })

-- Quick save/quit
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<leader>qq", ":q<CR>", { desc = "Quit" })

-- Clear search highlighting
map("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlighting" })

-- Better indenting in visual mode
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Move lines up/down
map("n", "<A-j>", ":m .+2<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Escape from insert mode
vim.keymap.set("i", "jk", "<ESC>", { noremap = true, silent = true })
vim.opt.timeoutlen = 300

-- Terminal
map("n", "<leader>tt", function()
  vim.cmd "split | terminal"
end, { desc = "Open terminal" })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

local builtin = require "telescope.builtin"
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

local keymap = vim.keymap -- for conciseness
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    -- set keybinds
    opts.desc = "Show LSP references"
    keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

    opts.desc = "Go to declaration"
    keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

    opts.desc = "Show LSP definitions"
    keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

    opts.desc = "Show LSP implementations"
    keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

    opts.desc = "Show LSP type definitions"
    keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

    opts.desc = "See available code actions"
    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

    opts.desc = "Smart rename"
    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

    opts.desc = "Show buffer diagnostics"
    keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

    opts.desc = "Show line diagnostics"
    keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

    opts.desc = "Go to previous diagnostic"
    keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

    opts.desc = "Go to next diagnostic"
    keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

    opts.desc = "Show documentation for what is under cursor"
    keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

    opts.desc = "Restart LSP"
    keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
  end,
})

vim.keymap.set("i", "<CR>", function()
  vim.fn["augment#Accept"] "\n"
end, { noremap = true, desc = "Call augment#Accept with newline" })

vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd [[cab cc CodeCompanion]]
