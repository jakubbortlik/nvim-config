return {
  "augustocdias/gatekeeper.nvim",
  config = function()
    require('gatekeeper').setup({
      exclude = {
        vim.fn.expand('~/.config/nvim'),
        vim.fn.expand('~/dotfiles')
      }
    })
  end
}
