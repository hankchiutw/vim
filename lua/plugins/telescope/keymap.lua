local M = {}

local builtin = require("telescope.builtin")
local custom_buffers = require("plugins.telescope.builtin_buffers").buffers
local flag = { silent = true, noremap = true }

local utils = require("telescope.utils")
local entry_display = require("telescope.pickers.entry_display")

local function gen_entry_maker(opts)
  opts = opts or {}

  local signs = (function()
    if opts.no_sign then
      return
    end
    local signs = {}
    local type_diagnostic = vim.diagnostic.severity
    for _, severity in ipairs(type_diagnostic) do
      local status, sign = pcall(function()
        -- only the first char is upper all others are lowercalse
        return vim.trim(vim.fn.sign_getdefined("DiagnosticSign" .. severity:lower():gsub("^%l", string.upper))[1].text)
      end)
      if not status then
        sign = severity:sub(1, 1)
      end
      signs[severity] = sign
    end
    return signs
  end)()

  local display_items = {
    { width = signs ~= nil and 10 or 8 },
    { remaining = true },
  }
  local line_width = vim.F.if_nil(opts.line_width, 0.5)
  local hidden = utils.is_path_hidden(opts)
  if not hidden then
    table.insert(display_items, 2, { width = line_width })
  end
  local displayer = entry_display.create({
    separator = " │ ",
    items = display_items,
  })

  local make_display = function(entry)
    local filename = utils.transform_path(opts, entry.filename)

    -- add styling of entries
    local pos = string.format("%4d:%2d", entry.lnum, entry.col)
    local line_info = {
      (signs and signs[entry.type] .. " " or "") .. pos,
      "Diagnostic" .. entry.type,
    }

    return displayer({
      line_info,
      entry.text,
      filename,
    })
  end

  return function(entry)
    return {
      value = entry,
      ordinal = ("%s %s"):format(not hidden and entry.filename or "", entry.text),
      display = make_display,
      filename = entry.filename,
      type = entry.type,
      lnum = entry.lnum,
      col = entry.col,
      text = entry.text,
    }
  end
end

local function custom_diagnostics()
  builtin.diagnostics({
    entry_maker = gen_entry_maker(),
  })
end

-- live grep in git repository root directory
local function live_grep_git_dir()
  local git_dir = vim.fn.system(string.format("git -C %s rev-parse --show-toplevel", vim.fn.expand("%:p:h")))
  git_dir = string.gsub(git_dir, "\n", "") -- remove newline character from git_dir

  builtin.live_grep({
    cwd = git_dir,
  })
end

--- Performs a live grep search using Telescope, pre-filling the search text with the current visual selection (if any) or the word under the cursor.
local function live_grep_selection_or_cword()
  -- Clear register 'a' before yanking
  vim.fn.setreg("a", "")
  -- Yank selection to register 'a'
  vim.cmd('normal! "ay')
  -- Get content and escape spaces
  local visual_selection = vim.fn.escape(vim.fn.getreg("a"), " ")

  local text = (visual_selection ~= "" and visual_selection) or vim.fn.expand("<cword>")
  builtin.live_grep({
    default_text = text,
  })
end

function M.set()
  vim.keymap.set("n", "<leader>f", builtin.find_files, flag)
  vim.keymap.set("n", "<leader>F", builtin.git_files, flag)
  vim.keymap.set("n", "<leader>S", builtin.git_status, flag)
  vim.keymap.set("n", "<leader>b", builtin.git_bcommits, flag)
  vim.keymap.set("n", "<leader>g", builtin.live_grep, flag)
  vim.keymap.set({ "n", "v" }, "<leader>r", live_grep_selection_or_cword, flag)
  vim.keymap.set("n", "<leader>G", live_grep_git_dir, flag)
  vim.keymap.set("n", "<leader>w", custom_buffers, flag)
  vim.keymap.set("n", "<leader>m", builtin.marks, flag)
  vim.keymap.set("n", "<leader>q", builtin.quickfix, flag)
  vim.keymap.set("n", "<c-k>", builtin.lsp_references, flag)
  vim.keymap.set("n", "<leader>d", custom_diagnostics, flag)
  vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, flag)
end

return M
