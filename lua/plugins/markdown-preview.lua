local u = require("utils")

return {
  "iamcco/markdown-preview.nvim",
  keys = {
    { "<leader>M", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle MarkdownPreview" }
  },
  enabled = u.host_jakub(),
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && yarn install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_browser = "firefox"
  end,
  ft = { "markdown" },
}
