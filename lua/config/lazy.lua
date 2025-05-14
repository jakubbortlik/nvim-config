-- Bootstrap https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Set variables (like mapleader), options, install plugins, set keymaps, and define autocommands
require("variables")
require("options")
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  install = { colorscheme = { "kanagawa" } },
  ui = {
    browser = "firefox",
    border = "rounded",
  },
  change_detection = { enabled = true, notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "matchparen",
        "netrwPlugin",
        "tohtml",
        "tutor",
      },
    },
  },
})
require("keymaps")
require("autocommands")
