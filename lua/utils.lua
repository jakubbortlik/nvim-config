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

---Return the path to the Python executable within the `VIRTUAL_ENV`, default to system
---Python.
M.python_path = function()
  -- TODO: find out if it's possible to get the VIRTUAL_ENV activated in the DAP REPL.
  -- Debugpy supports launching an application with a different interpreter then
  -- the one used to launch debugpy itself.
  local vdir = os.getenv("VIRTUAL_ENV")
  if vdir then
    return vdir .. "/bin/python"
  else
    return "/usr/bin/python3"
  end
end

---Return true if system host name contains the string "jakub", false otherwise.
---@return boolean 
M.host_jakub = function()
  return vim.fn.system("hostname"):find("jakub") and true or false
end

return M
