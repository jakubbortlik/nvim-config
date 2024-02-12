local M = {}

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

M.get_main = get_main
M.nmap = nmap
M.vmap = vmap

return M
