-- Define leader before plugins are required otherwise wrong leader will be used
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Get correct python3_host_prog on different machines
-- TODO: make sure that pynvim is installed
local conda_prefix = string.gsub(vim.fn.expand("$CONDA_PREFIX"), "/envs/.*", "")
vim.g.python3_host_prog = conda_prefix .. "/envs/neovim/bin/python3"
