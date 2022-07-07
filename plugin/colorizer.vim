lua << EOF
vim.opt.termguicolors = true
require'colorizer'.setup{
  "css",
  "scss",
  "javascript",
  "vim",
  "lua",
}
EOF
