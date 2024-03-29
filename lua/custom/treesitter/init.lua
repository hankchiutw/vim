local M = {}

local plugins = {
  "nvim-treesitter",
  "nvim-ts-autotag",
  "nvim-treesitter-context",
}

function M.setup()
  for _, name in ipairs(plugins) do
    require("custom.treesitter." .. name).setup()
  end
end

return M
