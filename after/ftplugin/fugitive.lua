vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true, desc = "Close the Git summary window" })
pcall(vim.keymap.del, {"n", "<P"})
pcall(vim.keymap.del, {"n", "<p"})
pcall(vim.keymap.del, {"n", ">p"})
pcall(vim.keymap.del, {"n", "<s"})
pcall(vim.keymap.del, {"n", "<s<ESC>"})
