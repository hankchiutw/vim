-- Run from the repository: nvim --headless -u NONE -l tests/treesitter.lua
vim.opt.loadplugins = true
vim.opt.rtp:prepend(vim.fn.getcwd())
require("config.lazy")

local ts = require("nvim-treesitter")
ts.install({ "vim", "lua", "markdown", "markdown_inline" }):wait(300000)

local function buffer(ft, lines)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(buf)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = ft
  return buf
end

-- Fenced code must parse its child language, not pass a node list as a node.
local markdown = buffer("markdown", { "```lua", "local x = 1", "```" })
local parser = vim.treesitter.get_parser(markdown, "markdown")
assert(parser:parse(true))
assert(parser:children().lua, "Markdown Lua injection missing")
assert(vim.treesitter.highlighter.active[markdown], "Native highlighting missing")

local vim_buf = buffer("vim", { "set number" })
require("telescope.previewers.utils").highlighter(vim_buf, "vim", {
  preview = { treesitter = { enable = true } },
})
assert(vim.treesitter.highlighter.active[vim_buf], "Telescope highlighting missing")
assert(vim.treesitter.get_parser(vim_buf, "vim"):parse(true))

buffer("lua", { "local x = 1", "function example()", "  return 1", "end" })
vim.api.nvim_win_set_cursor(0, { 1, 0 })
local mapping = vim.fn.maparg("]m", "n", false, true)
assert(type(mapping.callback) == "function", "Textobject movement mapping missing")
mapping.callback()
assert(vim.api.nvim_win_get_cursor(0)[1] == 2, "Function movement failed")
print("PASS: Markdown injections, native/Telescope highlighting, textobject movement")
