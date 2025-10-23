local M = {}

function M.setup()
  --- @diagnostic disable-next-line: missing-fields
  require("nvim-treesitter.configs").setup({
    textobjects = {
      lookahead = true,
      move = {
        enable = true,
        -- set_jumps = true,
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
        goto_next = {
          [">"] = "@block.outer",
        },
        goto_previous = {
          ["<"] = "@block.outer",
        },
      },
      lsp_interop = {
        enable = true,
        border = "rounded",
        floating_preview_opts = {},
        peek_definition_code = {
          ["<C-n>"] = "@function.outer",
          ["<C-m>"] = "@class.outer",
        },
      },
    },
  })
end

return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  config = M.setup,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
}
