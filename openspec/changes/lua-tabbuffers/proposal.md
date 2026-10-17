## Why

`hankchiutw/vim-tabbuffers` was originally written in Vimscript for `vim-airline`. Since migrating the Neovim configuration in `/home/hankchiu/code/vim.feat-vim-tabbuffer` to `lazy.nvim` and `bufferline.nvim`, half of `vim-tabbuffers` is disconnected or broken (bufferline shows global buffers instead of tab-scoped buffers, buffer cycling/moving bypasses `t:tabbufs`, `TermClose` logic conflicts with `lua/plugins/custom/init.lua`, and airline tab naming is broken). Porting `vim-tabbuffers` to native Lua directly in this repository restores full tab-scoped buffer isolation, MRU navigation, smart quitting, terminal handling, and tab naming without external plugin overhead.

## What Changes

- **Remove external plugin dependency**: Remove `"hankchiutw/vim-tabbuffers"` from `lua/plugins/bufferline.lua` (and legacy `init.vim` reference if applicable).
- **Add native Lua module `lua/custom/tabbuffers.lua`**:
  - Track tab-scoped buffer lists and buffer-to-tabpage ownership using stable Neovim tabpage handles (`nvim_get_current_tabpage()`).
  - Automatically jump to the owning tabpage when entering a buffer already associated with another valid tabpage, restoring the previous buffer in the origin window.
  - Track per-tab MRU buffer history (capped at 20 entries, excluding unnamed and unlisted buffers) with `mru_back()` (`~`) and `mru_forward()` (`!`) navigation.
  - Provide tab-scoped buffer switching (`<C-h>` / `<C-l>`) that cycles through the current tab's buffers when multiple exist, or falls back to window split navigation (`<C-w>h/l/t/b`) when only one tab buffer exists.
  - Provide tab-scoped buffer reordering (`+` / `-`) with wrap-around at list boundaries.
  - Provide smart quit (`q`) that closes location lists, deletes terminal buffers, quits non-file windows, or replaces the current buffer with the previous MRU/tab buffer before deleting so split window layouts remain intact.
  - Handle terminal buffers (`TermOpen`, `TermEnter`, `TermClose`, `<Esc>` to exit terminal mode in main window terminals) and unlist `qf` buffers.
  - Provide interactive tab naming (`<C-g>n`) and tab status display (`[TabName] cwd tabnr/total_tabs`).
- **Integrate with `lua/plugins/bufferline.lua`**:
  - Configure `options.custom_filter` and `options.sort_by` to filter and order buffers per tab via `custom.tabbuffers`.
  - Configure `options.custom_areas.right` to render the tab name, current working directory, and tab count.
  - Bind `<C-h>`, `<C-l>`, `+`, `-`, `q`, `~`, `!`, and `<C-g>n` directly to `custom.tabbuffers` Lua functions.
- **Consolidate terminal autocmds in `lua/plugins/custom/init.lua`**:
  - Unify `TermClose` buffer cleanup with `custom.tabbuffers` so exiting terminals do not trigger duplicate `bdelete!` errors.
- **Add headless test suite `tests/tabbuffers.lua`**:
  - Verify tab-scoped buffer filtering, cross-tab jump, single-buffer window fallback, buffer reordering, MRU back/forward, smart quit across split/tab states, terminal lifecycle, and tab naming.

## Capabilities

### New Capabilities
- `tabbuffers`: Tab-scoped buffer management, cross-tab buffer ownership jump, per-tab MRU history navigation, smart buffer/window quit, terminal buffer integration, and `bufferline.nvim` filtering/sorting/tab-label integration.

### Modified Capabilities

## Impact

- **Codebase**: `/home/hankchiu/code/vim.feat-vim-tabbuffer`
  - New: `lua/custom/tabbuffers.lua`, `tests/tabbuffers.lua`
  - Modified: `lua/plugins/bufferline.lua`, `lua/plugins/custom/init.lua`
- **Dependencies**: Removes `hankchiutw/vim-tabbuffers` plugin dependency from `lazy.nvim`.
