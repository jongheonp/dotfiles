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
          FzfLuaPathColNr = { fg = colors.text },
          FzfLuaPathLineNr = { fg = colors.text },
          FzfLuaBufName = { fg = colors.blue }, -- For FzfLua lines
          FzfLuaBufNr = { fg = colors.text },
          FzfLuaBufFlagCur = { fg = colors.red },
          FzfLuaBufFlagAlt = { fg = colors.green },
          FzfLuaTabTitle = { fg = colors.text },
          FzfLuaTabMarker = { fg = colors.red },
          FzfLuaLiveSym = { fg = colors.green },
          MiniStatuslineFilename = { bg = colors.base },
          MiniStatuslineInactive = { fg = colors.surface1, bg = colors.base },
        }
      end
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme('catppuccin')
    end
  }
}
