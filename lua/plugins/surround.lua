local M = {
  "kylechui/nvim-surround",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  opts = {
    keymaps = {
        insert = "<C-g>sa",
        insert_line = "<C-g>sA",
        normal = "sa",
        normal_cur = "saa",
        normal_line = "sA",
        normal_cur_line = "sAA",
        visual = "sa",
        visual_line = "sA",
        delete = "sd",
        change = "sr",
        change_line = "sR",
    },
  }
}
return M
