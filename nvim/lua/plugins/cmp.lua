return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local cmp = require('cmp')
      local icons = require('icons').cmp_kinds
      local winhighlight = 'Normal:NormalFloat,FloatBorder:NormalFloat,CursorLine:Visual,Search:None'
      cmp.setup({
        completion = {
          keyword_length = 3
        },
        window = {
          completion = {
            border = 'solid',
            winhighlight = winhighlight,
          },
          documentation = {
            border = 'solid',
            winhighlight = winhighlight
          }
        },
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(_, vim_item)
            vim_item.kind = icons[vim_item.kind] or icons.Text
            return vim_item
          end
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-u>'] = cmp.mapping.scroll_docs({ delta = 4 }),
          ['<C-d>'] = cmp.mapping.scroll_docs({ delta = -4 }),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<Enter>'] = cmp.mapping.confirm({ select = true })
        }),
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' }
        }),
        performance = {
          max_view_entries = 16
        },
        experimental = {
          ghost_text = true
        }
      })
    end
  }
}
