local nmap = require("utils").nmap

return {
  "zakinomiya/nvim-dictionary",
  dependencies = { "vim-denops/denops.vim" },
  cmd = { "NDSearch", "NDCleanCache" },
  keys = { "<leader>di" },
  config = function()
    nmap("<leader>di", "<Plug>(nvim-dictionary) <cword>", "Find definition for word under cursor")
  end
}
