-- Git related plugins
local get_main = require("utils").get_main

local M = {
  {
    "tpope/vim-fugitive",
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Run [G]it"},
      { "<leader>gS", "<cmd>vertical Git<cr>", desc = "Run [G]it in a vertical split"},
    },
    cmd = {
      "G",
      "GDelete",
      "GMove",
      "GRemove",
      "GRename",
      "Gcd",
      "Ggrep",
      "Git",
      "Glcd",
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
    "sindrets/diffview.nvim", -- a single tabpage interface for reviewing all git changes
    keys = {
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
