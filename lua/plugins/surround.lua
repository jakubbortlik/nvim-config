vim.g.nvim_surround_no_normal_mappings = true

local M = {
  "kylechui/nvim-surround",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
}

vim.keymap.set("i", "<C-g>sa", "<Plug>(nvim-surround-insert)", {
  desc = "Add surrounds around cursor",
})
vim.keymap.set("i", "<C-g>sA", "<Plug>(nvim-surround-insert-line)", {
  desc = "Add surrounds around cursor, on new lines",
})
vim.keymap.set("n", "sa", "<Plug>(nvim-surround-normal)", {
  desc = "Add surrounds around motion",
})
vim.keymap.set("n", "saa", "<Plug>(nvim-surround-normal-cur)", {
  desc = "Add surrounds around current line",
})
vim.keymap.set("n", "sA", "<Plug>(nvim-surround-normal-line)", {
  desc = "Add surrounds around motion, on new lines",
})
vim.keymap.set("n", "sAA", "<Plug>(nvim-surround-normal-cur-line)", {
  desc = "Add surrounds around current line, on new lines",
})
vim.keymap.set("x", "sa", "<Plug>(nvim-surround-visual)", {
  desc = "Add surrounds around visual selection",
})
vim.keymap.set("x", "sA", "<Plug>(nvim-surround-visual-line)", {
  desc = "Add surrounds around visual selection, on new lines",
})
vim.keymap.set("n", "sd", "<Plug>(nvim-surround-delete)", {
  desc = "Delete surrounds",
})
vim.keymap.set("n", "sr", "<Plug>(nvim-surround-change)", {
  desc = "Change surrounds",
})
vim.keymap.set("n", "sR", "<Plug>(nvim-surround-change-line)", {
  desc = "Change surrounds, replacements on new lines",
})

return M
