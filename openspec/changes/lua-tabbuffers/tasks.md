## 1. Core `lua/custom/tabbuffers.lua` Module

- [x] 1.1 Create `lua/custom/tabbuffers.lua` with per-tab state management (`tabs[tabid] = { bufs = {}, mru = {}, mru_cur = 0, name = nil }`, `buf_tab[bufnr] = tabid`), helper getters (`get_tab_bufs`, `get_mru_bufs`, `is_buf_in_tab`, `compare_bufs`), and initial buffer registration on `setup()`; verify module loads cleanly with `nvim --headless -u NONE -c "lua require('custom.tabbuffers')" -c "qa!"`.
- [x] 1.2 Implement tab buffer lifecycle autocmds (`TabNew`, `VimEnter`, `TabClosed`, `BufReadPost`, `BufAdd`, `BufEnter`, `BufDelete`, `FileType qf`) including cross-tab jump (`jump_to_buftab`) and MRU tracking (max 20 entries, named listed buffers only, forward truncation, deletion deduplication); verify via headless assertions on tab buffer lists and MRU state.
- [x] 1.3 Implement navigation and manipulation APIs (`switch(offset)`, `move(offset)`, `mru_back()`, `mru_forward()`, `quit()`, `rename_tab(name)`, `prompt_tabname()`, `get_tab_label()`, `get_cwd_status()`) and terminal lifecycle handlers (`TermOpen`, `FileType tabbuffers-terminal`, `<Esc>` mapping, `TermClose`, `TermEnter`); verify all functions exist and execute without error in headless mode.

## 2. Plugin & Config Integration

- [x] 2.1 Update `lua/plugins/bufferline.lua` to remove `"hankchiutw/vim-tabbuffers"` dependency, initialize `require("custom.tabbuffers").setup()`, bind `<C-l>`, `<C-h>`, `+`, `-`, `q`, `~`, `!`, and `<C-g>n` to `custom.tabbuffers` functions, and wire `options.custom_filter`, `options.sort_by`, and `options.custom_areas.right`; verify `lua/plugins/bufferline.lua` loads without error and keymaps resolve to Lua callbacks.
- [x] 2.2 Consolidate `TermClose` autocmd in `lua/plugins/custom/init.lua` with `lua/custom/tabbuffers.lua` so terminal buffers do not trigger duplicate `bdelete!` calls; verify closing a terminal buffer produces no `E516` or invalid buffer errors.

## 3. Automated Verification

- [x] 3.1 Create `tests/tabbuffers.lua` covering tab-scoped buffer isolation, cross-tab jump on entering a buffer owned by another tab, `<C-h>/<C-l>` buffer cycling vs single-buffer split window fallback, `+`/`-` buffer reordering with wrap-around, `~`/`!` MRU back/forward and deletion deduplication, smart `q` quit (multi-buffer window preservation, single-buffer multi-window `enew` replacement, terminal quit, non-file quit), `qf` unlisting, and tab naming (`<C-g>n` / label formatting); verify `nvim --headless -u NONE -l tests/tabbuffers.lua` exits 0 and prints `PASS`.
