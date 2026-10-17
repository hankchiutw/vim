local api, fn = vim.api, vim.fn

local M = {
  mru_size = 20,
}

local tabs = {}
local buf_tab = {}
local jumping = false

local function get_tab(tabid)
  tabid = tabid or api.nvim_get_current_tabpage()
  if not tabs[tabid] then
    tabs[tabid] = { bufs = {}, mru = {}, mru_cur = 0, name = nil }
  end
  return tabs[tabid], tabid
end

local function index_of(list, val)
  for i, v in ipairs(list) do
    if v == val then return i end
  end
  return nil
end

local function mark_main_win(tabid)
  tabid = tabid or api.nvim_get_current_tabpage()
  local wins = api.nvim_tabpage_list_wins(tabid)
  if wins[1] and api.nvim_win_is_valid(wins[1]) then
    vim.w[wins[1]].has_tabbuffers = 1
  end
end

function M.get_tab_bufs(tabid)
  return (get_tab(tabid)).bufs
end

function M.get_mru_bufs(tabid)
  local t = get_tab(tabid)
  return t.mru, t.mru_cur
end

function M.get_buf_tab(bufnr)
  return buf_tab[bufnr]
end

function M.is_buf_in_tab(bufnr, tabid)
  return index_of(M.get_tab_bufs(tabid), bufnr) ~= nil
end

function M.compare_bufs(buf_a, buf_b, tabid)
  local bufs = M.get_tab_bufs(tabid)
  local ia, ib = index_of(bufs, buf_a), index_of(bufs, buf_b)
  if ia and ib then return ia < ib end
  if ia then return true end
  if ib then return false end
  return buf_a < buf_b
end

function M.add_tab_buf(bufnr, tabid)
  bufnr = bufnr or api.nvim_get_current_buf()
  if not api.nvim_buf_is_valid(bufnr) or not vim.bo[bufnr].buflisted then return end
  local owner = buf_tab[bufnr]
  if owner and api.nvim_tabpage_is_valid(owner) then return end
  local t, tid = get_tab(tabid)
  if not index_of(t.bufs, bufnr) then
    table.insert(t.bufs, bufnr)
  end
  buf_tab[bufnr] = tid
end

function M.unset_tab_buf(bufnr)
  local owner = buf_tab[bufnr]
  buf_tab[bufnr] = nil
  for _, t in pairs(tabs) do
    local idx = index_of(t.bufs, bufnr)
    if idx then table.remove(t.bufs, idx) end
  end
  if owner and tabs[owner] then
    local idx = index_of(tabs[owner].bufs, bufnr)
    if idx then table.remove(tabs[owner].bufs, idx) end
  end
end

function M.add_mru_buf(bufnr, tabid)
  bufnr = bufnr or api.nvim_get_current_buf()
  if not api.nvim_buf_is_valid(bufnr) or not vim.bo[bufnr].buflisted then return end
  if api.nvim_buf_get_name(bufnr) == "" then return end

  local t = get_tab(tabid)
  if #t.mru > 0 and t.mru[t.mru_cur] == bufnr then return end

  if t.mru_cur >= 1 and t.mru_cur < #t.mru then
    for i = #t.mru, t.mru_cur + 1, -1 do
      table.remove(t.mru, i)
    end
  end

  table.insert(t.mru, bufnr)
  if #t.mru > M.mru_size then
    table.remove(t.mru, 1)
  end
  t.mru_cur = #t.mru
end

