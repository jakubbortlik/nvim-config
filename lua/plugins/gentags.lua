return {
  "JMarkin/gentags.lua",
  cond = vim.fn.executable("ctags") == 1,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("gentags").setup({})
  end,
  event = "VeryLazy",
}
