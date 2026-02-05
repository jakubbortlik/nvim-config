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
    {"g?v", mode = {"n", "x"}},
    {"g?V", mode = {"n", "x"}},
    {"g?p"},
    {"g?P"},
    {"g?o"},
    {"g?O"},
    {"g?sv", mode = {"n", "x"}},
    {"g?sp", mode = {"n", "x"}},
    {"<leader>s<c-d>", "<cmd>Debugprint search<cr>", mode = {"n"}},
    {"gA",function()
      print('DEBUGPRINT[424]: debugprint.lua:24 (after gA,function())')
      vim.fn.search("DEBUGPRINT")
      vim.cmd.normal("ddk%p==")
    end, mode = {"n"}, desc = "Move debugprint after multiline statement"},
  },
}
