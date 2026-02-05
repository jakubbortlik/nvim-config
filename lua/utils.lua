local M = {}

-- Return "main" or "master" for a git repository
M.get_main = function()
  local branch = vim.fn.system("git branch | sed 's/\\* //' | rg '^(main|master)$'")
  return branch
end

-- Simplify normal mode mappings
M.nmap = function(keys, func, desc, buffer)
  vim.keymap.set("n", keys, func, { desc = desc, buffer = buffer })
end

-- Simplify visual mode mappings
M.vmap = function(keys, func, desc, buffer)
  vim.keymap.set("v", keys, func, { desc = desc, buffer = buffer })
end

-- Simplify insert mode mappings
M.imap = function(keys, func, desc, buffer)
  vim.keymap.set("i", keys, func, { desc = desc, buffer = buffer })
end

---Return true if system host name contains the string "jakub", false otherwise.
---@return boolean
M.host_jakub = function()
  return vim.fn.system("hostname"):find("jakub") and true or false
end

-- Return "uv" or "poetry" depending on the project
M.get_python_tool = function()
  if vim.fn.filereadable("poetry.lock") == 1 then
    return "poetry"
  else
    return "uv"
  end
end

M._operator_callback = nil

function M.operator(mode)
  if mode == nil then
    vim.o.operatorfunc = "v:lua.require'utils'.operator"
    return "g@"
  end
  if M._operator_callback then
    M._operator_callback()
  end
  return ""
end

---Set the operatorfunc that will work on the lines defined by the motion that follows
---after the operator mapping, and enter the operator-pending mode.
---@param callback function The function to execute
M.make_operator = function(callback)
  return function()
    M._operator_callback = callback
    return M.operator()
  end
end

return M
