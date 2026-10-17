## Purpose

Provides tab-scoped buffer isolation, cross-tab buffer ownership jumping, per-tab MRU navigation, buffer reordering, smart window-preserving buffer quit, terminal buffer management, and tab naming integrated with `bufferline.nvim`.

## ADDED Requirements

### Requirement: Tab-scoped buffer association and cross-tab jump
The system SHALL associate each listed buffer (`buflisted` is true) with the tabpage in which it is first read or opened as a terminal. The tabline SHALL display only buffers associated with the currently active tabpage. When a buffer already associated with another valid tabpage is entered in a different tabpage, the system SHALL revert the current window to its previous buffer and switch focus to the tabpage that owns the target buffer. When a buffer is deleted, the system SHALL remove it from its owning tabpage's buffer list.

#### Scenario: Buffer opened in a tabpage is scoped to that tabpage
- **WHEN** buffer A is opened in tabpage 1 and buffer B is opened in tabpage 2
- **THEN** tabpage 1's buffer list contains buffer A (and not buffer B), and tabpage 2's buffer list contains buffer B (and not buffer A)

#### Scenario: Entering a buffer owned by another tabpage jumps to the owning tabpage
- **WHEN** buffer A is owned by tabpage 1 and the user opens or switches to buffer A while in tabpage 2
- **THEN** tabpage 2's window reverts to its previous buffer and the active tabpage switches to tabpage 1

#### Scenario: Unlisted and quickfix buffers are excluded from tab buffer lists
- **WHEN** a buffer with `filetype=qf` or `buflisted=false` is opened
- **THEN** the system sets `nobuflisted` on `qf` buffers and does not add unlisted buffers to the tabpage's buffer list

### Requirement: Tab buffer cycling and split window fallback
The system SHALL provide directional switching (`offset = 1` for right/next, `offset = -1` for left/previous) when the current buffer is listed. When the current tabpage has more than one buffer in its tab buffer list, switching SHALL cycle to the next or previous buffer in that tabpage's ordered buffer list (wrapping around at the ends). When the current tabpage has at most one buffer in its tab buffer list, switching SHALL navigate across split windows in the current tabpage (`<C-w>l` or `<C-w>t` at the last window for `+1`; `<C-w>h` or `<C-w>b` at the first window for `-1`).

#### Scenario: Cycle through buffers when tab has multiple buffers
- **WHEN** the current tabpage has buffers `[A, B, C]` with `C` active and the user triggers switch right (`+1`)
- **THEN** the active buffer in the current window becomes `A`

#### Scenario: Fallback to split window navigation when tab has a single buffer
- **WHEN** the current tabpage has only buffer `[A]` displayed across 2 split windows and the user triggers switch right (`+1`) from window 1
- **THEN** cursor focus moves to window 2

### Requirement: Tab buffer reordering
The system SHALL allow moving the active buffer left (`-1`) or right (`+1`) within the current tabpage's ordered buffer list, wrapping around to the opposite end when moving past the first or last position, and refreshing the tabline display.

#### Scenario: Move first buffer left wraps to the end
- **WHEN** the current tabpage has buffers `[A, B, C]` with `A` active and the user triggers move left (`-1`)
- **THEN** the tabpage buffer order becomes `[B, C, A]`

#### Scenario: Move last buffer right wraps to the beginning
- **WHEN** the current tabpage has buffers `[A, B, C]` with `C` active and the user triggers move right (`+1`)
- **THEN** the tabpage buffer order becomes `[C, A, B]`

### Requirement: Per-tab MRU buffer history navigation
The system SHALL maintain a per-tabpage Most Recently Used (MRU) navigation history list of up to 20 listed, named buffers (`bufname` is non-empty). Entering a buffer via normal navigation SHALL truncate any forward history beyond the current MRU cursor and append the buffer to the MRU list (avoiding duplicate consecutive entries). Navigating backward (`mru_back`) SHALL move the MRU cursor one step earlier and switch to that buffer; navigating forward (`mru_forward`) SHALL move the MRU cursor one step later and switch to that buffer. Deleting a buffer SHALL remove all occurrences of that buffer from the MRU list, deduplicate adjacent identical entries, and reset the MRU cursor to the end of the list.

