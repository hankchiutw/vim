local function set_keymap()
  local flag = { silent = true, noremap = true }
  vim.keymap.set("n", "<leader>e", ":Neotree<cr>", flag)
  vim.keymap.set("v", "<leader>e", ":Neotree<cr>", flag)
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  lazy = false, -- neo-tree will lazily load itself
  init = function()
    set_keymap()
  end,
  ---@module "neo-tree"
  ---@type neotree.Config?
  opts = {
    window = {
      position = "right",
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",
        ["<space>"] = "focus_preview",
      },
    },
  },
}
