local M = {}

local diffview = require("diffview")
local lib = require("diffview.lib")

local function make_toggle_fn(fn)
  return function()
    local view = lib.get_current_view()
    if view then
      diffview.close()
    else
      fn()
    end
  end
end

local function blame_commit_info()
  local file_path = vim.fn.expand("%:p")
  local line_num = vim.fn.line(".")
  local cmd = "git blame -p -L" .. line_num .. ",+1 " .. file_path
  local rows = vim.fn.split(vim.fn.system(cmd), "\n")
  local commit_rev = vim.fn.split(table.remove(rows, 1), " ")[1]

  local commit_info = { sha = string.sub(commit_rev, 1, 10) }
  for _, row in ipairs(rows) do
    local ar = vim.fn.split(row, " ")
    local k = table.remove(ar, 1)
    local v = table.concat(ar, " ")
    if k == "author" then
      commit_info[k] = v
    elseif k == "summary" then
      commit_info[k] = v
    elseif k == "author-time" then
      commit_info.date = os.date("%Y-%m-%d %X", tonumber(v))
    end
  end

  return commit_info
end

local toggle_open = make_toggle_fn(diffview.open)
local toggle_file_history = make_toggle_fn(function()
  diffview.file_history(nil, "%")
end)

local toggle_line_blame = make_toggle_fn(function()
  local commit_info = blame_commit_info()
  local sha = commit_info.sha

  diffview.open(sha .. "~1.." .. sha)

  local info = table.concat({ sha, commit_info.date, commit_info.author, commit_info.summary }, " • ")
  print(info)
end)

local function set_keymap()
  local flag = { silent = true, noremap = true }
  vim.keymap.set("n", ",t", toggle_open, flag)
  vim.keymap.set("n", ",f", toggle_file_history, flag)
  vim.keymap.set("n", ",d", toggle_line_blame, flag)
end

function M.setup()
  set_keymap()
  diffview.setup({
    keymaps = {
      view = {
        ["q"] = diffview.close,
      },
      file_panel = {
        ["q"] = diffview.close,
      },
      file_history_panel = {
        ["q"] = diffview.close,
      },
    },
  })
end

return M
