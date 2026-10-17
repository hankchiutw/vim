## Context

See `proposal.md` for motivation. Currently, `/home/hankchiu/code/vim.feat-vim-tabbuffer` loads `akinsho/bufferline.nvim` via `lazy.nvim` (`lua/plugins/bufferline.lua`) with `hankchiutw/vim-tabbuffers` as a dependency. Because `bufferline.nvim` manages its own buffer list and `vim-tabbuffers` was built around `t:tabbufs` and `vim-airline`, the two systems do not share state:
- `bufferline.nvim` shows all global buffers instead of filtering by `t:tabbufs`.
- `<C-h>/<C-l>` and `+`/`-` call `BufferLineCycle*` and `BufferLineMove*`, ignoring `tabbuffers#switch` and `tabbuffers#move`.
- `lua/plugins/custom/init.lua` defines a global `TermClose` autocmd that calls `bdelete!`, which races with `vim-tabbuffers`'s `TermClose` (`b# | bd! #`).
- `autoload/tabbuffers/airline.vim` maps `<C-g>n` and calls `airline#extensions#tabline#redraw()`, which errors or no-ops without `vim-airline`.

## Goals / Non-Goals

**Goals:**
- Implement a self-contained Lua module `lua/custom/tabbuffers.lua` that reproduces all user-facing behaviors of `vim-tabbuffers` while using idiomatic Neovim Lua APIs.
- Integrate directly with `bufferline.nvim` for per-tab buffer filtering, custom ordering, and tab label/cwd rendering.
- Eliminate temporary `enew` buffer churn during `q` (smart quit) where possible.
- Provide deterministic headless tests in `tests/tabbuffers.lua` runnable via `nvim --headless -u NONE -l tests/tabbuffers.lua`.

**Non-Goals:**
- Supporting legacy Vim (non-Neovim) or `vim-airline`.
- Modifying external repositories (`~/code/vim-tabbuffers` remains untouched).

## Decisions

### 1. State Model: Lua Table Keyed by Tabpage Handle (`nvim_get_current_tabpage()`)
- **Choice**: Store per-tab state in a module-local Lua table `state.tabs[tabid] = { bufs = {}, mru = {}, mru_cur = 0, name = nil }` and buffer ownership in `state.buf_tab[bufnr] = tabid`, where `tabid` is the Neovim tabpage handle (not the 1-indexed `tabpagenr()`).
- **Rationale**:
  1. In Vimscript, `b:buftab = tabpagenr()` breaks whenever an earlier tabpage is closed or reordered (`:tabmove`), because tab numbers shift while `b:buftab` stays static. Neovim tabpage handles are unique, immutable IDs for the lifetime of the tabpage.
  2. Mutating `vim.t.tabbufs` from Lua requires reading, copying, mutating, and re-assigning the entire list on every operation because `vim.t` returns copies of Vimscript lists. Keeping Lua tables as the source of truth is faster and simpler.
  3. For backward compatibility or inspection if needed, we can optionally sync or expose helper getters (`get_tab_bufs(tabid)`, `get_mru_bufs(tabid)`).
- **Alternatives Considered**: Storing lists in `vim.t[tabid].tabbufs` and `vim.b[bufnr].buftab`. Rejected due to list-copy semantics in `vim.t` and tab number shifting bugs with `tabpagenr()`.

### 2. `bufferline.nvim` Integration via `custom_filter`, `sort_by`, and `custom_areas`
- **Choice**:
  - `options.custom_filter`: `function(bufnr) return tabbuffers.is_buf_in_tab(bufnr) end` — filters `bufferline` components to only buffers present in the current tabpage's `bufs` list.
  - `options.sort_by`: `function(a, b) return tabbuffers.compare_bufs(a.id, b.id) end` — orders `bufferline` components strictly by their index in the current tabpage's `bufs` list.
  - `options.custom_areas.right`: Renders `{ { text = " " .. tabbuffers.get_tab_label() .. " " }, { text = " " .. tabbuffers.get_cwd_status() .. " " } }` to replicate the original airline right-side status (`<tabname> »` and `<cwd> <tabnr>/<total>`).
- **Rationale**: Uses `bufferline.nvim`'s public configuration hooks rather than monkey-patching internal `bufferline.state` modules. When `tabbuffers.move(offset)` mutates `tab.bufs` and calls `vim.cmd.redrawtabline()`, `bufferline` re-evaluates `sort_by` and reflects the new order immediately.
- **Alternatives Considered**: Driving ordering through `BufferLineMoveNext/Prev` (`state.custom_sort`). Rejected because `bufferline`'s `state.custom_sort` is global across all tabs, whereas `tabbuffers` maintains per-tab ordering.

### 3. Smart Quit (`q`) Without Temporary `enew` Buffer Churn
- **Choice**: When quitting a normal file buffer where `#tab.bufs > 1`:
  1. Remove `curr_buf` from `tab.bufs` and `tab.mru` first (or determine the replacement buffer from `tab.mru` / `tab.bufs` excluding `curr_buf`).
  2. Switch the current window directly to `target_buf` via `vim.api.nvim_win_set_buf(0, target_buf)`.
  3. Delete `curr_buf` via `vim.api.nvim_buf_delete(curr_buf, { force = true })`.
- **Rationale**: Original Vimscript did `enew | bd! # | exec 'b' . target | bd! #` to avoid closing the window when deleting its buffer. In Neovim Lua, switching the window's buffer to `target_buf` first and then calling `nvim_buf_delete(curr_buf, { force = true })` keeps the window open without creating and destroying two temporary buffers or firing spurious `BufEnter`/`BufDelete` events.

### 4. Terminal Lifecycle Consolidation
- **Choice**: Remove the duplicate `TermClose` autocmd in `lua/plugins/custom/init.lua` and handle terminal buffer lifecycle inside `lua/custom/tabbuffers.lua`:
  - On `TabNew` and `VimEnter`: set `vim.w[winid].has_tabbuffers = 1` on the first window of the tabpage.
  - On `TermOpen`: register the terminal buffer in the current tab's `bufs`; if `vim.w.has_tabbuffers` is set, set `bo.filetype = "tabbuffers-terminal"`, map buffer-local `<Esc>` in `t` mode to `<C-\><C-n>`, and attach buffer-local `TermEnter` (jump to owning tab) and `TermClose` (unset from tabbuffers, switch to alternate/MRU buffer, and `nvim_buf_delete` safely). For non-`has_tabbuffers` terminals (like floating/split runners), preserve the clean-exit auto-close behavior from `lua/plugins/custom/init.lua` without double-deleting.

## Risks / Trade-offs

- **[Risk] Recursive `BufEnter` autocommands during cross-tab jump (`jump_to_buftab`)** → **Mitigation**: Guard `jump_to_buftab` with a re-entrancy flag (`jumping = true`) or `vim.schedule` / `noautocmd` where appropriate so reverting the origin window buffer (`bp` / `nvim_win_set_buf`) and switching tabpages (`nvim_set_current_tabpage`) does not trigger infinite loops.
- **[Risk] Startup buffer registration order (`VimEnter` / first file opened from CLI)** → **Mitigation**: On `setup()`, immediately initialize the current tabpage (`w:has_tabbuffers = 1`) and scan any already-loaded listed buffers (such as files passed via `nvim file1 file2`) into the initial tabpage's `bufs` and `mru`.
