lua << EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "vim", "lua", "javascript", "typescript", "vue", "python", "json", "html", "css", "scss" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

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
  autotag = {
    enable = true,
  },
  rainbow = {
    enable = true,
  },
  matchup = {
    enable = true,
  },
}
EOF
