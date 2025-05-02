return {
  "zongben/navimark.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  opts = {
    keymap = {
      base = {
        mark_toggle = "mm",
        mark_add = "",
        mark_remove = "",
        goto_next_mark = "mn",
        goto_prev_mark = "mN",
        open_mark_picker = "mf",
      },
    },
    persist = true,
    stack_mode = "auto",
  },
}
