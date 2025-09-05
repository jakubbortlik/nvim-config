-- Git related plugins
local get_main = require("utils").get_main

local M = {
  {
    "tpope/vim-fugitive",
    keys = {
      { "gb", "<cmd>Git blame<cr>", desc = "Run [G]it [b]lame"},
      { "gB", ":Git blame ", desc = "Populate commandline with [G]it [b]lame"},
      { "gs", "<cmd>Git<cr>", desc = "Run [G]it"},
      { "gS", "<cmd>vertical Git<cr>", desc = "Run [G]it in a vertical split"},
      { "<C-g><C-d>", "<cmd>Gdiffsplit " .. get_main() .. "<cr>", desc = "[G][d]iffsplit with main"},
      { "<C-g><C-v>", "<cmd>Gvdiffsplit " .. get_main() .. "<cr>", desc = "[G][v]diffsplit with main"},
      { "<C-g>d", ":Gdiffsplit ", desc = "Prepopulate commandline with [G][d]iffsplit"},
      { "<C-g>v", ":Gvdiffsplit ", desc = "Prepopulate commandline with [G][v]diffsplit"},
      { "<leader>gb", "<cmd>GBrowse<cr>", desc = "Run GBrowse"},
      { "<leader>gB", "<cmd>GBrowse!<cr>", desc = "Run GBrowse"},
      { "<leader>gb", ":'<,'>GBrowse<cr>", mode = "v", desc = "Run GBrowse"},
      { "<leader>gB", ":'<,'>GBrowse!<cr>", mode = "v", desc = "Run GBrowse"},
      { "<leader>gp", "<cmd>G pull<cr>", desc = "Run G pull"},
    },
    cmd = {
      "G",
      "GBrowse",
      "GDelete",
      "GMove",
      "GRemove",
      "GRename",
      "GUnlink",
      "Gcd",
      "Gclog",
      "Gdiffsplit",
      "Gdiffsplit",
      "Gdrop",
      "Gedit",
      "Ggrep",
      "Ghdiffsplit",
      "Git",
      "Glcd",
      "Glgrep",
      "Gllog",
      "Gpedit",
      "Gread",
      "Gsplit",
      "Gtabedit",
      "Gvdiffsplit",
      "Gvsplit",
      "Gwq",
      "Gwrite",
    },
  },
  {
    "shumphrey/fugitive-gitlab.vim",
    dependencies = {
      "tpope/vim-fugitive",
    },
    config = function()
      vim.g.fugitive_gitlab_domains = { "https://gitlab.cloud.phonexia.com" }
      vim.cmd([[let g:gitlab_api_keys = {"gitlab.cloud.phonexia.com": expand("$GITLAB_TOKEN")}]])
    end
  },
  {
    "tpope/vim-rhubarb",
    dependencies = {
      "tpope/vim-fugitive",
    },
  },
  {
    "sindrets/diffview.nvim", -- a single tabpage interface for reviewing all git changes
    keys = {
      { "<leader>vc", "<cmd>DiffviewClose<cr>", desc = "Run Diff[v]iew[C]lose"},
      { "<leader>vH", ":DiffviewFileHistory --no-merges", desc = "Prepopulate commandline with Diff[v]iewFile[H]istory"},
      { "<leader>vh", "<cmd>DiffviewFileHistory --no-merges %<cr>", desc = "Run Diff[v]iewFile[H]istory for current file"},
      { "<leader>vo", "<cmd>DiffviewFileHistory --range=origin..HEAD<cr>", desc = "Run Diff[v]iewFile[H]istory for origin..HEAD"},
      { "<leader>vm", "<cmd>DiffviewOpen --no-merges " .. get_main() .. "<cr>", desc = "Run Diff[v]iew[O]pen"},
      { "<leader>vr", "<cmd>DiffviewRefresh<cr>", desc = "Run Diff[v]iew[R]efresh"},
    },
    cmd = {
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewFocusFiles",
      "DiffviewLog",
      "DiffviewOpen",
      "DiffviewRefresh",
      "DiffviewToggleFiles",
    },
  },
}

return M
