return {
  {
    'ibhagwan/fzf-lua',
    opts = {
      winopts = {
        backdrop = 100
      },
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
      grep = {
        rg_opts = '--column --line-number --no-heading --color=always --colors=path:none --colors=line:none --colors=column:none --colors=match:fg:green --smart-case --max-columns=4096 --hidden -e',
      },
      defaults = {
        cwd_prompt = false,
        file_icons = false,
        prompt = '> ',
      }
    },
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
