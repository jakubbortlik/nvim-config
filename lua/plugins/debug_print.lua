return {
  "andrewferrier/debugprint.nvim",
  opts = {
    keymaps = {
      normal = {
        delete_debug_prints = "g?d",
      }
    }
  },
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
}
