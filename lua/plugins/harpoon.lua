local nmap = require("utils").nmap

return {
  "ThePrimeagen/harpoon", -- Navigate inside projects
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("harpoon").setup({
      menu = {
        width = math.floor(vim.api.nvim_win_get_width(0) * 0.75),
      }
    })
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")
    nmap("<Leader>a", mark.add_file, "Add file to Harpoon list")
    nmap("<C-h>", ui.toggle_quick_menu, "Open Harpoon quick menu")
    nmap("<C-j>", function() ui.nav_file(1) end, "Navigate to harpoon file 1")
    nmap("<C-k>", function() ui.nav_file(2) end, "Navigate to harpoon file 2")
    nmap("<C-l>", function() ui.nav_file(3) end, "Navigate to harpoon file 3")
    nmap("<C-;>", function() ui.nav_file(4) end, "Navigate to harpoon file 4")
    nmap("⁏", function() ui.nav_file(4) end, "Navigate to harpoon file 4")  -- Alacritty hack
  end
}
