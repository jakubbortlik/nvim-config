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
  ---If `mode` is nil, we're running this function from a mapping
  ---Otherwise we're running this from g@{motion} and `mode` is "line", "char", or
  ---"block"
  if mode == nil then
    vim.o.operatorfunc = "v:lua.require'utils'.operator"
    return "g@" -- call the `operatorfunc`, see :h g@
  end
  if M._operator_callback then
    M._operator_callback()
  end
  return "" -- do nothing, the _operator_callback already did the work
end

---Return a function that can be used as RHS in mappings. The mapping must have
---opts = { expr = true }.
---@param callback function The function to execute
M.make_operator = function(callback)
  return function()
    M._operator_callback = callback
    return M.operator()
  end
end

return M
