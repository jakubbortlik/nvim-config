vim.keymap.set("t", "<M-r>", function()
  local buf_name = vim.api.nvim_buf_get_name(0)
  local ft
  if string.match(buf_name, "lua$") then
    ft = "lua"
  elseif string.match(buf_name, "python$") then
    ft = "python"
  elseif string.match(buf_name, "node$") then
    ft = "javascript"
  elseif string.match(buf_name, "sh$") then
    ft = "sh"
  end
  local iron_window_id = vim.api.nvim_get_current_win()

  local window_id = require("state").iron_windows[ft]
  if window_id and vim.api.nvim_win_is_valid(window_id) then
    vim.api.nvim_set_current_win(window_id)
  end

  local _, err = pcall(vim.api.nvim_win_close, iron_window_id, true)
  if err then
    vim.notify(err)
  end
end)
