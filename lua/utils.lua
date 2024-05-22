-- Return "main" or "master" for a git repository
local function get_main()
  local branch = vim.fn.system("git branch | sed 's/\\* //' | rg '^(main|master)$'")
  return branch
end

-- Simplify normal mode mappings
local nmap = function(keys, func, desc, buffer)
  vim.keymap.set("n", keys, func, { desc = desc, buffer = buffer })
end

-- Simplify visual mode mappings
local vmap = function(keys, func, desc, buffer)
  vim.keymap.set("v", keys, func, { desc = desc, buffer = buffer })
end

---Return the path to the Python executable within the `VIRTUAL_ENV`, default to system
---Python.
local python_path = function()
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
local host_jakub = function()
  return vim.fn.system("hostname"):find("jakub") and true or false
end

local M = {
  host_jakub = host_jakub,
  get_main = get_main,
  nmap = nmap,
  vmap = vmap,
  python_path = python_path,
}
return M
