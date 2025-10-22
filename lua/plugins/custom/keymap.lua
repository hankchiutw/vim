local M = {}

function M.set()
  vim.keymap.set("c", "<C-k>", "<Up>")
  vim.keymap.set("c", "<C-j>", "<Down>")

  -- Map Alt+o in normal mode to jump to older cursor position (like <C-o>)
  vim.keymap.set("n", "<A-o>", "<C-o>", { noremap = true })
  -- Map Alt+i in normal mode to jump to newer cursor position (like <C-i>)
  vim.keymap.set("n", "<A-i>", "<C-i>", { noremap = true })
end

return M
