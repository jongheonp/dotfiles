-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- vim.o.breakat = ' \t;:,!?'
vim.o.breakat = ' \t;:,!?])}'
vim.wo.breakindent = true
vim.opt.breakindentopt = {'sbr'} -- Maybe on sbr... don't know if it looks good
vim.o.linebreak = true
vim.wo.showbreak = '=> '

vim.o.clipboard = 'unnamedplus'
vim.wo.number = true
vim.wo.numberwidth = 1 
vim.wo.relativenumber = true
vim.o.mouse = 'a' -- Scroll with wheel without moving the cursor
vim.o.termguicolors = true
vim.wo.signcolumn = 'yes'

-- Tabs
vim.o.shiftwidth = 2 -- Number of whitespaces for (auto)indent
vim.o.softtabstop = -1
vim.o.expandtab = true -- Tabs to spaces

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

-- Set up plug-ins
require("lazy").setup({
  "lewis6991/gitsigns.nvim",
  {
    "catppuccin/nvim",
    name = 'catppuccin',
    priority = 1000,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects"
    },
    build = ':TSUpdate',
    config = function ()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false
        }
      })
    end
  }
})

require('gitsigns').setup({})

require('catppuccin').setup({
  flavour = 'mocha',
  transparent_background = true,
  show_end_of_buffer = false,
  term_colors = true
})

vim.cmd.colorscheme 'catppuccin'
