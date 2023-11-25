return {
  "glacambre/firenvim",
  -- Lazy load firenvim
  -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
  lazy = not vim.g.started_by_firenvim,
  build = function()
    vim.fn["firenvim#install"](0)
  end,
  config = function()
    if vim.g.started_by_firenvim == true then
      vim.o.laststatus = 0
      vim.o.textwidth = 0
      vim.o.number = false
      vim.o.relativenumber = false
      vim.o.guifont = "JetBrainsMono Nerd Font:h11"
    else
      vim.o.laststatus = 2
    end
  end
}
