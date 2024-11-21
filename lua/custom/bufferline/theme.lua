local colors = {
  inactive_fg = "#101010",
  inactive_bg = "#555555",
  active_bg = "#06d6a0",
  darkred = "#6f111e",
  red = "#ff686b",
  darkpink = "#71405b",
  pink = "#f0a6ff",
  darkred2 = "#443047",
  red2 = "#f49cbb",
}

local inactive = {
  fg = colors.inactive_fg,
  bg = colors.inactive_bg,
}
local selected = {
  fg = colors.inactive_fg,
  bg = colors.active_bg,
}

return {
  fill = inactive,
  background = inactive,
  separator = inactive,
  offset_separator = inactive,

  buffer = inactive,
  buffer_visible = inactive,
  warning = inactive,
  error = inactive,
  hint = inactive,
  info = inactive,
  indicator = inactive,
  numbers = inactive,
  tab = inactive,
  pick = inactive,
  tab_seperator = inactive,

  buffer_selected = selected,
  warning_selected = selected,
  error_selected = selected,
  hint_selected = selected,
  info_selected = selected,
  indicator_selected = selected,
  numbers_selected = selected,
  tab_selected = selected,
  pick_selected = selected,
  tab_seperator_selected = inactive,

  duplicate = {
    fg = colors.darkpink,
  },
  duplicate_selected = {
    fg = colors.pink,
  },

  error_diagnostic = {
    fg = colors.darkred,
    bg = colors.inactive_bg,
  },
  error_diagnostic_selected = {
    fg = colors.red,
  },
  error_diagnostic_visible = {
    fg = colors.red,
  },

  modified = {
    fg = colors.inactive_fg,
    bg = colors.darkred2,
  },
  modified_visible = {
    fg = colors.inactive_fg,
    bg = colors.darkred2,
  },
  modified_selected = {
    fg = colors.inactive_fg,
    bg = colors.red2,
  },
}
