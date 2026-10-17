local M = {}

function M.setup()
  require("nvim-treesitter-textobjects").setup({
    select = { lookahead = true },
  })

  local mappings = {
    goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@block.outer" },
    goto_next_end = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
    goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@block.outer" },
    goto_previous_end = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
  }
  local move = require("nvim-treesitter-textobjects.move")
  for method, keys in pairs(mappings) do
    for key, capture in pairs(keys) do
      vim.keymap.set({ "n", "x", "o" }, key, function()
        move[method](capture, "textobjects")
      end, { desc = method .. " " .. capture })
    end
  end
end

return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  config = M.setup,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
}
