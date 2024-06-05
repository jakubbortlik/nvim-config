return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- PERF: no need to load the plugin, if we only need its queries for mini.ai
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
          else
            return {
              "csv",
              "tsv",
              "csv_semicolon",
              "csv_whitespace",
              "csv_pipe",
              "rfc_csv",
              "rfc_semicolon",
            }
          end
        end,
        additional_vim_regex_highlighting = { "org" },
      },
      indent = { enable = true, disable = { "python" } },
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
