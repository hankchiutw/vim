local M = {}

function M.setup()
  -- TODO: wait for nvim_set_hl being production
  -- e.g. vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { undercurl = true })
  vim.cmd("au colorscheme * highlight DiagnosticUnderlineError gui=undercurl guisp=#cf0000")
  vim.cmd("au colorscheme * highlight DiagnosticUnderlineWarn gui=undercurl")
  vim.cmd("au colorscheme * highlight DiagnosticUnderlineHint gui=undercurl guisp=#007ff7")
  vim.cmd("au colorscheme * highlight DiagnosticUnderlineInfo gui=undercurl")

  vim.cmd("au colorscheme * highlight DiagnosticVirtualTextError guifg=#cf0000")
  vim.cmd("au colorscheme * highlight DiagnosticVirtualTextHint guifg=#007ff7")
end

return M
