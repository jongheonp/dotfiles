return {
  {
    'ibhagwan/fzf-lua',
    opts = {
      lsp = {
        prompt = '> ',
        fzf_opts = {
          ['--info'] = 'inline-right',
        },
        symbols = {
          prompt = '> ',
          symbol_style = 2, -- Icons only
          symbol_icons = require('icons').symbol_kinds,
          symbol_fmt = function(s, opts) return s end,
        }
      },
      files = { formatter = 'path.filename_first' },
      defaults = {
        cwd_prompt = false,
        file_icons = false,
        prompt = '> ',
      }
    },
    keys = {
      {
        "<Leader>ff",
        "<Cmd>FzfLua files<CR>",
        desc = "Fild files on the current directory"
      },
      { 
        "<Leader>fg",
        "<Cmd>FzfLua grep_visual<CR>",
        desc = "Search current project lines"
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
      }
    }
  },
}
