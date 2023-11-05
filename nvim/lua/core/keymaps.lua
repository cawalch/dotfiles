vim.keymap.set('n', '<C-a>', 'gg<S-v>G', {desc = 'Select all'})

-- New tab
vim.keymap.set('n', 'tn', ':tabnew %<CR>', {desc = 'New tab'})
vim.keymap.set('n', 'tc', ':tabclose<CR>', {desc = 'Close tab'})
-- Split window
vim.keymap.set('n', 'ss', ':split<Return><C-w>w', {desc = 'Split window horizontally'})
vim.keymap.set('n', 'sv', ':vsplit<Return><C-w>w', {desc = 'Split window vertically'})

-- Move window
vim.keymap.set('', '<C-h>', '<C-w>h', {desc = 'Move window (left)'})
vim.keymap.set('', '<C-k>', '<C-w>k', {desc = 'Move window (up)'})
vim.keymap.set('', '<C-j>', '<C-w>j', {desc = 'Move window (down)'})
vim.keymap.set('', '<C-l>', '<C-w>l', {desc = 'Move window (right)'})

-- Resize window
vim.keymap.set('n', '<C-w><left>', '<C-w><', {desc = 'Resize window (left)'})
vim.keymap.set('n', '<C-w><right>', '<C-w>>', {desc = 'Resize window (right)'})
vim.keymap.set('n', '<C-w><up>', '<C-w>+', {desc = 'Resize window (up)'})
vim.keymap.set('n', '<C-w><down>', '<C-w>-', {desc = 'Resize window (down)'})

-- Move lines
vim.keymap.set('v', 'J', ":m '>+1<CR>gvgv", {desc = 'Move line down'})
vim.keymap.set('v', 'K', ":m '<-2<CR>gvgv", {desc = 'Move line up'})

vim.keymap.set('n', 'J', 'mzJ`z') -- join lines without moving the cursor

-- Keep search terms in the middle of the screen
vim.keymap.set('n', 'n', 'nzzzv', {desc = 'Jump to next search term'})
vim.keymap.set('n', 'N', 'Nzzzv', {desc = 'Jump to previous search term'})

-- delete the selection in Visual mode 
-- replace it with the current contents of the unnamed register
-- without affecting the default register
vim.keymap.set('x', '<leader>p', '\"_dP')

vim.keymap.set('n', '<leader>;h', ':set hlsearch!<CR>', {desc = 'Toggle highlighting search'})
