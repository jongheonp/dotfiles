return {
  {
    'ibhagwan/fzf-lua',
    opts = function()
      local actions = require('fzf-lua.actions')
      return {
        winopts = {
          backdrop = 100,
          preview = { layout = 'vertical' }
        },
        lsp = {
          symbols = {
            symbol_style = 2, -- Icons only
            symbol_icons = require('icons').symbol_kinds,
            symbol_fmt = function(s) return s end,
          }
        },
        files = {
          winopts = { preview = { layout = 'flex' } },
          fd_opts = [[--color=never --type f --follow --exclude .git]],
          formatter = 'path.filename_first',
          actions = { ['ctrl-h'] = { actions.toggle_hidden } }
        },
        grep = {
          rg_opts = '--column --line-number --no-heading --color=always --colors=path:none --colors=line:none --colors=column:none --colors=match:fg:green --smart-case --max-columns=4096 -e',
          actions = { ['ctrl-h'] = { actions.toggle_hidden } }
        },
        defaults = {
          cwd_prompt = false,
          file_icons = false,
          prompt = '> ',
          no_header_i = true
        }
      }
    end,
    cmd = { 'Fzf', 'FzfLua' },
    keys = {
      {
        "<Leader>ff",
        "<Cmd>FzfLua files<CR>",
        desc = "Fild files on the current directory"
      },
      {
        "<Leader>fg",
        "<Cmd>FzfLua live_grep<CR>",
        desc = "Search current project lines"
      },
      {
        "<Leader>fc",
        "<Cmd>FzfLua lgrep_curbuf<CR>",
        desc = "Search current buffer lines"
      },
      {
        "<Leader>fg",
        "<Cmd>FzfLua grep_visual<CR>",
        mode = 'x',
        desc = "Search current project lines"
      },
      {
        "<Leader>fr",
        "<Cmd>FzfLua resume<CR>",
        desc = "Resume search"
      },
      {
        "<Leader>fh",
        "<Cmd>FzfLua helptags<CR>",
        desc = "Search help tags"
      }
    }
  },
}
