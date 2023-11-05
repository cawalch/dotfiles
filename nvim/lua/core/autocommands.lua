local ag = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

-- Highlight yanked text
local highlight_group = ag('YankHighlight', { clear = true })
au('TextYankPost', {
  callback = function ()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Disable eslint on node_modules
local disable_node_modules_eslint_group = ag('DisableEslintOnNodeModules', {clear = true})
au({'BufNewFile', 'BufRead'}, {
  pattern = '**/node_modules/**',
  callback = function()
    vim.diagnostic.disable(0) -- disables all diagnostics (not just eslint)
  end,
  group = disable_node_modules_eslint_group,
})

-- Disable commenting new lines
vim.cmd('autocmd BufEnter * set formatoptions-=cro')
vim.cmd('autocmd BufEnter * setlocal formatoptions-=cro')

-- TODO / lazygit

local restore_cursor_shape_group = ag('RestoreCursorShapeOnExit', {clear = true})
au('VimLeave', {
  callback = function()
    vim.opt.guicursor = 'n-v-c:block,i-ci-ve:ver100/,a:blinkwait700-blinkoff400-blinkon250-CursorReset/lCursorReset'
  end,
  group = restore_cursor_shape_group,
  pattern = '*',
})
