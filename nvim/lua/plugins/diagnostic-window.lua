return {
  'cseickel/diagnostic-window.nvim',
  dependencies = {'MunifTanjim/nui.nvim'},
  event = 'VeryLazy',
  init = function()
    vim.keymap.set('n', ';d', ':DiagWindowShow<CR>', {desc = 'Show diagnostic window'})
  end,
}
