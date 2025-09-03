-- Rename with preview and save in post_hook
return {
  "smjonas/inc-rename.nvim",
  keys = {
    {
      "grn",
      function()
        vim.o.inccommand = "split"
        vim.cmd("au InsertLeave * ++once set inccommand=nosplit")
        return ":IncRename " .. vim.fn.expand("<cword>")
      end,
      expr = true,
      desc = "[i]ncrementally [r]ename",
    },
  },
  opts = {
    post_hook = function(result)
      for file in pairs(result.changes) do
        local bufnr = vim.fn.bufnr(file:sub(8))
        if bufnr ~= -1 then
          vim.api.nvim_buf_call(bufnr, function()
            vim.cmd("write")
          end)
        end
      end
    end,
  },
}
