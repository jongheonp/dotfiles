-- TODO:
-- Automatically cd to root directory of a project when BufEnter
-- Display number of open buffers on statusline
-- Use vim.snippet when it's available on stable
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

-- Default plus blink in insert mode
vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25-blinkon1,r-cr-o:hor20'

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
          WinSeparator = { fg = colors.surface0 }
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
      'hrsh7th/cmp-nvim-lsp'
    },
    config = function()
      local cmp = require('cmp')
      local win_config = cmp.config.window.bordered()
      win_config.border = 'none'
      win_config.winhighlight = 'Normal:NormalFloat'
      cmp.setup({
        window = {
          completion = win_config
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
          { name = 'nvim_lsp', keyword_length = 2 }
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
      winopts = {
        border = 'single'
      },
      lsp = {
        symbols = { symbol_style = 3 } -- kind only
      },
      defaults = {
	file_icons = false
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
      auto_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
      },
      indent = {
        enable = true
      }
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end
  },
  { 'tpope/vim-commentary' },
}, lazy_opts)

-- [[ LSP Related Setup ]] --
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  update_in_insert = true,
  severity_sort = false,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
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

    -- Buffer local mappings.
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { silent = true, desc = "LSP hover", buffer = ev.buf })
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { silent = true, desc = "LSP signature help", buffer = ev.buf })
    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, { silent = true, desc = "LSP rename", buffer = ev.buf })

    -- TODO: Need to remap cause of window mode but I rarely use LSP workspace
    -- APIs nor do I understand them
    -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    -- vim.keymap.set('n', '<space>wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, opts)

    -- TODO: Need to rethink these mappings...
    vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, opts)

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { silent = true, desc = 'LSP declarations', buffer = ev.buf })
    -- vim.keymap.set('n', 'gd', "<Cmd>lua require('fzf-lua').lsp_definitions()<CR>", { silent = true, desc = 'LSP definitions', buffer = ev.buf })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { silent = true, desc = 'LSP definitions', buffer = ev.buf })
    vim.keymap.set('n', '<Leader>fs', "<Cmd>lua require('fzf-lua').lsp_document_symbols()<CR>", { silent = true, desc = 'LSP document symbols', buffer = ev.buf })
    vim.keymap.set('n', 'gl', "<Cmd>lua require('fzf-lua').lsp_finder()<CR>", { silent = true, desc = 'All LSP locations', buffer = ev.buf })
    vim.keymap.set('n', 'gI', "<Cmd>lua require('fzf-lua').lsp_implementations()<CR>", { silent = true, desc = 'LSP implementations', buffer = ev.buf })
    vim.keymap.set('n', '<Leader>fS', "<Cmd>lua require('fzf-lua').lsp_live_workspace_symbols()<CR>", { silent = true, desc = 'LSP workspace symbols', buffer = ev.buf })
    vim.keymap.set('n', 'gr', "<Cmd>lua require('fzf-lua').lsp_references()<CR>", { silent = true, desc = 'LSP references', buffer = ev.buf })

    -- TODO: Need to remap because of fzf-lua mapping
    -- vim.keymap.set('n', '<space>f', function()
    --   vim.lsp.buf.format { async = true }
    -- end, opts)
  end,
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

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
vim.keymap.set('n', '<Leader>w', '<C-W>', { silent = true })
vim.keymap.set('n', '<Esc>', '<Cmd>nohlsearch<CR>')
vim.keymap.set({ 'n', 'v' }, 'j', function()
  return vim.v.count == 0 and 'gj' or 'j'
end, { expr = true })
vim.keymap.set({ 'n', 'v' }, 'k', function()
  return vim.v.count == 0 and 'gk' or 'k'
end, { expr = true })

-- fzf-lua keymaps
vim.keymap.set('n', "<Leader>fb", "<Cmd>lua require('fzf-lua').buffers()<CR>", { silent = true, desc = "Open buffers" })
vim.keymap.set('n', "<Leader>ff", "<Cmd>lua require('fzf-lua').files()<CR>", { silent = true, desc = "Find files on the current directory" })
vim.keymap.set('n', "<Leader>fr", "<Cmd>lua require('fzf-lua').resume()<CR>", { silent = true, desc = "Resume last command/query" })
vim.keymap.set('n', "<Leader>fw", "<Cmd>lua require('fzf-lua').grep_cword()<CR>", { silent = true, desc = "Search word under cursor" })
vim.keymap.set('n', "<Leader>f<S-W>", "<Cmd>lua require('fzf-lua').grep_cWORD()<CR>", { silent = true, desc = "Search WORD under cursor" })
vim.keymap.set('n', "<Leader>fp", "<Cmd>lua require('fzf-lua').live_grep()<CR>", { silent = true, desc = "Live grep current project" })
vim.keymap.set('n', "<Leader>f/", "<Cmd>lua require('fzf-lua').lgrep_curbuf()<CR>", { silent = true, desc = "Live grep current buffer" })
