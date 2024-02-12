-- Defined leader before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- get right python3_host_prog on different machines
local conda_prefix = string.gsub(vim.fn.expand("$CONDA_PREFIX"), "/envs/.*", "")
vim.g.python3_host_prog = conda_prefix .. "/envs/neovim/bin/python3"

-- Install package manager:
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Specify setup options for lazy.nvim
local opts = {
  ui = {
    browser = "firefox",
    border = "rounded",
  },
  change_detection = { enabled = true, notify = false, },
  performance = {
    rtp = {
      disabled_plugins = {
        "matchparen",
        "tohtml",
        "tutor",
      },
    },
  },
}

-- Set options, install plugins, and define autocommands:
require("options")
require("lazy").setup("plugins", opts)
require("autocommands")
