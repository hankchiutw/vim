local M = {}

function M.set()
	vim.cmd([[
  autocmd User TelescopePreviewerLoaded setlocal number wrap
  autocmd colorscheme * highlight TelescopeSelection ctermfg=yellow guifg=yellow gui=bold
  autocmd colorscheme * highlight TelescopeMatching ctermfg=cyan guifg=cyan
  autocmd colorscheme * highlight TelescopePreviewLine ctermbg=235 guibg=#464646
  autocmd colorscheme * highlight TelescopePromptCounter ctermfg=darkcyan guifg=darkcyan
  autocmd colorscheme * highlight TelescopeBorder ctermfg=grey guifg=grey
  ]])
end

return M
