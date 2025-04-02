local M = {}

local function get_opts()
  local mappings = {
    i = {
      ["<esc>"] = "close", -- disable normal mode
      ["<c-b>"] = "results_scrolling_up",
      ["<c-f>"] = "results_scrolling_down",
      ["<c-j>"] = "move_selection_next",
      ["<c-k>"] = "move_selection_previous",
      ["<c-p>"] = require("telescope.actions.layout").toggle_preview,
      ["<c-n>"] = "cycle_history_next",
      ["<c-h>"] = "cycle_history_prev",
      ["<c-l>"] = "toggle_selection",
    },
  }

  local picker_buffers = {
    theme = "dropdown",
    layout_config = {
      width = {
        padding = 5,
      },
    },
    preview = {
      hide_on_startup = true,
    },
    sort_mru = true,
    mappings = {
      i = {
        ["<c-d>"] = "delete_buffer",
      },
    },
  }

  local picker_git_status = {
    mappings = {
      i = {
        ["<c-l>"] = "git_staging_toggle",
      },
    },
  }

  local picker_custom_bottom = {
    layout_strategy = "vertical",
    layout_config = {
      anchor = "S",
      width = {
        padding = 0,
      },
    },
  }

  return {
    defaults = {
      mappings = mappings,
      layout_strategy = "vertical",
      prompt_prefix = "🔍 ",
      selection_caret = "➤ ",
      dynamic_preview_title = true, -- TODO: show dir_name suffix
      -- always open the file in topleft window
      get_selection_window = function()
        vim.cmd("wincmd t")
        return vim.api.nvim_get_current_win()
      end,
    },
    pickers = {
      buffers = picker_buffers,
      git_status = picker_git_status,
      lsp_references = picker_custom_bottom,
      diagnostics = picker_custom_bottom,
    },
  }
end

function M.setup()
  local telescope = require("telescope")
  telescope.setup(get_opts())
  require("plugins.telescope.keymap").set()
  require("plugins.telescope.style").set()
  telescope.load_extension("fzf")
end

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = M.setup,
}