#### Scenario: Navigate backward and forward in MRU history
- **WHEN** the user visits named buffers `A`, `B`, `C` in sequence within a tabpage, triggers `mru_back`, and then triggers `mru_forward`
- **THEN** `mru_back` switches to buffer `B`, and `mru_forward` switches back to buffer `C`

#### Scenario: Visiting a new buffer after MRU back truncates forward history
- **WHEN** the MRU history is `[A, B, C]` with cursor at `B` (after `mru_back`) and the user opens buffer `D`
- **THEN** the MRU history becomes `[A, B, D]` with cursor at `D`

#### Scenario: Deleted buffer is purged and adjacent duplicates are collapsed
- **WHEN** the MRU history is `[A, B, A]` and buffer `B` is deleted
- **THEN** the MRU history collapses to `[A]` with cursor at index 1

### Requirement: Smart quit behavior
The system SHALL provide a unified quit action (`q`) that adapts to the current buffer and window state:
1. If `buftype == "terminal"`, it SHALL force-delete the terminal buffer (`bdelete!`).
2. If `buftype` is non-empty (and not `"terminal"`), it SHALL quit the current window (`q!`).
3. Otherwise, it SHALL close any location list for the window (`lclose`) and:
   - If the current tabpage has more than 1 buffer in its tab buffer list, it SHALL delete the current buffer while preserving the current window split by switching the window to the most recent remaining MRU buffer (or the first remaining tab buffer if MRU is empty).
   - Else if the current tabpage has only 1 window (`winnr('$') == 1`), it SHALL quit (`q!`).
   - Else if the current buffer has an empty name (`No Name`), it SHALL close the tabpage (`tabclose`) when multiple tabpages exist, or quit all (`qa!`) when only one tabpage exists.
   - Else (multiple windows in tabpage, only 1 named buffer in tab buffer list), it SHALL replace the current buffer with a new empty buffer (`enew`) and delete the previous buffer (`bdelete! #`).

#### Scenario: Quitting one of multiple tab buffers preserves window split
- **WHEN** a tabpage has 2 split windows and tab buffers `[A, B]` with `B` active in window 1
- **THEN** triggering quit deletes buffer `B`, switches window 1 to buffer `A`, and keeps both split windows open

#### Scenario: Quitting the only named buffer in a multi-window tabpage replaces with empty buffer
- **WHEN** a tabpage has 2 split windows and only 1 named buffer `[A]`
- **THEN** triggering quit deletes buffer `A`, leaves an unnamed buffer in the window, and keeps both split windows open

### Requirement: Terminal buffer lifecycle management
The system SHALL mark window 1 of each tabpage on `TabNew` and `VimEnter` as the main tabbuffers window (`w:has_tabbuffers = 1`). When a terminal opens (`TermOpen`), the system SHALL add the terminal buffer to the current tabpage's buffer list, and if opened in a window with `w:has_tabbuffers`, set `filetype=tabbuffers-terminal`, map `<Esc>` in terminal mode (`t`) to `<C-\><C-n>`, and configure `TermEnter` to enforce cross-tab buffer ownership jump and `TermClose` to remove the buffer from the tab buffer list and delete the closed terminal buffer without conflict.

#### Scenario: Terminal opened in main window gets tabbuffers-terminal settings
- **WHEN** a terminal buffer is opened in window 1 of a tabpage
- **THEN** the buffer is added to the tabpage's buffer list, its `filetype` is set to `tabbuffers-terminal`, and `<Esc>` in terminal mode maps to `<C-\><C-n>`

### Requirement: Tab naming and status display
The system SHALL allow the user to rename the current tabpage via `<C-g>n` (defaulting to `T<tabpagenr>` when unset) and render the tab label along with the shortened current working directory and tab position (`<cwd> <tabnr>/<total_tabs>`) in the tabline.

#### Scenario: Default and custom tab name rendering
- **WHEN** tabpage 1 has no custom name set and the user renames it to `work` via the tab rename prompt
- **THEN** the tab label updates from `T1 »` to `work »` Alongside `<cwd> 1/<total_tabs>` in the tabline
