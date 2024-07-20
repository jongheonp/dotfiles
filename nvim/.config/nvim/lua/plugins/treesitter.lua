return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects"
    },
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'comment',
        'cpp',
        'diff',
        'git_config',
        'git_rebase',
        'gitattributes',
        'gitcommit',
        'gitignore',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'ocaml',
        'ocaml_interface',
        'python',
        'query',
        'verilog',
        'vim',
        'vimdoc',
      },
      auto_install = false, -- Don't auto install every language
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
      },
      indent = {
        enable = true,
        disable = { 'ocaml', 'ocaml_interface' }
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          }
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer'
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer'
          }
        }
      }
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end
  },
}
