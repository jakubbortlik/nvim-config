vim.keymap.set(
  "n",
  "<leader>f88",
  [[vib:s/\v(^\s+)"(.*)"$/\1\2/<CR>vib:!fmt -w 85<CR>vib:s/\v(^\s+)(.*)/\1"\2 "<CR>$X:up<CR>]],
  { desc = "Format parenthesized string to 88 chars"}
)
