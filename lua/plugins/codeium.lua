local u = require("utils")

local M = {
  "Exafunction/windsurf.vim",
  enabled = u.host_jakub(),
  event = "BufEnter",
  config = function()
    vim.keymap.set("i", "<M-;>", function()
      return vim.fn["codeium#Accept"]()
    end, { expr = true })
    u.nmap("<leader>ct", "<cmd>CodeiumToggle<cr>", "Toggle Codeium")
    vim.g.codeium_no_map_tab = true
    vim.g.codeium_enabled = false
  end,
}

return M
