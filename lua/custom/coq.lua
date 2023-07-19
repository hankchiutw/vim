local coq_3p = require("coq_3p")

local M = {}

local function setup_3p()
  coq_3p({
    { src = "nvimlua", short_name = "nLUA", conf_only = false },
    { src = "copilot", short_name = "COP", accept_key = "<c-f>" },
  })
end

local function set_keymap()
  -- use Tab to select the current completion
  vim.cmd("ino <silent><expr> <tab> pumvisible() ? (complete_info().selected == -1 ? '<c-n>' : '<C-y>') : '<tab>'")

  -- make <cr> as normal input when showing completion menu
  vim.cmd("ino <silent><expr> <cr> pumvisible() ? '<c-e><cr>' : '<cr>'")

  -- TODO: map <c-l> to select current completion. Relate to tabbuffers.vim

  vim.cmd("ino <silent><expr> <c-j> pumvisible() ? '<c-n>' : '<c-j>'")
  vim.cmd("ino <silent><expr> <c-k> pumvisible() ? '<c-p>' : '<c-k>'")
end

function M.setup()
  setup_3p()
  set_keymap()
  vim.g.coq_settings = {
    -- auto_start = "shut-up",
    ["keymap.recommended"] = false,
    ["keymap.jump_to_mark"] = "<c-n>",
    ["keymap.bigger_preview"] = "",
    ["keymap.pre_select"] = true,
    ["match.exact_matches"] = 3,
    ["match.fuzzy_cutoff"] = 0.7,
    ["weights.recency"] = 2.0,
    ["weights.edit_distance"] = 2.0,
    ["clients.buffers.match_syms"] = false,
    ["clients.buffers.weight_adjust"] = -1,
    ["clients.lsp.weight_adjust"] = 2,
  }

  -- TODO: use auto_start settings
  vim.cmd("COQnow")
end

return M
