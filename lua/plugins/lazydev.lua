return {
  {
    -- Setup neovim lua configuration
    "folke/lazydev.nvim",
    enabled = function()
      return vim.fn.has("nvim-0.10") == 1
    end,
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "nui.nvim",           words = { "Nui" } }
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
}
