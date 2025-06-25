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
    "folke/snacks.nvim",
  },
  keys = {
    {"g?d"},
    {"g?v"},
    {"g?V"},
    {"g?p"},
    {"g?P"},
    {"g?o"},
    {"g?O"},
    {"g?sv"},
    {"g?sp"},
    {"<leader>s<c-d>", "<cmd>Debugprint search<cr>", mode = {"n"}},
  },
}
