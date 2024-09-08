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
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if vim.snippet.active({ direction = 1}) then
              vim.snippet.jump(1)
            else
              fallback()
            end
          end, {'i', 's'}),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if vim.snippet.active({ direction = -1 }) then
              vim.snippet.jump(-1)
            else
              fallback()
            end
          end, {'i', 's'}),
          ['<C-n>'] = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Select
          }),
          ['<C-p>'] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Select
          }),
          ['<C-u>'] = cmp.mapping.scroll_docs({ delta = 4 }),
          ['<C-d>'] = cmp.mapping.scroll_docs({ delta = -4 }),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
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
