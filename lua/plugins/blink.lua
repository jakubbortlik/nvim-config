local gitlab_opts = {
  enable = function()
    local utils = require("blink-cmp-git.utils")
    return utils.get_repo_remote_url():find("gitlab.*%.com")
  end,
  get_token = function()
    return os.getenv("GITLAB_TOKEN")
  end,
}

return {
  "saghen/blink.cmp",
  event = { "VimEnter" },
  version = "1.*",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "folke/lazydev.nvim",
    "Kaiser-Yang/blink-cmp-git",
  },
  --- @module "blink.cmp"
  --- @type blink.cmp.Config
  opts = { --
    keymap = {
      preset = "default",
      ["<C-j>"] = { "accept", "fallback" },
      ["<C-y>"] = false,
      ["<C-;>"] = { "show", "show_documentation", "hide_documentation" },
    },
    completion = {
      keyword = { range = "full" },
      accept = { auto_brackets = { enabled = false } },
      ghost_text = { enabled = true },
      menu = {
        direction_priority = function()
          local ctx = require("blink.cmp").get_context()
          local item = require("blink.cmp").get_selected_item()
          if ctx == nil or item == nil then
            return { "s", "n" }
          end
          local item_text = item.textEdit ~= nil and item.textEdit.newText
            or item.insertText
            or item.label
          local is_multi_line = item_text:find("\n") ~= nil
          if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
            vim.g.blink_cmp_upwards_ctx_id = ctx.id
            return { "n", "s" }
          end
          return { "s", "n" }
        end,
      },
    },
    sources = {
      default = { "git", "lsp", "path", "snippets", "lazydev", "buffer" },
      providers = {
        buffer = { min_keyword_length = 3 },
        lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
        git = {
          module = "blink-cmp-git",
          name = "Git",
          enabled = function()
            return vim.tbl_contains({ "gitcommit", "markdown" }, vim.bo.filetype)
          end,
          opts = {
            git_centers = {
              gitlab = {
                pull_request = gitlab_opts,
                mention = gitlab_opts,
              },
            },
          },
        },
      },
    },
    cmdline = {
      enabled = true,
      keymap = {
        preset = "cmdline",
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "show_and_insert_or_accept_single", "select_next", "fallback" },
        ["<S-Tab>"] = { "show_and_insert_or_accept_single", "select_prev", "fallback" },
        ["<C-j>"] = { "accept" },
        ["<C-;>"] = { "show", "show_documentation", "hide_documentation" },
      },
      completion = {
        -- trigger = { prefetch_on_insert = false },
        list = { selection = { preselect = false } },
        menu = {
          auto_show = function(_)
            return vim.fn.getcmdtype() == ":"
          end,
        },
        ghost_text = { enabled = true },
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    signature = { enabled = true },
  },
}
