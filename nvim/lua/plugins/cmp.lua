return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lsp',
    'rafamadriz/friendly-snippets',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-calc',
    'hrsh7th/cmp-emoji',
  },
  event = 'InsertEnter',
  config = function()
    local cmp = require('cmp')
    local lspkind = require('lspkind')
    local luasnip = require('luasnip')

    require('luasnip/loaders/from_vscode').lazy_load({
      paths = { '~/.config/nvim/snippets' }
    });

    local cmp_select_opts = { behavior = cmp.SelectBehavior.Select }


    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = {
        ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<Up>'] = cmp.mapping.select_prev_item(cmp_select_opts),
        ['<Down>'] = cmp.mapping.select_next_item(cmp_select_opts),
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select_opts),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select_opts),
        ['<C-y>'] = cmp.mapping.complete(),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'emoji' },
        { name = 'calc' },
        { name = 'path' },
        { name = 'cmp' },
        { name = 'codeium' }
      }),
      formatting = {
        expandable_indicator = '~',
        fields = { 'menu', 'abbr', 'kind' },
        format = lspkind.cmp_format({
          maxwidth = 200,
          ellipsis_char = '...',
          symbol_map = { Codeium = "" },
          before = function(entry, item)
            local menu_icon = {
              nvim_lsp = 'λ',
              luasnip = '✎',
              path = 'Ψ',
              emoji = '🤌',
              nvim_lua = 'Π',
              calc = 'Σ',
              buffer = 'Ω',
              cmdline = '⋗',
            }

            item.menu = menu_icon[entry.source.name] or entry.source.name

            return item
          end
        })
      },
      enabled = function()
        -- disable completion in comments
        local context = require('cmp.config.context')

        -- keep command mode completion enabled when cursor is in a comment
        if vim.api.nvim_get_mode().mode == 'c' then
          return true
        else
          return not context.in_treesitter_capture('comment') and not context.in_syntax_group('Comment')
        end
      end,
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' },
      }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })

    vim.api.nvim_create_autocmd('ModeChanged', {
      pattern = '*',
      callback = function()
        if ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
            and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
            and not require('luasnip').session.jump_active
        then
          require('luasnip').unlink_current()
        end
      end
    })
  end
}
