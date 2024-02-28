-- This is a minimal init.lua that is used for debugging
local root = vim.fn.stdpath("run") .. "/nvim/mininit"
vim.fn.mkdir(root, "p")

-- set stdpaths to use .repro
for _, name in ipairs({ "config", "data", "state", "cache" }) do
  vim.env[("XDG_%s_HOME"):format(name:upper())] = root .. "/" .. name
end

-- bootstrap lazy
local lazypath = root .. "/plugins/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "~/.local/share/nvim/lazy/lazy.nvim",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

-- install plugins
local plugins = {
}

require("lazy").setup(plugins, {
  root = root .. "/plugins",
})
vim.api.nvim_set_keymap("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "[L]azy" })
