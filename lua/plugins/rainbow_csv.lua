local nmap = require("utils").nmap

local M = {
  "cameron-wags/rainbow_csv.nvim",
  ft = {
    "csv",
    "tsv",
    "csv_semicolon",
    "csv_whitespace",
    "csv_pipe",
    "rfc_csv",
    "rfc_semicolon",
  },
  cmd = {
    "RainbowDelim",
    "RainbowDelimSimple",
    "RainbowDelimQuoted",
    "RainbowMultiDelim",
  },
  config = function()
    require("rainbow_csv").setup()
    nmap("<leader>rd", "<cmd>RainbowDelim<cr>", "Setup [R]ainbow[D]elim")
  end,
}

return M
