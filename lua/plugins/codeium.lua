local nmap = require("utils").nmap

M = {
  "Exafunction/codeium.vim",
  event = "BufEnter",
  config = function()
    vim.keymap.set("i", "<M-p>", function()
      return vim.fn["codeium#Accept"]()
    end, { expr = true })
    nmap("<leader>ct", "<cmd>CodeiumToggle<cr>", "Toggle Codeium")
    vim.g.codeium_no_map_tab = true
    vim.g.codeium_enabled = false
  end,
}

return M
