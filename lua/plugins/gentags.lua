return {
  "linrongbin16/gentags.nvim",
  cond = vim.fn.executable("ctags") == 1,
  event = "VeryLazy",
  config = true,
}
