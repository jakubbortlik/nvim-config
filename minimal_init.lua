-- This is a minimal init.lua that is used for debugging
-- DO NOT change the paths and don't remove the colorscheme
local root = vim.fn.fnamemodify("./.repro", ":p")

-- set stdpaths to use .repro
for _, name in ipairs({ "config", "data", "state", "cache" }) do
  vim.env[("XDG_%s_HOME"):format(name:upper())] = root .. "/" .. name
end

-- bootstrap lazy
local lazypath = root .. "/plugins/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath, })
end
vim.opt.runtimepath:prepend(lazypath)

-- install plugins
local plugins = {
}

require("lazy").setup(plugins, {
  root = root .. "/plugins",
})
vim.api.nvim_set_keymap("n", "<leader>l", "<cmd>Lazy<cr>", {desc = "[L]azy"})
