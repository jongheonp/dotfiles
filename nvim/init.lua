-- TODO:
-- Automatically cd to root directory of a project when BufEnter
-- Use vim.snippet on 0.10
-- Explore formatprg, indentexpr

vim.opt.clipboard = 'unnamedplus'
vim.opt.mouse = 'a'
vim.opt.mousescroll = { 'ver:1', 'hor:1' }
vim.opt.termguicolors = true

-- vim.opt.laststatus = 3 -- Global statusline
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.splitright = true
vim.opt.splitbelow = true

-- Softwrap options
vim.opt.breakat = ' \t;,!?'
vim.opt.breakindent = true
vim.opt.breakindentopt = { 'shift:2', 'sbr' }
vim.opt.linebreak = true

-- Default plus blink in insert mode (had to because of WezTerm...)
vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25-blinkon1,r-cr-o:hor20'

vim.opt.wildmode = { 'longest:full', 'full' }
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Insert 2 <S>s instead of <Tab> while editing
vim.opt.expandtab = true -- Insert spaces instead of tabs
vim.opt.shiftwidth = 2 -- Number of whitespace for (auto)indent
vim.opt.softtabstop = -1 -- Use shiftwidth's value

-- Pop up menu even when only one match, explicit insert & select by user
-- Not sure about preview... does it do anything for cmp?
vim.opt.completeopt = { 'menuone', 'preview', 'noinsert', 'noselect' }

vim.opt.inccommand = 'split'

-- Used for CursorHold autocmd
vim.opt.updatetime = 250

-- Set <Space> as leader
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

lazy_opts = {
  ui = {
    backdrop = 100
  }
}

