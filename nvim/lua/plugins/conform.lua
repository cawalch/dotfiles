return {
  'stevearc/conform.nvim',
  opts = {
    quiet = true,
    formatters_by_ft = {
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      javascript = { 'prettier' },
      javascriptreact = { 'prettier' },
      json = { 'prettier' },
      html = { 'prettier' },
      css = { 'prettier' },
      scss = { 'prettier' },
      markdown = { 'prettier' },
      yaml = { 'prettier' },
      sh = { 'beautysh' },
      zsh = { 'beautysh' },
      python = { 'ruff' }
    },
    format_on_save = function(bufnr)
      -- Disable autoformat for files in a certain path
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname:match('/node_modules/') then
        return
      end

      return { timeout_ms = 500, lsp_fallback = true, async = true }
    end,
    format_after_save = { lsp_fallback = true },
  },
  config = function(_, opts)
    local conform = require('conform')
    local util = require('conform.util')

    conform.setup(opts)

    -- Customize prettier args
    require('conform.formatters.prettier').args = function(ctx)
      local args = { '--stdin-filepath', '$FILENAME' }
      local localPrettierConfig = vim.fs.find('.prettierrc.json', {
        upward = true,
        path = ctx.dirname,
        type = 'file'
      })[1]
      local globalPrettierConfig = vim.fs.find('.prettierrc.json', {
        path = vim.fn.expand('~/.config/nvim'),
        type = 'file'
      })[1]

      -- Project config takes precedence over global config
      if localPrettierConfig then
        vim.list_extend(args, { '--config', localPrettierConfig })
      elseif globalPrettierConfig then
        vim.list_extend(args, { '--config', globalPrettierConfig })
      end

      return args
    end

    local beautysh = require('conform.formatters.beautysh')
    conform.formatters.beautysh = function(bufnr)
      local config = beautysh(bufnr)
      config.args = util.extend_args(config.args,
        { '--index-size', '2', '--force-function-style', 'fnpar' })
      return config
    end
  end,
}
