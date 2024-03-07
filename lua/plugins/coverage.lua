local nmap = require("utils").nmap

return {
  "andythigpen/nvim-coverage",
  dependencies = "nvim-lua/plenary.nvim",
  keys = {
    { "<leader>co", "<cmd>Coverage<cr>", desc = "Run [Co]verage" },
  },
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
    local coverage = require("coverage")
    coverage.setup()
    nmap("<leader>cc", coverage.clear, "[c]lear [c]overage signs")
    nmap("<leader>cs", coverage.summary, "Show [c]overage summary")
    nmap("<leader>cn", function()
      coverage.jump_next("uncovered")
    end, "Jump to [n]ext uncovered line")
    nmap("<leader>cN", function()
      coverage.jump_prev("uncovered")
    end, "Jump to [p]revious uncovered line")
  end,
}
