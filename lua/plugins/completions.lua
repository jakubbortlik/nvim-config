local M = {
  "hrsh7th/nvim-cmp",
  event = {
    "InsertEnter",
    "CmdlineEnter",
  },
  dependencies = {
    "hrsh7th/cmp-buffer",                    -- nvim-cmp source for buffer words
    {
      "petertriho/cmp-git",                  -- nvim-cmp source for git
      dependencies = "nvim-lua/plenary.nvim",
    },
    "hrsh7th/cmp-nvim-lsp",                  -- Add LSP completion capabilities
    "hrsh7th/cmp-nvim-lsp-signature-help",   -- nvim-cmp source for function signatures
    "hrsh7th/cmp-path",                      -- nvim-cmp source for filesystem paths
    "ray-x/cmp-treesitter",                  -- nvim-cmp source for treesitter nodes
    "rcarriga/cmp-dap",                      -- completion in DAP
    "davidsierradz/cmp-conventionalcommits", -- nvim-cmp source for Conventional Commits
    "kristijanhusak/vim-dadbod-completion",

    "lukas-reineke/cmp-under-comparator",    -- better sorting for magic methods
    "onsails/lspkind.nvim",                  -- Add vscode-like pictograms to LSP

    "folke/lazydev.nvim",

    -- Snippet Engine & its associated nvim-cmp source
    { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets", -- A number of user-friendly snippets
  },

  -- largely inspired by:
  -- https://vonheikemen.github.io/devlog/tools/setup-nvim-lspconfig-plus-nvim-cmp/
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
    local cmp = require("cmp")
    local types = require("cmp.types")
    local lspkind = require("lspkind")
    local luasnip = require("luasnip")
    local select_opts = { behaviour = types.cmp.SelectBehavior.Select }

    cmp.setup({
      formatting = {
        format = lspkind.cmp_format({
          symbol_map = {
            Comment = "#",
            Error = "⚠",
            String = '"',
          },
          mode = "text",
          menu = {
            buffer = "[buf]",
            nvim_lsp = "[LSP]",
            luasnip = "[snip]",
            path = "[path]",
            treesitter = "[TS]",
            git = "[git]",
          },
        }),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-j>"] = cmp.mapping.confirm({ select = true }),

        ["<C-f>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<C-b>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<C-l>"] = cmp.mapping(function(fallback)
          if luasnip.choice_active() then
            luasnip.change_choice(1)
          else
            fallback()
          end
        end, { "i" }),

        ["<Tab>"] = cmp.mapping(function(fallback)
          local col = vim.fn.col(".") - 1

          if cmp.visible() then
            cmp.select_next_item(select_opts)
          elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
            fallback()
          else
            cmp.complete()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item(select_opts)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered({
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        }),
        documentation = cmp.config.window.bordered({
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        }),
      },
      sources = {
        { name = "luasnip",                 keyword_length = 2 },
        { name = "nvim_lsp",                keyword_length = 1 },
        { name = "nvim_lsp_signature_help", keyword_length = 1 },
        {
          name = "buffer",
          keyword_length = 3,
          option = {
            keyword_pattern = [[\k\+]],
            get_bufnrs = function()
              local bufs = {}
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                bufs[vim.api.nvim_win_get_buf(win)] = true
              end
              return vim.tbl_keys(bufs)
            end,
          },
        },
        { name = "path" },
        { name = "treesitter" },
        { name = "git" },
        { name = "lazydev", group_index = 0}, -- set group index to 0 to skip loading LuaLS completions
        { name = "conventionalcommits" },
      },
      sorting = {
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          require("cmp-under-comparator").under,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      enabled = function()
        return vim.api.nvim_get_option_value("buftype", {buf=0}) ~= "prompt"
            or require("cmp_dap").is_dap_buffer()
      end,
      experimental = {
        ghost_text = true,
      },
    })
    cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
      sources = {
        { name = "dap" },
        { name = "buffer" },
      },
    })
    cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
      sources = {
        { name = "vim-dadbod-completion" },
        { name = "buffer" },
      },
    })
    local format = require("cmp_git.format")
    local sort = require("cmp_git.sort")
    require("cmp_git").setup({
      filetypes = {"gitcommit", "octo", "markdown" },
      gitlab = {
        hosts = { "gitlab.cloud.phonexia.com" }, -- list of private instances of gitlab
        issues = {
          limit = 100,
          state = "opened", -- opened, closed, all
          sort_by = sort.gitlab.issues,
          format = format.gitlab.issues,
        },
        mentions = {
          limit = 100,
          sort_by = sort.gitlab.mentions,
          format = format.gitlab.mentions,
        },
        merge_requests = {
          limit = 100,
          state = "opened", -- opened, closed, locked, merged
          sort_by = sort.gitlab.merge_requests,
          format = format.gitlab.merge_requests,
        },
      },
    })
  end,
}

return M
