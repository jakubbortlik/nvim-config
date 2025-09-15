local nmap = require("utils").nmap

nmap("q", function()
  local winid = vim.api.nvim_get_current_win()
  vim.cmd.wincmd("w")
  vim.api.nvim_win_close(winid, true)
end, "Close the klame window", true )
