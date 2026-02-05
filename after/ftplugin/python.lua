local textwidth = vim.bo.textwidth > 0 and vim.bo.textwidth or 88
vim.keymap.set(
  "n",
  "<leader>f88",
  [[vib:s/\v(^\s+)"(.*)"$/\1\2/<CR>0vib:!fmt -w ]] .. textwidth - 3 .. [[<CR>vib:s/\v(^\s+)(.*)/\1"\2 "<CR>$X:update<cr>]],
  { desc = string.format("Format parenthesized string to %d chars", textwidth)}
)
