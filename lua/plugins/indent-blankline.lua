local function init_highlight()
  local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
  }

  local hooks = require("ibl.hooks")
  -- create the highlight groups in the highlight setup hook, so they are reset
  -- every time the colorscheme changes
  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#8A3940" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#8A7145" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#306385" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#785C34" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#5A6E43" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#704282" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#28646D" })
  end)
  vim.g.rainbow_delimiters.highlight = highlight
  hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

  return highlight
end

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  config = function()
    local highlight = init_highlight()
    require("ibl").setup({
      indent = {
        highlight = highlight,
        char = "▏",
      },
      scope = {
        highlight = highlight,
      },
    })
  end,
}
