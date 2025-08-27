local u = require("utils")

local M = {
  {
    "Exafunction/windsurf.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    keys = { { "<leader>ct", "<cmd>Codeium Toggle<cr>", "Toggle Codeium" } },
    cmd = { "Codeium" },
    enabled = u.host_jakub(),
    config = function()
      require("codeium").setup({
        enable_cmp_source = false,
        virtual_text = {
          enabled = true,
          -- The key to press when hitting the accept keybinding but no completion is showing.
          accept_fallback = nil,
          filetypes = {
            gitcommit = false,
          },
          key_bindings = {
            accept = "<M-;>", -- Accept the current completion.
            accept_word = "<M-w>", -- Accept the next word.
            accept_line = "<M-s>", -- Accept the next line.
            clear = "<M-c>", -- Clear the virtual text.
            next = "<M-]>", -- Cycle to the next completion.
            prev = "<M-[>", -- Cycle to the previous completion.
          },
        },
      })
      local original_notify = require("codeium.notify").info
      require("codeium.notify").info = function() end
      require("codeium").disable()
      require("codeium.notify").info = original_notify
      vim.api.nvim_set_hl(0, "CodeiumSuggestion", { fg = "#cc8080" })
    end,
  },
}
return M
