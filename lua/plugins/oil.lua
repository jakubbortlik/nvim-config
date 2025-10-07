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
      ["<C-d>"] =  '<cmd>lua require("oil").select({close=true}, function() vim.cmd("edit # | vertical diffsplit #") end)<cr>',
      ["<C-s>"] = false,
      ["<C-h>"] = false,
      ["<C-f>"] = "actions.preview_scroll_down",
      ["<C-b>"] = "actions.preview_scroll_up",
      ["<C-.>"] = ": <Home>",
      ["H"] = { "actions.toggle_hidden", mode = "n" },
    },
  },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function(_, opts)
    require("oil").setup(opts)
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end
}