function M.unset_mru_buf(bufnr)
  for _, t in pairs(tabs) do
    local next_mru = {}
    for _, b in ipairs(t.mru) do
      if b ~= bufnr and next_mru[#next_mru] ~= b then
        table.insert(next_mru, b)
      end
    end
    t.mru = next_mru
    t.mru_cur = #next_mru
  end
end

local function jump_to_buftab(bufnr)
  if jumping then return false end
  bufnr = bufnr or api.nvim_get_current_buf()
  local owner = buf_tab[bufnr]
  local cur_tab = api.nvim_get_current_tabpage()
  if owner and owner ~= cur_tab and api.nvim_tabpage_is_valid(owner) then
    jumping = true
    local t = get_tab(cur_tab)
    local prev = fn.bufnr("#")
    if not (prev > 0 and api.nvim_buf_is_valid(prev) and M.is_buf_in_tab(prev, cur_tab)) then
      prev = t.mru[#t.mru] or t.bufs[1]
    end
    if prev and prev ~= bufnr and api.nvim_buf_is_valid(prev) then
      pcall(api.nvim_win_set_buf, 0, prev)
    else
      pcall(vim.cmd, "silent! bprevious")
    end
    pcall(api.nvim_set_current_tabpage, owner)
    jumping = false
    return true
  end
  return false
end

function M.mru_back()
  local t = get_tab()
  if t.mru_cur <= 1 then return end
  t.mru_cur = t.mru_cur - 1
  local target = t.mru[t.mru_cur]
  if target and api.nvim_buf_is_valid(target) then
    api.nvim_set_current_buf(target)
  end
end

function M.mru_forward()
  local t = get_tab()
  if t.mru_cur >= #t.mru then return end
  t.mru_cur = t.mru_cur + 1
  local target = t.mru[t.mru_cur]
  if target and api.nvim_buf_is_valid(target) then
    api.nvim_set_current_buf(target)
  end
end

function M.move(offset)
  local bufnr = api.nvim_get_current_buf()
  local t = get_tab()
  local idx = index_of(t.bufs, bufnr)
  if not idx then return end
  local len = #t.bufs
  local next_idx = idx + offset

  table.remove(t.bufs, idx)
  if offset == -1 and next_idx == 0 then
    table.insert(t.bufs, bufnr)
  elseif offset == 1 and next_idx == len + 1 then
    table.insert(t.bufs, 1, bufnr)
  else
    table.insert(t.bufs, next_idx, bufnr)
  end
  vim.cmd.redrawtabline()
end

function M.switch(offset)
  if not vim.bo.buflisted then return end
  local t = get_tab()
  if #t.bufs > 1 then
    local bufnr = api.nvim_get_current_buf()
    local idx = index_of(t.bufs, bufnr) or 1
    local next_idx = ((idx - 1 + offset) % #t.bufs) + 1
    local target = t.bufs[next_idx]
    if target and api.nvim_buf_is_valid(target) then
      api.nvim_set_current_buf(target)
    end
    return
  end

  local cur_winnr = fn.winnr()
  local win_count = fn.winnr("$")
  if offset == 1 then
    vim.cmd.wincmd(cur_winnr == win_count and "t" or "l")
  elseif offset == -1 then
    vim.cmd.wincmd(cur_winnr == 1 and "b" or "h")
  end
end

function M.quit()
  local bufnr = api.nvim_get_current_buf()
  local bt = vim.bo[bufnr].buftype
  if bt == "terminal" then
    vim.cmd("bdelete!")
    return
  end
  if bt ~= "" then
    vim.cmd("q!")
    return
  end

  vim.cmd("lclose")

  local t, cur_tab = get_tab()
  if #t.bufs > 1 then
    M.unset_tab_buf(bufnr)
    M.unset_mru_buf(bufnr)
    local target = (#t.mru > 0 and t.mru[#t.mru]) or t.bufs[1]
    if target and api.nvim_buf_is_valid(target) then
      for _, w in ipairs(api.nvim_tabpage_list_wins(cur_tab)) do
        if api.nvim_win_get_buf(w) == bufnr then
          api.nvim_win_set_buf(w, target)
        end
      end
    end
    if api.nvim_buf_is_valid(bufnr) then
      api.nvim_buf_delete(bufnr, { force = true })
    end
  elseif fn.winnr("$") == 1 then
    vim.cmd("q!")
  elseif api.nvim_buf_get_name(bufnr) == "" then
    if fn.tabpagenr("$") > 1 then
      vim.cmd("tabclose")
    else
      vim.cmd("qa!")
    end
  else
    local empty_buf = api.nvim_create_buf(true, false)
    for _, w in ipairs(api.nvim_tabpage_list_wins(cur_tab)) do
      if api.nvim_win_get_buf(w) == bufnr then
        api.nvim_win_set_buf(w, empty_buf)
      end
    end
    if api.nvim_buf_is_valid(bufnr) then
      api.nvim_buf_delete(bufnr, { force = true })
    end
  end
end

function M.rename_tab(name, tabid)
  local t = get_tab(tabid)
  local tabnr = tabid and api.nvim_tabpage_get_number(tabid) or fn.tabpagenr()
  t.name = (name and name ~= "") and name or ("T" .. tabnr)
  vim.cmd.redrawtabline()
end

function M.prompt_tabname()
  fn.inputsave()
  local ok, name = pcall(fn.input, "Enter tab name: ")
  fn.inputrestore()
  api.nvim_echo({ { "" } }, false, {})
  if ok then M.rename_tab(name) end
end

function M.get_tab_label(tabid)
  local t = get_tab(tabid)
  local tabnr = tabid and api.nvim_tabpage_get_number(tabid) or fn.tabpagenr()
  local name = t.name or ("T" .. tabnr)
  return name .. " »"
end

function M.get_cwd_status()
  local cwd = fn.fnamemodify(fn.getcwd(), ":~:.")
  return string.format("%s %d/%d", cwd, fn.tabpagenr(), fn.tabpagenr("$"))
end

function M.reset()
  tabs = {}
  buf_tab = {}
  jumping = false
end

function M.setup()
  local group = api.nvim_create_augroup("tabbuffer", { clear = true })

  mark_main_win()
  for _, b in ipairs(api.nvim_list_bufs()) do
    if api.nvim_buf_is_loaded(b) and vim.bo[b].buflisted and api.nvim_buf_get_name(b) ~= "" then
      M.add_tab_buf(b)
    end
  end
  M.add_mru_buf(api.nvim_get_current_buf())

  api.nvim_create_autocmd({ "TabNew", "VimEnter" }, {
    group = group,
    callback = function() mark_main_win() end,
  })

  api.nvim_create_autocmd("TabClosed", {
    group = group,
    callback = function()
      local valid = {}
      for _, tid in ipairs(api.nvim_list_tabpages()) do
        valid[tid] = true
      end
      for tid in pairs(tabs) do
        if not valid[tid] then tabs[tid] = nil end
      end
      for b, tid in pairs(buf_tab) do
        if not valid[tid] then buf_tab[b] = nil end
      end
    end,
  })

  api.nvim_create_autocmd("BufReadPost", {
    group = group,
    callback = function(args) M.add_tab_buf(args.buf) end,
  })

  api.nvim_create_autocmd("BufDelete", {
    group = group,
    callback = function(args)
      M.unset_tab_buf(args.buf)
      M.unset_mru_buf(args.buf)
    end,
  })

  api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = function(args)
      if not jump_to_buftab(args.buf) then
        M.add_mru_buf(args.buf)
      end
    end,
  })

  api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "qf",
    callback = function(args) vim.bo[args.buf].buflisted = false end,
  })

  api.nvim_create_autocmd("TermOpen", {
    group = group,
    callback = function(args)
      M.add_tab_buf(args.buf)
      if vim.w.has_tabbuffers then
        vim.bo[args.buf].filetype = "tabbuffers-terminal"
      end
    end,
  })

  api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "tabbuffers-terminal",
    callback = function(args)
      vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = args.buf, noremap = true })
      api.nvim_create_autocmd("TermEnter", {
        group = group,
        buffer = args.buf,
        callback = function() jump_to_buftab(args.buf) end,
      })
      api.nvim_create_autocmd("TermClose", {
        group = group,
        buffer = args.buf,
        callback = function()
          M.unset_tab_buf(args.buf)
          M.unset_mru_buf(args.buf)
          vim.schedule(function()
            if api.nvim_buf_is_valid(args.buf) then
              if api.nvim_get_current_buf() == args.buf then
                pcall(vim.cmd, "silent! b#")
              end
              pcall(api.nvim_buf_delete, args.buf, { force = true })
            end
          end)
        end,
      })
    end,
  })
end

return M
