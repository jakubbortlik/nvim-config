-- Rename with preview and save in post_hook
return {
  "smjonas/inc-rename.nvim",
  keys = {
    {
      "grn",
      function()
        vim.o.inccommand = "split"
        vim.api.nvim_create_autocmd("CmdlineLeave", {
          pattern = "*",
          once = true,
          callback = function()
            vim.defer_fn(function()
              vim.opt.inccommand = "nosplit"
            end, 0)
          end,
        })
        return ":IncRename " .. vim.fn.expand("<cword>")
      end,
      expr = true,
      desc = "[i]ncrementally [r]ename",
    },
  },
  opts = {
    preview_empty_name = true,
    post_hook = function(result)
      if not result.changes then
        vim.cmd("update")
        return
      end
      for file in pairs(result.changes) do
        local bufnr = vim.fn.bufnr(file:sub(8))
        if bufnr ~= -1 then
          vim.api.nvim_buf_call(bufnr, function()
            vim.cmd("update")
          end)
        end
      end
    end,
  },
}
