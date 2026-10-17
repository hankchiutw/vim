-- Run from the repository: nvim --headless -u NONE -l tests/tabbuffers.lua
vim.opt.rtp:prepend(vim.fn.getcwd())
vim.opt.hidden = true

local tb = require("custom.tabbuffers")
tb.setup()

local function open_file(name)
  vim.cmd("edit " .. vim.fn.tempname() .. "_" .. name)
  vim.cmd("doautocmd BufReadPost")
  return vim.api.nvim_get_current_buf()
end

-- 1. Tab-scoped buffer association & cross-tab jump
local tab1 = vim.api.nvim_get_current_tabpage()
assert(vim.w.has_tabbuffers == 1, "Main window in tab1 must have w:has_tabbuffers")
local buf_a = open_file("a.lua")
local buf_b = open_file("b.lua")
local buf_c = open_file("c.lua")

assert(vim.deep_equal(tb.get_tab_bufs(tab1), { buf_a, buf_b, buf_c }), "tab1 bufs mismatch")

vim.cmd("tabnew")
local tab2 = vim.api.nvim_get_current_tabpage()
assert(vim.w.has_tabbuffers == 1, "Main window in tab2 must have w:has_tabbuffers")
local buf_d = open_file("d.lua")
assert(vim.deep_equal(tb.get_tab_bufs(tab2), { buf_d }), "tab2 should only contain buf_d")
assert(not tb.is_buf_in_tab(buf_a, tab2), "buf_a must not be in tab2")

-- Entering buf_a from tab2 jumps back to tab1 and restores buf_d in tab2
vim.api.nvim_set_current_buf(buf_a)
assert(vim.api.nvim_get_current_tabpage() == tab1, "Should jump to tab1 when entering buf_a")
local tab2_win = vim.api.nvim_tabpage_get_win(tab2)
assert(vim.api.nvim_win_get_buf(tab2_win) == buf_d, "tab2 window should revert to buf_d")

-- 2. Quickfix unlisted
vim.cmd("copen")
local qf_buf = vim.api.nvim_get_current_buf()
assert(vim.bo[qf_buf].buflisted == false, "qf buffer must be nobuflisted")
assert(not tb.is_buf_in_tab(qf_buf, tab1), "qf buffer must not be added to tab bufs")
vim.cmd("cclose")

-- 3. Buffer cycling (<C-l> / <C-h>)
vim.api.nvim_set_current_buf(buf_c)
tb.switch(1)
assert(vim.api.nvim_get_current_buf() == buf_a, "switch(1) from last should wrap to first")
tb.switch(-1)
assert(vim.api.nvim_get_current_buf() == buf_c, "switch(-1) from first should wrap to last")

-- 4. Buffer reordering (+ / -)
vim.api.nvim_set_current_buf(buf_a)
tb.move(-1)
assert(vim.deep_equal(tb.get_tab_bufs(tab1), { buf_b, buf_c, buf_a }), "move(-1) on first should wrap to end")
tb.move(1)
assert(vim.deep_equal(tb.get_tab_bufs(tab1), { buf_a, buf_b, buf_c }), "move(1) on last should wrap to start")
assert(tb.compare_bufs(buf_a, buf_b, tab1) == true, "compare_bufs should order buf_a before buf_b")

-- 5. MRU history (~ / !) and forward truncation / deletion deduplication
vim.api.nvim_set_current_buf(buf_a)
vim.api.nvim_set_current_buf(buf_b)
vim.api.nvim_set_current_buf(buf_c)
tb.mru_back()
assert(vim.api.nvim_get_current_buf() == buf_b, "mru_back should go to buf_b")
tb.mru_forward()
assert(vim.api.nvim_get_current_buf() == buf_c, "mru_forward should go back to buf_c")
tb.mru_back()
assert(vim.api.nvim_get_current_buf() == buf_b, "mru_back should go to buf_b again")
local buf_e = open_file("e.lua")
local mru_list, mru_cur = tb.get_mru_bufs(tab1)
assert(mru_list[mru_cur] == buf_e, "mru_cur should point to newly opened buf_e")
for _, b in ipairs(mru_list) do
  assert(b ~= buf_c or _ < mru_cur, "forward history after buf_b should be truncated")
end

