return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local refactoring = require("refactoring")
    refactoring.setup()
    vim.keymap.set("x", "<leader>re", ":Refactor extract ")
    vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ")

    vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ")

    vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var")

    vim.keymap.set("n", "<leader>rI", ":Refactor inline_func")

    vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
    vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")

    require("telescope").load_extension("refactoring")

    vim.keymap.set(
      { "n", "x" },
      "<leader>rr",
      function() require('telescope').extensions.refactoring.refactors() end
    )

    -- You can also use below = true here to to change the position of the printf
    -- statement (or set two remaps for either one). This remap must be made in normal mode.
    vim.keymap.set(
      "n",
      "<leader>rp",
      function() require('refactoring').debug.printf({ below = true }) end
    )
    vim.keymap.set(
      "n",
      "<leader>rP",
      function() require('refactoring').debug.printf({ below = false }) end
    )
    vim.keymap.set({ "x", "n" }, "<leader>rv", function()
      refactoring.debug.print_var()
    end)
    vim.keymap.set("n", "<leader>rc", function()
      refactoring.debug.cleanup({})
    end)
  end,
}
