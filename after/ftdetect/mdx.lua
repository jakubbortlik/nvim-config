local mdx_id = vim.api.nvim_create_augroup("mdx", {
  clear = false
})
vim.api.nvim_create_autocmd("BufEnter", {
  group = mdx_id,
  pattern = "*.mdx",
  callback = function()
    vim.o.filetype = "markdown"
  end
})
