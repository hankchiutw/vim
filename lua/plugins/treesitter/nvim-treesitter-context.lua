local M = {}

function M.setup()
  vim.cmd([[
  hi TreesitterContextBottom gui=NONE
  hi TreesitterContextLineNumberBottom gui=NONE
  ]])

  vim.keymap.set("n", "[c", function()
    require("treesitter-context").go_to_context(vim.v.count1)
  end, { silent = true })
end

return {
  "nvim-treesitter/nvim-treesitter-context",
  init = M.setup,
  opts = {
    separator = "-",
  },
}
