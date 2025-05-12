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
        keys = { { "<leader>ma", "<cmd>Mason<cr>", desc = "Mason" } },
        config = function()
          require("mason").setup({
            ui = { border = u.border },
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
      --  This function gets run when an LSP connects to a particular buffer.
      local on_attach = function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
          navic.attach(client, bufnr)
        end
        local telescope_builtin = require("telescope.builtin")
        u.nmap("grf", vim.lsp.buf.format, "vim.lsp.buf.format()", bufnr)
        u.nmap("gd", vim.lsp.buf.definition, "vim.lsp.buf.definition()", bufnr)
        u.nmap("gD", "<cmd>normal! gd<cr>", "[g]o to local [D]efinition", bufnr)
        u.nmap("g<C-d>", telescope_builtin.lsp_definitions, "telescope_builtin.lsp_definitions()", bufnr)
        u.nmap("grR", telescope_builtin.lsp_references, "telescope_builtin.lsp_references()", bufnr)
        u.nmap("<leader>D", vim.lsp.buf.type_definition, "vim.lsp.buf.type_definition()", bufnr)
        u.nmap("<leader>ss", telescope_builtin.lsp_document_symbols, "telescope_builtin.lsp_document_symbols()", bufnr)
        u.nmap(
          "<leader>sW",
          telescope_builtin.lsp_dynamic_workspace_symbols,
          "telescope_builtin.lsp_dynamic_workspace_symbols()",
          bufnr
        )
        u.nmap("K", vim.lsp.buf.hover, "vim.lsp.buf.hover()", bufnr)
        u.imap("<C-k>", vim.lsp.buf.signature_help, "vim.lsp.buf.signature_help()", bufnr)
        u.nmap("<leader>li", "<cmd>LspInfo<cr>", "Show [L]SP [I]nfo", bufnr)
        u.nmap("<leader>lr", "<cmd>LspRestart<cr>", "Restart LSP", bufnr)
        u.nmap("<leader>ls", "<cmd>LspStop<cr>", "Stop LSP", bufnr)
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
