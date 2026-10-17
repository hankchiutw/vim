local M = {}

function M.setup()
  local treesitter = require("nvim-treesitter")
  treesitter.setup({ install_dir = vim.fn.stdpath("data") .. "/site" })
  treesitter.install({
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
  })

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
    callback = function(event)
      -- HTML highlighting is handled by rainbow-delimiters.
      if vim.bo[event.buf].filetype == "html" then
        return
      end
      local lang = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
      if lang and vim.treesitter.language.add(lang) then
        vim.treesitter.start(event.buf, lang)
      end
    end,
  })
end

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = M.setup,
}
