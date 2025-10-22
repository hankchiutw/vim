require("plugins.custom.keymap").set()

-- Automatically close terminal buffer if the shell exited successfully
vim.api.nvim_create_autocmd("TermClose", {
  pattern = "*",
  callback = function(args)
    vim.schedule(function()
      if vim.bo.buftype == "terminal" and vim.v.shell_error == 0 then
        vim.cmd("bdelete! " .. args.buf)
      end
    end)
  end,
})

-- Set terminal background to black on opening a terminal buffer
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    local ns = vim.api.nvim_create_namespace("my_terminal_highlight")
    vim.api.nvim_set_hl(ns, "Normal", { bg = "#000000" })
    vim.api.nvim_win_set_hl_ns(0, ns)
  end,
})

return {
  {
    "windwp/nvim-autopairs",
    opts = {},
  },
  {
    "tpope/vim-fugitive",
    init = function()
      vim.keymap.set("n", "<c-g>b", ":G blame<CR>", { desc = "Git blame" })
      vim.keymap.set("n", "<c-g>f", ":G file %<CR><c-\\><c-o><c-w>_", { desc = "Git file history" })
      vim.keymap.set("n", "<c-g>r", ":G co %<CR>", { desc = "Git reset HEAD" })
    end,
  },
}
