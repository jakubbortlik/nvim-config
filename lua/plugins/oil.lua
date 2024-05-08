return {
  'stevearc/oil.nvim',
  opts = {
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
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-x>"] = "actions.select_split",
      ["<C-s>"] = false,
      ["<C-h>"] = false,
      ["<C-d>"] = "actions.preview_scroll_down",
      ["<C-u>"] = "actions.preview_scroll_up",
      ["."] = ": <Home>",
    },
  },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function(_, opts)
    require("oil").setup(opts)
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end

}