-- Plug-in setup
require('lazy').setup({
  { 
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    lazy = false,
    opts = {
      no_italic = true,
      custom_highlights = function(colors)
        return {
          StatusLine = { bg = colors.base },
          StatusLineNC = { bg = colors.base },
          FloatBorder = { bg = colors.mantle },
          FzfLuaHeaderBind = { fg = colors.surface2 },
          FzfLuaHeaderText = { fg = colors.surface2 },
          FzfLuaBufName = { fg = colors.pink }, -- For FzfLua lines
          FzfLuaBufNr = { fg = colors.text },
          FzfLuaBufLineNr = { fg = colors.text },
          FzfLuaBufFlagCur = { fg = colors.red },
          FzfLuaBufFlagAlt = { fg = colors.green },
          FzfLuaTabTitle = { fg = colors.text },
          FzfLuaTabMarker = { fg = colors.red },
          FzfLuaLiveSym = { fg = colors.green }
        }
      end
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme 'catppuccin'
    end
  },
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
          -- ['<Tab>'] = cmp.mapping.confirm({ select = true }) 
          ['<C-CR>'] = cmp.mapping.confirm({ select = true }) 
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp', keyword_length = 3 }
        }),
        performance = {
          max_view_entries = 16
        },
        experimental = {
          ghost_text = true
        }
      })
    end
  },
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
          fzf_opts = {
            ['--info'] = 'inline-right',
          }
        },
        finder = {
          separator = ' | ',
        }
      },
      defaults = {
        prompt = '> ',
        cwd_prompt = false,
        file_icons = false,
        fzf_opts = {
          ['--info'] = 'inline-right',
        },
      }
    }
  },
  {
    'lewis6991/gitsigns.nvim',
    config = true
  },
  { 'neovim/nvim-lspconfig' },
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
        'ocamllex',
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
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<Leader>is',
          node_incremental = '<Leader>ii',
          scope_incremental = '<Leader>ic',
          node_decremental = '<Leader>id',
        },
      },
      indent = {
        enable = true
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
  { 'tpope/vim-commentary' }, -- TODO: Remove on 0.10
}, lazy_opts)

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  update_in_insert = true,
  severity_sort = false,
  float = {
    border = 'solid'
  }
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Change border
    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or 'solid'
      return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end

    -- Open float when hover
    vim.api.nvim_create_autocmd('CursorHold', {
      buffer = bufnr,
      callback = function()
        local opts = {
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          source = 'always',
          prefix = ' ',
          scope = 'cursor'
        }
        vim.diagnostic.open_float(nil, opts)
      end
    })

    for _, diag in ipairs({ "Error", "Warn", "Info", "Hint" }) do
      vim.fn.sign_define("DiagnosticSign" .. diag, {
        text = "",
        texthl = "DiagnosticSign" .. diag,
        linehl = "",
        numhl = "DiagnosticSign" .. diag,
      })
    end

    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { silent = true, desc = "LSP hover", buffer = ev.buf })
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { silent = true, desc = "LSP signature help", buffer = ev.buf })

    vim.keymap.set({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, { silent = true, desc = "LSP code action", buffer = ev.buf })
    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, { silent = true, desc = "LSP rename", buffer = ev.buf })

    vim.keymap.set('n', '<Leader>dd', "<Cmd>lua require('fzf-lua').lsp_document_diagnostics()<CR>", { silent = true, desc = 'LSP document diagnostics', buffer = ev.buf })
    vim.keymap.set('n', '<Leader>ds', "<Cmd>lua require('fzf-lua').lsp_document_symbols()<CR>", { silent = true, desc = 'LSP document symbols', buffer = ev.buf })
    vim.keymap.set('n', '<Leader>wd', "<Cmd>lua require('fzf-lua').lsp_workspace_diagnostics()<CR>", { silent = true, desc = 'LSP workspace diagnostics', buffer = ev.buf })
    vim.keymap.set('n', '<Leader>ws', "<Cmd>lua require('fzf-lua').lsp_workspace_symbols()<CR>", { silent = true, desc = 'LSP workspace symbols', buffer = ev.buf })

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { silent = true, desc = 'LSP declarations', buffer = ev.buf })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { silent = true, desc = 'LSP definitions', buffer = ev.buf })
    -- vim.keymap.set('n', 'gl', "<Cmd>lua require('fzf-lua').lsp_finder()<CR>", { silent = true, desc = 'All LSP locations', buffer = ev.buf })
    vim.keymap.set('n', 'gI', "<Cmd>lua require('fzf-lua').lsp_implementations()<CR>", { silent = true, desc = 'LSP implementations', buffer = ev.buf })
    vim.keymap.set('n', 'gr', "<Cmd>lua require('fzf-lua').lsp_references()<CR>", { silent = true, desc = 'LSP references', buffer = ev.buf })
    vim.keymap.set('n', 'gy', "<Cmd>lua require('fzf-lua').lsp_typedefs()<CR>", { silent = true, desc = "LSP type definitions", buffer = ev.buf })

    -- TODO: Need to remap because of fzf-lua mapping
    -- vim.keymap.set('n', '<space>f', function()
    --   vim.lsp.buf.format { async = true }
    -- end, opts)
  end,
})

local native_caps = vim.lsp.protocol.make_client_capabilities()
local cmp_caps = require('cmp_nvim_lsp').default_capabilities()
local capabilities = vim.tbl_deep_extend('force', native_caps, cmp_caps)

require('lspconfig').pyright.setup {
  capabilities = capabilities
}

require('lspconfig').clangd.setup({
  capabilities = capabilities
})

require'lspconfig'.ocamllsp.setup{
  capabilities = capabilities
}

-- Map frequently used commands
vim.keymap.set('n', '<Esc>', '<Cmd>nohlsearch<CR>')
vim.keymap.set('n', '<Leader>ss', '<Cmd>mks!<CR>')

-- fzf-lua keymaps
vim.keymap.set('n', "<Leader>ff", "<Cmd>lua require('fzf-lua').files()<CR>", { desc = "Find files on the current directory" })
vim.keymap.set('n', "<Leader>f/", "<Cmd>lua require('fzf-lua').blines()<CR>", { desc = "Search current buffer lines" })
vim.keymap.set('n', "<Leader>fg", "<Cmd>lua require('fzf-lua').live_grep()<CR>", { desc = "Search current project lines" })
vim.keymap.set('x', "<Leader>fg", "<Cmd>lua require('fzf-lua').grep_visual()<CR>", { desc = "Search visual selection" })
vim.keymap.set('n', "<Leader>fh", "<Cmd>lua require('fzf-lua').helptags()<CR>", { desc = "Search help tags" })
vim.keymap.set('n', "<Leader>fr", "<Cmd>lua require('fzf-lua').resume()<CR>", { desc = "Resume last command/query" })
