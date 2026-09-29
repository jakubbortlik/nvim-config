return {
  "Kicamon/markdown-table-mode.nvim",
  cmd = { "Mtm" },
  keys = {{"<leader>mm", "<cmd>Mtm<cr>", desc = "Toggle markdown-table-mode"}},
  opts = {
    filetype = {
      "*.md",
      "*.mdx",
    },
    options = {
      insert = true,             -- when typeing "|"
      insert_leave = true,       -- when leaveing insert
      pad_separator_line = true, -- add space in separator line
      alig_style = "default",    -- default, left, center, right
    },
  }
}
