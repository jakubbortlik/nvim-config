local linediff = function()
  local start_line, end_line = vim.fn.line( "'["), vim.fn.line("']")
  vim.cmd(start_line .. "," .. end_line .. "Linediff")
end

---Set the operatorfunc that will work on the lines defined by the motion that follows after the
---operator mapping, and enter the operator-pending mode.
---@param mode string? Nil when operator() is run directly (not triggered as operatorfunc from g@)
local operator = function(mode)
  if mode == nil then
    vim.o.operatorfunc = "v:lua.require'plugins.linediff'.operator"
    return "g@"
  end
  linediff()
  return ""
end

local M = {
  "vim-scripts/linediff.vim",
  keys = {
    { "<leader>l", ":'<,'>Linediff<cr>", desc = "[l]inediff", mode = "x" },
    { "<leader>lx", "<cmd>LinediffReset<cr>", desc = "[L]inediffReset" },
    { "<leader>l", operator, desc = "[l]inediff with motion", mode = "n", expr = true },
  },
}

M.operator = operator

return M
