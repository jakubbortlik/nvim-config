vim.keymap.set(
  "n",
  "q",
  function()
    local winid = vim.api.nvim_get_current_win()
    vim.cmd.wincmd("w")
    vim.api.nvim_win_close(winid, true)
  end,
  { desc = "Close the Git blame window", buffer = true }
)
