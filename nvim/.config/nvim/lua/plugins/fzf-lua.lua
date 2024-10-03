return {
  {
    'ibhagwan/fzf-lua',
    opts = function()
      local actions = require('fzf-lua.actions')
      return {
        winopts = {
          backdrop = 100,
        },
        lsp = {
          formatter = 'path.filename_first',
	  multiline = 1,
          symbols = {
            symbol_style = 2, -- Icons only
            symbol_icons = require('icons').symbol_kinds,
            symbol_fmt = function(s) return s end,
          }
        },
	diagnostics = {
          formatter = 'path.filename_first'
	},
        files = {
          formatter = 'path.filename_first',
          actions = { ['ctrl-h'] = { actions.toggle_hidden } }
        },
        grep = {
          winopts = { preview = { layout = 'vertical' } },
          rg_opts = '--column --line-number --no-heading --color=always --colors=path:none --colors=line:none --colors=column:none --colors=match:fg:green --smart-case --max-columns=4096 -e',
          actions = { ['ctrl-h'] = { actions.toggle_hidden } }
        },
	buffers = {
          formatter = 'path.filename_first',
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
	"<Leader>fb",
	"<Cmd>FzfLua buffers<CR>",
	desc = "Search open buffers"
      },
      {
        "<Leader>ff",
        "<Cmd>FzfLua files resume=true<CR>",
        desc = "Find files on the current directory"
      },
      {
        "<Leader>fg",
        "<Cmd>FzfLua live_grep multiline=1<CR>",
        desc = "Search current project lines"
      },
      {
        "<Leader>fg",
        "<Cmd>FzfLua grep_visual multiline=1<CR>",
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
