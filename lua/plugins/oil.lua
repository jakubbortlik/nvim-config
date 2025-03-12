return {
  'stevearc/oil.nvim',
  opts = {
    float = {
      max_width = 80,
    },
    columns = {
      "permissions",
      "size",
      "mtime",
      "icon",
    },
    win_options = {
      relativenumber = false,
    },
    constrain_cursor = "name",
    keymaps = {
      ["<C-t>"] =  '<cmd>lua require("oil").select({close=true, tab=true})<cr>',
      ["<C-v>"] =  '<cmd>lua require("oil").select({close=true, vertical=true})<cr>',
      ["<C-x>"] =  '<cmd>lua require("oil").select({close=true, horizontal=true})<cr>',
      ["<C-s>"] = false,
      ["<C-h>"] = false,
      ["<C-d>"] = "actions.preview_scroll_down",
      ["<C-u>"] = "actions.preview_scroll_up",
      ["<C-.>"] = ": <Home>",
    },
  },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function(_, opts)
    require("oil").setup(opts)
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    vim.keymap.set("n", "<leader>-", "<CMD>lua require('oil').open_float()<CR>", { desc = "Open parent directory in floating window" })
  end
}
