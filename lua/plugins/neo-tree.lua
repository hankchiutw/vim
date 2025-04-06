local function set_keymap()
  local flag = { silent = true, noremap = true }
  vim.keymap.set("n", "<leader>e", ":Neotree reveal<cr>", flag)
  vim.keymap.set("v", "<leader>e", ":Neotree reveal<cr>", flag)
end

local function set_autostart()
  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("NeoTreeAutoOpen", { clear = true }),
    callback = function()
      require("neo-tree.command").execute({
        action = "show",
        source = "filesystem",
      })
    end,
  })
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
    set_autostart()
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
        ["<c-h>"] = function(state)
          vim.cmd("wincmd h")
        end,
      },
    },
  },
}
