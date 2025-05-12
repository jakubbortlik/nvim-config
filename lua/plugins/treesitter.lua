return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- PERF: no need to load the plugin, if we only need its opts
          local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
          local opts = require("lazy.core.plugin").values(plugin, "opts", false)
          local enabled = false
          if opts.textobjects then
            for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
              if opts.textobjects[mod] and opts.textobjects[mod].enable then
                enabled = true
                break
              end
            end
          end
          if not enabled then
            require("lazy.core.loader").disable_rtp_plugin(
              "nvim-treesitter-textobjects"
            )
          end
        end,
      },
      "LiadOz/nvim-dap-repl-highlights",
    },
    keys = {
      { "<cr>" },
      { "<bs>", mode = "x" },
    },
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "dap_repl",
        -- "diff",
        "dockerfile",
        "gitcommit",
        "gitignore",
        "git_rebase",
        "go",
        "html",
        "java",
        "javascript",
        "json",
        "latex",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "org",
        "proto",
        "python",
        "r",
        "regex",
        "query",
        "sql",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      sync_install = false,
      highlight = {
        enable = true,
        -- Disable slow treesitter highlight for large files
        disable = function(_, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = { "org" },
      },
      indent = { enable = true, disable = { "python" } },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobjects
          keymaps = {
            ["aa"] = { query = "@parameter.outer", desc = "Select outer parameter region" },
            ["ia"] = { query = "@parameter.inner", desc = "Select inner parameter region" },
            ["af"] = { query = "@function.outer", desc = "Select outer function region" },
            ["if"] = { query = "@function.inner", desc = "Select inner function region" },
            ["ac"] = { query = "@class.outer", desc = "Select outer class region" },
            ["ic"] = { query = "@class.inner", desc = "Select inner class region" },
            ["aP"] = { query = "@parameter.outer", desc = "Select outer parameter region" },
            ["iP"] = { query = "@parameter.inner", desc = "Select inner parameter region" },
            ["aI"] = { query = "@conditional.outer", desc = "Select outer conditional region" },
            ["iI"] = { query = "@conditional.inner", desc = "Select inner conditional region" },
            ["al"] = { query = "@loop.outer", desc = "Select outer loop region" },
            ["il"] = { query = "@loop.inner", desc = "Select inner loop region" },
            ["at"] = { query = "@comment.outer", desc = "Select outer comment region" },
            ["it"] = { query = "@comment.inner", desc = "Select inner comment region" },
          },
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V',  -- linewise
            ['@class.outer'] = 'V',
            ['@loop.outer'] = 'V',
            ['@loop.inner'] = 'V',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          disable = {"help"},
          goto_next = {
            ["]i"] = "@conditional.inner",
          },
          goto_previous = {
            ["[i"] = "@conditional.inner",
          },
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
            ["]o"] = "@loop.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
            ["[o"] = "@loop.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
      },
      incremental_selection = {
        enable = true,
        disable = function()
          local ok, bufname = pcall(vim.fn.expand, "%")
          if ok and bufname == "" or bufname == "[Command Line]" then
            return true
          end
        end,
        keymaps = {
          init_selection = "<cr>", -- set to `false` to disable one of the mappings
          node_incremental = "<cr>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
    config = function(_, opts)
      -- This is required for the dap_repl parser to be installable
      require("nvim-dap-repl-highlights").setup()

      if type(opts.ensure_installed) == "table" then
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
