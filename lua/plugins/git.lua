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
      vim.g.fugitive_gitlab_domains = { "https://gitlab.phonexia.com" }
      vim.cmd([[let g:gitlab_api_keys = {"gitlab.phonexia.com": expand("$GITLAB_TOKEN")}]])
    end
  },
  {
    "dlyongemallo/diffview.nvim",
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
    opts = {
      persist_selections = {
        enabled = true,
      },
      signs = {
        selected_file = "✅",
        unselected_file = "⬜",
        selected_dir = "✅",
        partially_selected_dir = "🔳",
        unselected_dir = "⬜",
      },
      file_panel = {
        win_config = {
          width = 55,
        },
      },
      hooks = {
        diff_buf_win_enter = function(_, winid, _)
          vim.wo[winid].foldlevel = 0
          vim.wo[winid].number = true
        end,
      },
      keymaps = {
        file_history_panel = {
          { "n", "K", function() require("diffview.actions").select_prev_commit() end, { desc = "Select previous commit" } },
          { "n", "J", function() require("diffview.actions").select_next_commit() end, { desc = "Select next commit" } },
        },
        file_panel = {
          { { "n", "x" }, "m", function() require("diffview.actions").toggle_select_entry() end, { desc = "Toggle file selection" } },
          { { "n", "x" }, "<space>", false },
        },
      }
    }
  },
}

return M
