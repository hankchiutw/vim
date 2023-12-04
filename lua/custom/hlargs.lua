local M = {}

function M.setup()
  require("hlargs").setup({
    performance = {
      max_iterations = 100,
    },
  })
end

return M
