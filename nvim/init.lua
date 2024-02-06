-- NOTE: Keep it simple, stupid!
-- TODO: Change the window bar color
-- TODO: Migrate to nightly, use vim.snippet
-- TODO: nvim-cmp: Make variables have the highest priority
-- TODO: Move plug-in setups to individual files

-- Set <space> as the leader key
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Line number and signcolumn
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = 'yes'

-- Global statusline
vim.o.laststatus = 3

vim.o.splitright = true

-- Softwrap options
vim.o.breakat = ' \t;:,!?'
vim.wo.breakindent = true
vim.opt.breakindentopt = { 'shift:2', 'sbr' } -- Maybe on sbr... don't know if it looks good
vim.o.linebreak = true
vim.o.showbreak = '󱞩' -- 

vim.o.clipboard = 'unnamedplus'
vim.o.mouse = 'a' -- Scroll with wheel without moving the cursor
vim.o.termguicolors = true

vim.o.hlsearch = false

-- Tabs
vim.o.shiftwidth = 2 -- Number of whitespaces for (auto)indent
vim.o.softtabstop = -1
vim.o.expandtab = true -- Tabs to spaces

vim.o.updatetime = 250

-- Pop up menu even when only one match, explicit insert & select by user
-- Not sure about preview... does it do anything for cmp?
vim.opt.completeopt = { 'menuone', 'preview', 'noinsert', 'noselect' }

vim.o.pumblend = 10
-- vim.o.winblend = 10

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

-- Plug-in setup
require('lazy').setup({
  { 
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    lazy = false,
    opts = {
      flavour = 'mocha',
      transparent_background = false,
      show_end_of_buffer = false,
      no_italic = true,
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme 'catppuccin'
    end
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
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
          ['<CR>'] = cmp.mapping.confirm({ select = true })
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp', keyword_length = 2 }
        }, {
          { name = 'buffer', keyword_length = 4 }
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
      defaults = {
	file_icons = false
      }
    }
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        -- delete = { text = '_' }
      },
    },
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
        'c',
        'comment',
        'cpp',
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
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
      }
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end
  }
})

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
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = bufnr,
      callback = function()
        local opts = {
          -- pad_top = 1,
          -- pad_bottom = 1,
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          -- border = 'single', -- 'rounded'
          source = 'always',
          prefix = '',
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
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)

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

    vim.keymap.set('n', 'gD', "<Cmd>lua require('fzf-lua').lsp_declarations()<CR>", { silent = true, desc = 'LSP declarations', buffer = ev.buf })
    vim.keymap.set('n', 'gd', "<Cmd>lua require('fzf-lua').lsp_definitions()<CR>", { silent = true, desc = 'LSP definitions', buffer = ev.buf })
    vim.keymap.set('n', 'gi', "<Cmd>lua require('fzf-lua').lsp_implementations()<CR>", { silent = true, desc = 'LSP implementations', buffer = ev.buf })
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

-- require('lspconfig').lua_ls.setup({
--   capabilities = capabilities,
--   on_attach = on_attach,
--   on_init = function(client)
--     local path = client.workspace_folders[1].name
--     if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
--       client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
--         Lua = {
--           runtime = {
--             -- Tell the language server which version of Lua you're using
--             -- (most likely LuaJIT in the case of Neovim)
--             version = 'LuaJIT'
--           },
--           -- Make the server aware of Neovim runtime files
--           workspace = {
--             checkThirdParty = false,
--             library = {
--               vim.env.VIMRUNTIME
--               -- "${3rd}/luv/library"
--               -- "${3rd}/busted/library",
--             }
--             -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
--             -- library = vim.api.nvim_get_runtime_file("", true)
--           }
--         }
--       })
-- 
--       client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
--     end
--     return true
--   end
-- })

-- Map frequently used commands
vim.keymap.set('n', '<Leader>w', '<C-W>', { silent = true })
-- vim.keymap.set('n', '<C-D>', '<C-D>zz', { silent = true }) -- TODO: Fix flicker at the beginning of file

-- fzf-lua keymaps
vim.keymap.set('n', "<Leader>fb", "<Cmd>lua require('fzf-lua').buffers()<CR>", { silent = true, desc = "Open buffers" })
vim.keymap.set('n', "<Leader>ff", "<Cmd>lua require('fzf-lua').files()<CR>", { silent = true, desc = "find or fd on a path" })
vim.keymap.set('n', "<Leader>fr", "<Cmd>lua require('fzf-lua').resume()<CR>", { silent = true, desc = "Resume last command/query" })
vim.keymap.set('n', "<Leader>fw", "<Cmd>lua require('fzf-lua').grep_cword()<CR>", { silent = true, desc = "Search word under cursor" })
vim.keymap.set('n', "<Leader>f<S-W>", "<Cmd>lua require('fzf-lua').grep_cWORD()<CR>", { silent = true, desc = "Search WORD under cursor" })
vim.keymap.set('n', "<Leader>fl", "<Cmd>lua require('fzf-lua').live_grep()<CR>", { silent = true, desc = "Live grep current project" })
vim.keymap.set('n', "<Leader>fc", "<Cmd>lua require('fzf-lua').lgrep_curbuf()<CR>", { silent = true, desc = "Live grep current buffer" })

-- markdown-preview keymaps
vim.g.mkdp_auto_close = 0
vim.keymap.set('n', "<leader>mp", "<Plug>MarkdownPreview", { silent = true, desc = "Preview Markdown" })
vim.keymap.set('n', "<leader>ms", "<Plug>MarkdownStop", { silent = true, desc = "Stop Markdown preview" })
vim.keymap.set('n', "<leader>mt", "<Plug>MarkdownToggle", { silent = true, desc = "Toggle Markdown preview" })