-- Deduplication on delete: visit buf_a -> buf_e -> buf_a, then delete buf_e
vim.api.nvim_set_current_buf(buf_a)
vim.api.nvim_set_current_buf(buf_e)
vim.api.nvim_set_current_buf(buf_a)
vim.api.nvim_buf_delete(buf_e, { force = true })
mru_list = tb.get_mru_bufs(tab1)
for i = 2, #mru_list do
  assert(mru_list[i] ~= mru_list[i - 1], "MRU list must not have adjacent duplicates after delete")
end

-- 6. Single-buffer split window fallback & Smart Quit (q)
vim.api.nvim_set_current_tabpage(tab2)
vim.cmd("vsplit")
local win1 = vim.fn.win_getid(1)
local win2 = vim.fn.win_getid(2)
vim.api.nvim_set_current_win(win1)
tb.switch(1)
assert(vim.api.nvim_get_current_win() == win2, "switch(1) with 1 tab buffer should move to next split window")
tb.switch(1)
assert(vim.api.nvim_get_current_win() == win1, "switch(1) at last window should wrap to top-left window")

-- Smart quit with multiple buffers in split preserves window layout
local buf_f = open_file("f.lua")
assert(#tb.get_tab_bufs(tab2) == 2, "tab2 should have 2 buffers")
tb.quit()
assert(vim.fn.winnr("$") == 2, "Smart quit with >1 buffer must preserve split windows")
assert(vim.api.nvim_get_current_buf() == buf_d, "Smart quit should switch to remaining buffer buf_d")
assert(not vim.api.nvim_buf_is_valid(buf_f), "Quitted buffer buf_f should be deleted")

-- Smart quit with 1 named buffer in multi-window replaces with empty buffer
tb.quit()
assert(vim.fn.winnr("$") == 2, "Smart quit on last named buffer in split keeps split open")
assert(vim.api.nvim_buf_get_name(0) == "", "Window should now hold an unnamed buffer")

-- Smart quit on unnamed buffer in multi-tab closes the tabpage
tb.quit()
assert(vim.fn.tabpagenr("$") == 1, "Smart quit on unnamed buffer should close tab2")
assert(vim.api.nvim_get_current_tabpage() == tab1, "Should return to tab1")

-- 7. Terminal lifecycle
vim.cmd("terminal sh -c 'exit 0'")
local term_buf = vim.api.nvim_get_current_buf()
assert(tb.is_buf_in_tab(term_buf, tab1), "Terminal buffer should be registered in tab1")
assert(vim.bo[term_buf].filetype == "tabbuffers-terminal", "Main window terminal should have filetype=tabbuffers-terminal")
local esc_map = vim.fn.maparg("<Esc>", "t", false, true)
assert(esc_map and esc_map.rhs == "<C-\\><C-n>", "Terminal <Esc> mapping missing")
tb.quit()
assert(not tb.is_buf_in_tab(term_buf, tab1), "Terminal buffer should be removed after quit")

-- 8. Tab naming and status display
assert(tb.get_tab_label(tab1) == "T1 »", "Default tab label should be 'T1 »'")
tb.rename_tab("work", tab1)
assert(tb.get_tab_label(tab1) == "work »", "Renamed tab label should be 'work »'")
assert(tb.get_cwd_status():match("1/1$"), "CWD status should end with tab ratio 1/1")

print("PASS: All tabbuffers behaviors verified")

-- 9. Non-file buffer smart quit (q!)
vim.cmd("split")
local scratch = vim.api.nvim_create_buf(false, true)
vim.bo[scratch].buftype = "nofile"
vim.api.nvim_set_current_buf(scratch)
assert(vim.fn.winnr("$") == 2, "Should have 2 windows before quitting nofile buffer")
tb.quit()
assert(vim.fn.winnr("$") == 1, "Quitting non-file buffer should close its window")

-- 10. Bufferline integration (keymaps, custom_filter, sort_by, custom_areas)
vim.opt.loadplugins = true
package.preload["custom.tabbuffers"] = function() return tb end
require("config.lazy")
assert(type(vim.fn.maparg("<C-l>", "n", false, true).callback) == "function", "<C-l> keymap missing")
assert(type(vim.fn.maparg("q", "n", false, true).callback) == "function", "q keymap missing")
local tabline_str = _G.nvim_bufferline()
assert(type(tabline_str) == "string" and tabline_str:find("work »"), "bufferline custom_areas missing tab label")
