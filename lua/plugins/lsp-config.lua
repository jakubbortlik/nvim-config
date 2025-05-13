local u = require("utils")

local M = {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      {
        "mason-org/mason.nvim",
        version = "1.11.0",
        keys = { { "<leader>ma", "<cmd>Mason<cr>", desc = "Mason" } },
        config = function()
          require("mason").setup({
            ui = { border = u.border },
          })
        end,
      },
      {"mason-org/mason-lspconfig.nvim", version = "1.32.0" },
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
              "lua-language-server",
              "luacheck",
              "mdformat",
              "protols",
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
      --  This function gets run when an LSP connects to a particular buffer.
      local on_attach = function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
          navic.attach(client, bufnr)
        end
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
}

return M
