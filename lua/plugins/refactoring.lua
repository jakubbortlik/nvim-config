return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local refactoring = require("refactoring")
    refactoring.setup({})
    vim.keymap.set("x", "<leader>re", ":Refactor extract ")
    vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ")

    vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ")

    vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var")

    vim.keymap.set("n", "<leader>rI", ":Refactor inline_func")

    vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
    vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")

    vim.keymap.set({ "x", "n" }, "<leader>rp", function()
      refactoring.debug.print_var({ below = true })
    end, { desc = "Print var below" })
    vim.keymap.set({ "x", "n" }, "<leader>rP", function()
      refactoring.debug.print_var({ below = false })
    end, { desc = "Print var above" })
    vim.keymap.set("n", "<leader>rc", function()
      refactoring.debug.cleanup({})
    end, { desc = "Remove Refactoring debugprints" })
  end,
}
