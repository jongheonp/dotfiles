local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({
  { family = 'JetBrains Mono', weight = 'Medium' },
  { family = 'Apple Color Emoji' }
})

-- NOTE: Has to be a better way...
local subtext1 = '#bac2de' -- ANSI 0
local surface2 = '#585b70' -- ANSI 8
local base = '#1e1e2e'
local crust = '#11111b'

local catppuccin_mocha = wezterm.get_builtin_color_schemes()['Catppuccin Mocha']
catppuccin_mocha.split = crust
config.color_schemes = {['Catppuccin Mocha'] = catppuccin_mocha}
config.color_scheme = 'Catppuccin Mocha'

config.colors = {
  tab_bar = {
    active_tab = {
      bg_color = base,
      fg_color = subtext1
    },
    inactive_tab = {
      bg_color = crust,
      fg_color = surface2
    },
    inactive_tab_edge = crust,
    inactive_tab_hover = {
      bg_color = base,
      fg_color = subtext1
    }
  }
}

config.window_decorations = 'INTEGRATED_BUTTONS | RESIZE'
config.window_frame = {
  font = wezterm.font { family = 'Roboto', weight = 'Bold' },
  font_size = 12.0,
  active_titlebar_bg = crust,
  inactive_titlebar_bg = crust
}

config.show_new_tab_button_in_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = true
config.default_cursor_style = 'SteadyBar'

config.keys = {
  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
  { key = 'LeftArrow', mods = 'OPT',
    action = wezterm.action({ SendString = '\x1bb'})
  },
  -- Make Option-Right equivalent to Alt-f; forward-word
  { key = 'RightArrow', mods = 'OPT',
    action = wezterm.action({ SendString = '\x1bf' })
  },
  {
    key = 'W', mods = 'CMD',
    action = wezterm.action.CloseCurrentTab({ confirm = true })
  },
  {
    key = 'w', mods = 'CMD',
    action = wezterm.action.CloseCurrentPane({ confirm = true })
  },
  {
    key = 'K', mods = 'CMD',
    action = wezterm.action.Multiple({
      wezterm.action.ClearScrollback('ScrollbackAndViewport'),
      wezterm.action.SendKey({ key = 'l', mods = 'CTRL' })
    })
  },
  {
    key = 'h', mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection('Left')
  },
  {
    key = 'l', mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection('Right')
  },
  {
    key = 'k', mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection('Up')
  },
  {
    key = 'j', mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection('Down')
  },
  {
    key = '/', mods = 'CMD',
    action = wezterm.action.RotatePanes('Clockwise')
  },
  {
    key = '<', mods = 'CMD',
    action = wezterm.action.MoveTabRelative(-1)
  },
  {
    key = '>', mods = 'CMD',
    action = wezterm.action.MoveTabRelative(1)
  },
  -- Unassign reset font size to make it consistent with SUPER-'-' as split vertical
  {
    key = '0', mods = 'SUPER',
    action = wezterm.action.DisableDefaultAssignment
  },
  -- Unassign decrease font size to make it consistent with SUPER-'-' as split vertical
  {
    key = '=', mods = 'SUPER',
    action = wezterm.action.DisableDefaultAssignment
  },
  {
    key = '\\', mods = 'CMD',
    action = wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' })
  },
  {
    key = '-', mods = 'CMD',
    action = wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' })
  },
  {
    key = 'z', mods = 'CMD',
    action = wezterm.action.TogglePaneZoomState
  }
}

return config
