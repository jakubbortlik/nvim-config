return {
  "NicolasGB/jj.nvim",
  branch = "main",
  opts = {
    diff = {
      backend = "diffview",
    },
  },
  keys = {
    { "<leader>J", "<cmd>J<cr>", desc = "Run :J<cr>" },
  },
  cmd = {
    "J",
    "Jdiff",
  }
}
