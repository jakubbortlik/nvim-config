local gitcommit = vim.api.nvim_create_augroup("Gitcommit", {
  clear = true
})

vim.api.nvim_create_autocmd('InsertEnter', {
  group = gitcommit,
  callback = function()
    if vim.fn.line('.') == 1 and vim.fn.col('.') == 1 then
      vim.schedule(function()
        vim.fn.complete(1, {'build', 'chore', 'ci', 'docs', 'feat', 'fix', 'perf', 'refactor', 'revert', 'style', 'test'})
      end)
    end
  end
})
