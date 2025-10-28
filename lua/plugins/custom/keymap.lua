local M = {}

function M.set()
  vim.keymap.set("c", "<C-k>", "<Up>")
  vim.keymap.set("c", "<C-j>", "<Down>")

  -- Map Alt+o in normal mode to jump to older cursor position (like <C-o>)
  vim.keymap.set("n", "<A-o>", "<C-o>", { noremap = true })
  -- Map Alt+i in normal mode to jump to newer cursor position (like <C-i>)
  vim.keymap.set("n", "<A-i>", "<C-i>", { noremap = true })

  -- Remap in Normal mode for toggling comment on a line and selection
  vim.keymap.set("n", "<leader>c", "gcc", { remap = true, desc = "Toggle comment line" })
  vim.keymap.set("v", "<leader>c", "gc", { remap = true, desc = "Toggle comment selection" })
end

return M
