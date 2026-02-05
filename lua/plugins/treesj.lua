return {
  "Wansmer/treesj",
  keys = {
    { '<leader>jo', "<cmd>TSJJoin<cr>", desc = "treesj [jo]in" },
    { '<leader>js', "<cmd>TSJSplit<cr>", desc = "trees[j] [s]plit" },
  },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    local treesj = require("treesj")
    treesj.setup({
      use_default_keymaps = false,
    })
  end,
}
