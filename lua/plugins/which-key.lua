local M = {
  {
    "folke/which-key.nvim", -- Show pending keybinds
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    opts = {
      delay = function(ctx)
        return ctx.plugin and 0 or 300
      end,
      win = {
        border = vim.o.winborder,
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.add(
        { "gl", group = "Gitlab" }
      )

    end
  },
}

return M
