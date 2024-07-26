local nmap = require("utils").nmap

return {
  "andrewferrier/debugprint.nvim",
  opts = {},
  dependencies = {
      "nvim-treesitter/nvim-treesitter" -- Needed to enable treesitter for NeoVim 0.8
  },
  keys = {
    {"g?d"},
    {"g?v"},
    {"g?V"},
    {"g?p"},
    {"g?P"},
    {"g?o"},
    {"g?O"},
  },
  config = function(_, opts)
    local debugprint = require("debugprint")
    debugprint.setup({opts})
    nmap("g?d", debugprint.deleteprints, "Delete all debug lines in buffer")
  end
}
