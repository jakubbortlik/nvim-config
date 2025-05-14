local u = require("utils")

local server_settings = {
  pylsp = {
    plugins = {
      rope_completion = {
        enabled = false,
      },
      rope_autoimport = {
        enabled = true,
      },
      mypy = {
        enabled = true,
        dmypy = true,
      },
    },
  },
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
  ts_ls = {},
  buf_ls = {},
  jsonls = {},
  protols = {},
}

local on_attach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end
end

local M = {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "SmiteshP/nvim-navic",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
      for server_name, settings in pairs(server_settings) do
        vim.lsp.config(server_name, {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = settings,
        })
      end
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
    },
    opts = {
      automatic_enable = true,
    },
  },
  {
    "mason-org/mason.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    init = function(_)
      local pylsp = require("mason-registry").get_package("python-lsp-server")
      pylsp:on("install:success", function()
        local function mason_package_path(package)
          return vim.fn.resolve(vim.fn.stdpath("data") .. "/mason/packages/" .. package)
        end

        local path = mason_package_path("python-lsp-server")
        local command = path .. "/venv/bin/pip"
        local args = {
          "install",
          "-U",
          "pyls-memestra",
          "pylsp-mypy",
          "pylsp-rope",
          "python-lsp-black",
          "python-lsp-ruff",
        }

        require("plenary.job")
          :new({
            command = command,
            args = args,
            cwd = path,
            on_exit = function(_, status)
              vim.defer_fn(function()
                if status ~= 0 then
                  vim.print(string.format("installation of pylsp plugins exited with non-zero code: %s", status), vim.log.levels.ERROR)
                else
                  vim.print("pylsp plugins were installed successfully")
                end
              end, 0)
            end,
          })
          :start()
      end)
    end,
    keys = { { "<leader>ma", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ui = { border = u.border },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
    },
    opts = {
      ensure_installed = {
        "buf",
        "commitlint",
        "debugpy",
        "json-lsp",
        "jq",
        "lua_ls",
        "luacheck",
        "mdformat",
        "prettierd",
        "protols",
        "pylsp",
        "selene",
        "shellcheck",
        "stylua",
        "textlint",
        "typescript-language-server",
        "vint",
        "yamllint",
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    opts = function()
      local null_ls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        on_attach = on_attach,
        sources = {
          -- linters
          null_ls.builtins.diagnostics.buf, -- protobuf
          null_ls.builtins.diagnostics.commitlint, -- conventional commits
          null_ls.builtins.diagnostics.selene, -- lua
          null_ls.builtins.diagnostics.vint, -- vimscript
          null_ls.builtins.diagnostics.yamllint, -- YAML
          -- formatters
          null_ls.builtins.formatting.buf, -- Protobuf formatting
          null_ls.builtins.formatting.mdformat,
          null_ls.builtins.formatting.prettierd.with({ filetypes = { "javascript", "typescript", "markdown" } }),
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.textlint, -- Markdown
        },
      }
    end,
  },
}

return M
