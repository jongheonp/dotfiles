return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    opts = {
      no_italic = true,
      custom_highlights = function(colors)
        return {
          WinSeparator = { fg = colors.base },
          StatusLine = { bg = colors.base },
          StatusLineNC = { bg = colors.base },
          FloatBorder = { bg = colors.mantle },
          FzfLuaHeaderBind = { fg = colors.surface2 },
          FzfLuaHeaderText = { fg = colors.surface2 },
          FzfLuaPathColNr = { link = 'Comment' },
          FzfLuaPathLineNr = { link = 'Comment' },
	  FzfLuaBufName = { fg = colors.text },
	  FzfLuaBufNr = { fg = colors.text },
	  FzfLuaBufFlagCur = { fg = colors.text },
	  FzfLuaBufFlagAlt = { fg = colors.text },
          FzfLuaLiveSym = { fg = colors.green },
          MiniStatuslineFilename = { link = 'StatusLine' },
          MiniStatuslineInactive = { link = 'StatusLineNC' }
        }
      end
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme('catppuccin')
    end
  }
}
