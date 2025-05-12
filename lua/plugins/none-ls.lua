local M = {
  "nvimtools/none-ls.nvim",
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
        null_ls.builtins.diagnostics.buf,          -- protobuf
        null_ls.builtins.diagnostics.commitlint,   -- conventional commits
        null_ls.builtins.diagnostics.selene,       -- lua
        null_ls.builtins.diagnostics.vint,         -- vimscript
        null_ls.builtins.diagnostics.yamllint,     -- YAML
        -- formatters
        null_ls.builtins.formatting.buf,           -- Protobuf formatting
        null_ls.builtins.formatting.mdformat,
        null_ls.builtins.formatting.prettierd.with({ filetypes = { "javascript", "typescript", "markdown" } }),
        null_ls.builtins.formatting.stylua.with({
          extra_args = table.concat({
            "--column-width=120",
            "--line-endings=Unix",
            "--indent-type=Spaces",
            "--indent-width=2",
            "--quote-style=AutoPreferDouble",
            "--call-parentheses=Always",
            "--collapse-simple-statement=Never"
          }, " "),
        }),
        null_ls.builtins.formatting.textlint,   -- Markdown
      },
    }
  end,
}

return M
