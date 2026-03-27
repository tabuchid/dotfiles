local wezterm = require 'wezterm'

local function has_font(name)
  local handle = io.popen('fc-list : family 2>/dev/null')
  if not handle then
    return false
  end

  local output = handle:read '*a' or ''
  handle:close()
  return output:find(name, 1, true) ~= nil
end

local primary_font = has_font 'SF Mono' and 'SF Mono' or 'Menlo'

return {
  font = wezterm.font_with_fallback({
    primary_font,
    'Monaco',
  }),
  font_size = 12,
  -- Catppuccin Mocha
  colors = {
    foreground = "#CDD6F4",
    background = "#1E1E2E",
    cursor_bg = "#F5E0DC",
    cursor_border = "#F5E0DC",
    cursor_fg = "#1E1E2E",
    selection_bg = "#585B70",
    selection_fg = "#CDD6F4",
    scrollbar_thumb = "#585B70",
    split = "#6C7086",
    compose_cursor = "#F9E2AF",
    ansi = {
      "#45475A", -- black (surface1)
      "#F38BA8", -- red
      "#A6E3A1", -- green
      "#F9E2AF", -- yellow
      "#89B4FA", -- blue
      "#F5C2E7", -- pink
      "#94E2D5", -- teal
      "#BAC2DE", -- subtext1
    },
    brights = {
      "#585B70", -- surface2
      "#F38BA8", -- red
      "#A6E3A1", -- green
      "#F9E2AF", -- yellow
      "#89B4FA", -- blue
      "#F5C2E7", -- pink
      "#94E2D5", -- teal
      "#A6ADC8", -- subtext0
    },
    tab_bar = {
      background = "#181825",
      active_tab = { bg_color = "#CBA6F7", fg_color = "#11111B" },
      inactive_tab = { bg_color = "#181825", fg_color = "#CDD6F4" },
      inactive_tab_hover = { bg_color = "#1E1E2E", fg_color = "#CDD6F4" },
      new_tab = { bg_color = "#313244", fg_color = "#CDD6F4" },
      new_tab_hover = { bg_color = "#CBA6F7", fg_color = "#11111B" },
    },
  },
}
