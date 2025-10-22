local M = {}

function M.setup()
  require("nvim-treesitter.configs").setup({
    -- A list of parser names, or "all"
    -- Note: need to manually install "angular"
    ensure_installed = {
      "vim",
      "lua",
      "javascript",
      "typescript",
      "tsx",
      "vue",
      "python",
      "json",
      "html",
      "css",
      "scss",
      "markdown",
      "markdown_inline",
      "astro",
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    auto_install = true,
    ignore_install = {},
    modules = {},

    highlight = {
      -- `false` will disable the whole extension
      enable = true,
      disable = {
        -- redundant since we have rainbow-delimiters
        "html",
      },

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<Space>",
        node_incremental = "<Space>",
        scope_incremental = "gh",
        node_decremental = "gb",
      },
    },
    matchup = {
      enable = true,
    },
  })
end

return {
  "nvim-treesitter/nvim-treesitter",
  config = M.setup,
}
