return {
  "GeorgesAlkhouri/nvim-aider",
  cmd = "Aider",
  keys = {
    { "<leader>aa", "<cmd>Aider toggle<cr>", desc = "Toggle Aider" },
    { "<leader>as", "<cmd>Aider send<cr>", desc = "Send to Aider", mode = { "n", "v" } },
    { "<leader>ac", "<cmd>Aider command<cr>", desc = "Aider Commands" },
    { "<leader>ab", "<cmd>Aider buffer<cr>", desc = "Send Buffer" },
    { "<leader>a+", "<cmd>Aider add<cr>", desc = "Add File" },
    { "<leader>a-", "<cmd>Aider drop<cr>", desc = "Drop File" },
    { "<leader>ar", "<cmd>Aider add readonly<cr>", desc = "Add Read-Only" },
    { "<leader>aR", "<cmd>Aider reset<cr>", desc = "Reset Session" },
  },
  dependencies = {
    {
      "folke/snacks.nvim",
      opts = {
        styles = {
          terminal = {
            keys = {
              term_normal = {
                "<c-e>",
                function()
                  vim.cmd("stopinsert")
                  return "<esc>"
                end,
                mode = "t",
                expr = true,
                desc = "Force to Normal Mode",
              },
            },
          },
        },
      },
    },
    --- The below dependencies are optional
    "catppuccin/nvim",
    {
      "nvim-neo-tree/neo-tree.nvim",
      opts = function(_, opts)
        require("nvim_aider.neo_tree").setup(opts)
      end,
    },
  },
  opts = {
    args = { "--vim" },
  },
}
