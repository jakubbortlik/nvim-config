return {
  "chrishrb/gx.nvim",
  keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
  cmd = { "Browse" },
  init = function ()
    vim.g.netrw_nogx = 1 -- disable netrw gx
  end,
  dependencies = { "nvim-lua/plenary.nvim" },
  submodules = false, -- not needed, submodules are required only for tests

  opts = {
    handlers = {
      github = false, -- open github issues
      brewfile = false, -- open Homebrew formulaes and casks
      package_json = false, -- open dependencies from package.json
      search = false, -- search the web/selection on the web if nothing else is found
      go = false, -- open pkg.go.dev from an import statement (uses treesitter)
      jira = { -- custom handler to open Jira tickets (these have higher precedence than builtin handlers)
        name = "jira", -- set name of handler
        handle = function(mode, line, _)
          local ticket = require("gx.helper").find(line, mode, "(%u+-%d+)")
          if ticket and #ticket < 20 then
            return vim.fn.expand("$JIRA_DOMAIN") .. "/browse/" .. ticket
          end
        end,
      },
    },
    handler_options = {
      search_engine = "duckduckgo",
    },
  }
}
