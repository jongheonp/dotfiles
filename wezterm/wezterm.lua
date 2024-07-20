local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({
  { family = 'JetBrains Mono', weight = 'Medium' },
  { family = 'Apple Color Emoji' }
})

-- NOTE: Has to be a better way...
local subtext0 = '#a6adc8'
local overlay0 = '#6c7086'
local surface0 = '#313244'
local base = '#1e1e2e'
local crust = '#11111b'

local catppuccin_mocha = wezterm.get_builtin_color_schemes()['Catppuccin Mocha']
catppuccin_mocha.split = surface0
config.color_schemes = {['Catppuccin Mocha'] = catppuccin_mocha}
config.color_scheme = 'Catppuccin Mocha'

config.colors = {
  tab_bar = {
    active_tab = {
      bg_color = base,
      fg_color = subtext0
    },
    inactive_tab = {
      bg_color = crust,
      fg_color = overlay0
    },
    inactive_tab_edge = crust
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
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

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
    key = 'Enter', mods = 'CMD',
    action = wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' })
  },
  {
    key = 'Enter', mods = 'CMD | SHIFT',
    action = wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' })
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
    key = 'k', mods = 'CMD',
    action = wezterm.action.Multiple({
      wezterm.action.ClearScrollback('ScrollbackAndViewport'),
      wezterm.action.SendKey({ key = 'l', mods = 'CTRL' })
    })
  },
  {
    key = 'H', mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection('Left')
  },
  {
    key = 'L', mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection('Right')
  },
  {
    key = 'K', mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection('Up')
  },
  {
    key = 'J', mods = 'CMD',
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
  {
    key = 'T',
    mods = 'SUPER | SHIFT',
    action = wezterm.action.ShowTabNavigator
  },
  {
    key = '0', mods = 'CTRL',
    action = wezterm.action.DisableDefaultAssignment
  },
  {
    key = '-', mods = 'CTRL',
    action = wezterm.action.DisableDefaultAssignment
  },
  {
    key = '=', mods = 'CTRL',
    action = wezterm.action.DisableDefaultAssignment
  },
}

return config
