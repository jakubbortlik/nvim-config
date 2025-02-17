return {
  "JMarkin/gentags.lua",
  cond = vim.fn.executable("ctags") == 1,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = true,
  event = "VeryLazy",
}
