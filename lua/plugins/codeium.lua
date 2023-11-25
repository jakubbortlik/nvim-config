M = {
  "Exafunction/codeium.vim",
  event = 'BufEnter',
  config = function()
    vim.keymap.set("i", "<M-p>", function()
      return vim.fn["codeium#Accept"]()
    end, { expr = true })
    vim.keymap.set("n", "<leader>ct", "<cmd>CodeiumToggle<cr>", { desc = "Toggle Codeium" })
    vim.g.codeium_no_map_tab = true
    vim.g.codeium_enabled = false
  end,
}

return M
