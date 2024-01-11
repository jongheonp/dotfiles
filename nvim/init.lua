-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- vim.o.breakat = ' \t;:,!?'
vim.o.breakat = ' \t;:,!?])}'
vim.wo.breakindent = true
vim.opt.breakindentopt = {'shift:2', 'sbr'} -- Maybe on sbr... don't know if it looks good
vim.o.linebreak = true
vim.o.showbreak = '-> '

vim.o.clipboard = 'unnamedplus'
vim.wo.number = true
vim.wo.numberwidth = 1 
vim.wo.relativenumber = true
vim.o.mouse = 'a' -- Scroll with wheel without moving the cursor
vim.o.termguicolors = true
vim.wo.signcolumn = 'yes'
vim.o.hlsearch = false

-- Tabs
vim.o.shiftwidth = 2 -- Number of whitespaces for (auto)indent
vim.o.softtabstop = -1
vim.o.expandtab = true -- Tabs to spaces

vim.o.splitright = true

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
require("lazy").setup({
  {
  --  "catppuccin/nvim",
  --  name = 'catppuccin',
  --  priority = 1000,
  --  lazy = false,
  --  opts = {
  --    flavour = 'mocha',
  --    transparent_background = false,
  --    show_end_of_buffer = false,
  --    term_colors = true,
  --    no_italic = true 
  --  },
  --  config = function(_, opts)
  --    require('catppuccin').setup(opts)
  --    vim.cmd.colorscheme 'catppuccin'
  --  end
  },
  {
    "rose-pine/nvim",
    name = 'rose-pine',
    priority = 1000,
    lazy = false,
    opts = {
      dim_inactive_windows = false,
      extend_background_behind_borders = false,

      styles = {
        bold = true,
        italic = false,
        transparency = true,
      },

      groups = {
        border = "muted",
        link = "iris",
        panel = "surface",

        error = "love",
        hint = "iris",
        info = "foam",
        warn = "gold",

        git_add = "foam", 
        git_change = "rose",
        git_delete = "love",
        git_dirty = "rose",
        git_ignore = "muted",
        git_merge = "iris",
        git_rename = "pine",
        git_stage = "iris",
        git_text = "rose",
        git_untracked = "subtle",

        headings = {
          h1 = "iris",
          h2 = "foam",
          h3 = "rose",
          h4 = "gold",
          h5 = "pine",
          h6 = "foam",
        },
        -- Alternatively, set all headings at once.
        -- headings = "subtle",
      },
      highlight_groups = {
        EndOfBuffer = { fg = 'base' },
        StatusLine = { fg = 'love', bg = 'love', blend = 10 },
        StatusLineNC = { fg = 'subtle', bg = 'surface' },
      },
    },
    config = function(_, opts)
      require('rose-pine').setup(opts)
      vim.cmd.colorscheme 'rose-pine'
    end
  },
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    -- dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({})
    end
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup()
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    "neovim/nvim-lspconfig"
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects"
    },
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'c',
        'lua',
        'vim',
        'vimdoc',
        'query',
        'cpp',
        'ocaml',
        'python',
        'verilog',
        'gitcommit'
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

vim.o.updatetime = 250

-- on_attach...
local on_attach = function(_, bufnr)
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = 'single', -- 'single'
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
end

require('lspconfig').pyright.setup {
  on_attach = on_attach
}

-- fzf-lua keymaps
vim.keymap.set('n', "<leader>/", "<cmd>lua require('fzf-lua').buffers()<CR>", { silent = true, desc = "Open buffers" })
vim.keymap.set('n', "<leader>p", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true, desc = "find or fd on a path" })
vim.keymap.set('n', "<leader>r", "<cmd>lua require('fzf-lua').resume()<CR>", { silent = true, desc = "Resume last command/query" })
vim.keymap.set('n', "<leader>w", "<cmd>lua require('fzf-lua').grep_cword()<CR>", { silent = true, desc = "Search word under cursor" })
vim.keymap.set('n', "<leader>l", "<cmd>lua require('fzf-lua').live_grep()<CR>", { silent = true, desc = "Live grep current project" })
vim.keymap.set('n', "<leader>f", "<cmd>lua require('fzf-lua').lgrep_curbuf()<CR>", { silent = true, desc = "Live grep current buffer" })

-- markdown-preview keymaps
vim.g.mkdp_auto_close = 0
vim.keymap.set('n', "<leader>mp", "<Plug>MarkdownPreview", { silent = true, desc = "Preview Markdown" })
vim.keymap.set('n', "<leader>ms", "<Plug>MarkdownStop", { silent = true, desc = "Stop Markdown preview" })
vim.keymap.set('n', "<leader>mt", "<Plug>MarkdownToggle", { silent = true, desc = "Toggle Markdown preview" })
