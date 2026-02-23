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
}
