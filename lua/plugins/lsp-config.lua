local M = {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      {
        "williamboman/mason.nvim",
        keys = { { "<leader>ma", "<cmd>Mason<cr>", desc = "Mason" } },
        config = function()
          require("mason").setup({
            ui = { border = "rounded" },
          })
        end,
      },
      "williamboman/mason-lspconfig.nvim",
      {
        "folke/neodev.nvim",
        opts = { library = { plugins = { "nvim-dap-ui", "neotest" }, types = true }, },
      },
      "hrsh7th/cmp-nvim-lsp", -- Add LSP completion capabilities
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim", -- autoinstall non-LSP tools
        dependencies = {
          "williamboman/mason.nvim",
          "williamboman/mason-lspconfig.nvim",
        },
        config = function()
          require("mason-tool-installer").setup({
            ensure_installed = {
              "black",
              "buf",
              "commitlint",
              "debugpy",
              "json-lsp",
              "luacheck",
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

        nmap("<leader>rn", vim.lsp.buf.rename, "[r]e[n]ame")
        nmap("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction")
        nmap("<leader>cf", vim.lsp.buf.format, "[c]ode action: [f]ormat current buffer")

        nmap("gd", vim.lsp.buf.definition, "[g]oto [d]efinition")
        nmap("gD", "<cmd>tab split | lua vim.lsp.buf.definition()<cr>", "[g]o to [D]efinition in new tab")
        nmap("g<C-d>", telescope_builtin.lsp_definitions, "[g]oto [d]efinitions with telescope")
        nmap("gr", telescope_builtin.lsp_references, "[g]oto [r]eferences")
        nmap("gR", vim.lsp.buf.references, "Show [R]eferences in quickfix")
        nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
        nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")

        nmap("<leader>ss", telescope_builtin.lsp_document_symbols, "[s]earch document [s]ymbols")
        nmap(
          "<leader>sW",
          telescope_builtin.lsp_dynamic_workspace_symbols,
          "[s]earch [W]orkspace symbols"
        )

        nmap("K", vim.lsp.buf.hover, "Hover Documentation")
        imap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

        -- Less used LSP functionality
        nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
        nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
        nmap("<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "[W]orkspace [L]ist Folders")
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

      -- Setup neovim lua configuration
      require("neodev").setup()

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

      -- Put nice borders around lsp-related floating windows
      local _border = "rounded"
      require('lspconfig.ui.windows').default_options = { border = _border }
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, { border = _border }
      )
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, { border = _border }
      )
      vim.diagnostic.config({ float = { border = _border } })
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
  -- Navigation in a popup window using LSP
  {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
      "numToStr/Comment.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = { { "<leader>nb", "<cmd>Navbuddy<cr>", desc = "Navbuddy" } },
    cmd = "NavBuddy",
    opts = { lsp = { auto_attach = true }, window = { border = "rounded" } },
  },
}

return M
