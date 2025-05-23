local u = require("utils")

-- Navigation in a popup window using LSP
return {
  "hasansujon786/nvim-navbuddy",
  dependencies = {
    "neovim/nvim-lspconfig",
    "SmiteshP/nvim-navic",
    "MunifTanjim/nui.nvim",
    "folke/snacks.nvim",
  },
  keys = { { "<leader>nb", "<cmd>Navbuddy<cr>", desc = "Navbuddy" } },
  cmd = "NavBuddy",
  opts = { lsp = { auto_attach = true }, window = { border = u.border } },
}
