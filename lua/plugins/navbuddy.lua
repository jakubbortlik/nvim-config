-- Navigation in a popup window using LSP
local lsp_opts = { auto_attach = true, preference = { "pylsp" } }
return {
  "hasansujon786/nvim-navbuddy",
  dependencies = {
    "neovim/nvim-lspconfig",
    { "SmiteshP/nvim-navic", opts = { lsp = lsp_opts } },
    "MunifTanjim/nui.nvim",
    "folke/snacks.nvim",
  },
  keys = { { "<leader>nb", "<cmd>Navbuddy<cr>", desc = "Navbuddy" } },
  cmd = "NavBuddy",
  opts = {
    lsp = lsp_opts,
    window = { border = vim.o.winborder },
  },
}
