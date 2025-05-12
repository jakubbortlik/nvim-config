local utils = require("utils")

local M = {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      {
        "mason-org/mason.nvim",
        keys = { { "<leader>ma", "<cmd>Mason<cr>", desc = "Mason" } },
        config = function()
          require("mason").setup({
            ui = { border = utils.border },
          })
        end,
      },
      "mason-org/mason-lspconfig.nvim",
      "SmiteshP/nvim-navic",
      "hrsh7th/cmp-nvim-lsp", -- Add LSP completion capabilities
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim", -- autoinstall non-LSP tools
        dependencies = {
          "mason-org/mason.nvim",
          "mason-org/mason-lspconfig.nvim",
        },
        config = function()
          require("mason-tool-installer").setup({
            ensure_installed = {
              "buf",
              "commitlint",
              "debugpy",
              "json-lsp",
              "luacheck",
              "lua-language-server",
              "mdformat",
              "selene",
              "shellcheck",
              "stylua",
              "textlint",
              "vint",
              "yamllint",
            },
          })
        end,
      },
    },
    config = function()
      local navic = require("nvim-navic")
      -- [[ Configure LSP ]]
      --  This function gets run when an LSP connects to a particular buffer.
      local on_attach = function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
          navic.attach(client, bufnr)
        end
        -- More easily define mappings specific for LSP related items. Set the mode,
        -- buffer and description for us each time.
        local nmap = function(keys, func, desc)
          if desc then
            desc = "LSP: " .. desc
          end
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end
        local imap = function(keys, func, desc)
          if desc then
            desc = "LSP: " .. desc
          end
          vim.keymap.set("i", keys, func, { buffer = bufnr, desc = desc })
        end

        local telescope_builtin = require("telescope.builtin")
        nmap("grf", vim.lsp.buf.format, "vim.lsp.buf.format()")
        nmap("gd", vim.lsp.buf.definition, "vim.lsp.buf.definition()")
        nmap("gD", "<cmd>normal! gd<cr>", "[g]o to local [D]efinition")
        nmap("g<C-d>", telescope_builtin.lsp_definitions, "telescope_builtin.lsp_definitions()")
        nmap("grR", telescope_builtin.lsp_references, "telescope_builtin.lsp_references()")
        nmap("<leader>D", vim.lsp.buf.type_definition, "vim.lsp.buf.type_definition()")
        nmap("<leader>ss", telescope_builtin.lsp_document_symbols, "telescope_builtin.lsp_document_symbols()")
        nmap(
          "<leader>sW",
          telescope_builtin.lsp_dynamic_workspace_symbols,
          "telescope_builtin.lsp_dynamic_workspace_symbols()"
        )
        nmap("K", vim.lsp.buf.hover, "vim.lsp.buf.hover()")
        imap("<C-k>", vim.lsp.buf.signature_help, "vim.lsp.buf.signature_help()")
        nmap("<leader>li", "<cmd>LspInfo<cr>", "Show [L]SP [I]nfo")
        nmap("<leader>lr", "<cmd>LspRestart<cr>", "Restart LSP")
        nmap("<leader>ls", "<cmd>LspStop<cr>", "Stop LSP")
      end

      -- Enable the following language servers. They will automatically be installed.
      local servers = {
        pylsp = {
          plugins = {
            rope_completion = {
              enabled = false
            },
            rope_autoimport = {
              enabled = true
            },
            mypy = {
              enabled = true,
              dmypy = true,
            },
          },
        }, -- run ":PylspInstall <plugin>" to install the following plugins:
        -- pylsp-mypy       -- type checking
        -- pylsp-rope       -- refactoring (import sort)
        -- pyls-memestra    -- deprecation warnings
        -- python-lsp-ruff  -- linting
        -- python-lsp-black -- autoformatting
        lua_ls = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              disable = { "missing-fields" },
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      }

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      -- Ensure the servers above are installed
      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
      })

      mason_lspconfig.setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
          })
        end,
      })
    end,
  },
  -- Non-lsp tools
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local null_ls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(
          ".null-ls-root",
          ".neoconf.json",
          "Makefile",
          ".git"
        ),
        sources = {
          -- linters
          null_ls.builtins.diagnostics.buf,        -- protobuf
          null_ls.builtins.diagnostics.commitlint, -- conventional commits
          null_ls.builtins.diagnostics.selene,     -- lua
          null_ls.builtins.diagnostics.vint,       -- vimscript
          null_ls.builtins.diagnostics.yamllint,   -- YAML
          -- formatters
          null_ls.builtins.formatting.buf,         -- Protobuf formatting
          null_ls.builtins.formatting.mdformat,
          null_ls.builtins.formatting.prettierd,
          null_ls.builtins.formatting.stylua.with({
            extra_args = {
            "--column-width=120 --line-endings=Unix --indent-type=Spaces --indent-width=2 --quote-style=AutoPreferDouble --call-parentheses=Always --collapse-simple-statement=Never"
            },
          }),
          null_ls.builtins.formatting.textlint,    -- Markdown
        },
      }
    end,
  },
}

return M
