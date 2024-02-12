return {
  "andythigpen/nvim-coverage",
  dependencies = "nvim-lua/plenary.nvim",
  keys = { { "<leader>co", "<cmd>Coverage<cr>", desc = "Run [Co]verage" } },
  cmd = {
    "Coverage",
    "CoverageClear",
    "CoverageHide",
    "CoverageLoad",
    "CoverageLoadLcov",
    "CoverageShow",
    "CoverageSummary",
    "CoverageToggle",
  },
  config = function()
    require("coverage").setup()
  end,
}
