local nmap = require("utils").nmap

return {
  "ThePrimeagen/harpoon", -- Navigate inside projects
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()
    nmap("<leader>a", function()
      harpoon:list():add()
    end, "Add file to Harpoon list")
    nmap("<C-h>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, "Open Harpoon quick menu")
    nmap("<C-j>", function()
      harpoon:list():select(1)
    end, "Navigate to harpoon file 1")
    nmap("<C-k>", function()
      harpoon:list():select(2)
    end, "Navigate to harpoon file 2")
    nmap("<C-l>", function()
      harpoon:list():select(3)
    end, "Navigate to harpoon file 3")
    nmap("<C-;>", function()
      harpoon:list():select(4)
    end, "Navigate to harpoon file 4")
    nmap("⁏", function()
      harpoon:list():select(4)
    end, "Navigate to harpoon file 4")  -- Alacritty hack
    harpoon:extend({
      UI_CREATE = function(cx)
        vim.keymap.set("n", "<C-v>", function()
          harpoon.ui:select_menu_item({ vsplit = true })
        end, { buffer = cx.bufnr })

        vim.keymap.set("n", "<C-x>", function()
          harpoon.ui:select_menu_item({ split = true })
        end, { buffer = cx.bufnr })

        vim.keymap.set("n", "<C-t>", function()
          harpoon.ui:select_menu_item({ tabedit = true })
        end, { buffer = cx.bufnr })
      end,
    })
  end
}
