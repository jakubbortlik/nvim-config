vim.keymap.set({ "n", "x" }, "<leader>re", function()
  return require("refactoring").extract_func()
end, { desc = "Extract Function", expr = true })
vim.keymap.set("n", "<leader>ree", function()
  return require("refactoring").extract_func() .. "_"
end, { desc = "Extract Function (line)", expr = true })

vim.keymap.set({ "n", "x" }, "<leader>rv", function()
  return require("refactoring").extract_var()
end, { desc = "Extract Variable", expr = true })
vim.keymap.set("n", "<leader>rvv", function()
  return require("refactoring").extract_var() .. "_"
end, { desc = "Extract Variable (line)", expr = true })

vim.keymap.set({ "n", "x" }, "<leader>ri", function()
  return require("refactoring").inline_var()
end, { desc = "Inline Variable", expr = true })
vim.keymap.set({ "n", "x" }, "<leader>rI", function()
  return require("refactoring").inline_func()
end, { desc = "Inline function", expr = true })

vim.keymap.set({ "n", "x" }, "<leader>rs", function()
  return require("refactoring").select_refactor()
end, { desc = "Select refactor" })

vim.keymap.set({ "x", "n" }, "<leader>pv", function()
  return require("refactoring.debug").print_var { output_location = "below" } .. "iw"
end, { desc = "Debug print var below", expr = true })

vim.keymap.set({ "x", "n" }, "<leader>pV", function()
  return require("refactoring.debug").print_var { output_location = "above" } .. "iw"
end, { desc = "Debug print var above", expr = true })

vim.keymap.set({ "x", "n" }, "<leader>pe", function()
  return require("refactoring.debug").print_exp { output_location = "below" }
end, { desc = "Debug print exp below", expr = true })
vim.keymap.set("n", "<leader>pee", function()
  return require("refactoring.debug").print_exp { output_location = "below" } .. "_"
end, { desc = "Debug print exp below", expr = true })

vim.keymap.set({ "x", "n" }, "<leader>pE", function()
  return require("refactoring.debug").print_exp { output_location = "above" }
end, { desc = "Debug print exp above", expr = true })
vim.keymap.set("n", "<leader>pEE", function()
  return require("refactoring.debug").print_exp { output_location = "above" } .. "_"
end, { desc = "Debug print exp above", expr = true })

vim.keymap.set("n", "<leader>pP", function()
  return require("refactoring.debug").print_loc { output_location = "above" }
end, { desc = "Debug print location", expr = true })
vim.keymap.set("n", "<leader>pp", function()
  return require("refactoring.debug").print_loc { output_location = "below" }
end, { desc = "Debug print location", expr = true })

vim.keymap.set({ "x", "n" }, "<leader>pc", function()
  return require("refactoring.debug").cleanup { restore_view = true } .. "gG"
end, { desc = "Debug print clean", expr = true, remap = true })

return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "lewis6991/async.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  lazy = false,
  config = true
}
