local nmap = require("utils").nmap
return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {"]t", desc = "Next [t]odo comment"},
    {"[t", desc = "Previous [t]odo comment"},
  },
  opts = {
    highlight = {
      -- TODO (ABC-195):
      -- INFO CDE-195:
      -- NOTE EFG-195 - 
      pattern = [[.*<(KEYWORDS)\s*(:|\(?<[A-Z]+-\d+\)?)]]
    },
    search = {
      pattern = [[\b(KEYWORDS)\s*(:|\(?\b[A-Z]+-\d+\)?)]],
    },
  },
  config = function(_, opts)
    local todo = require("todo-comments")
    todo.setup(opts)
    nmap("]t", todo.jump_next, "Next [t]odo comment")
    nmap("[t", todo.jump_prev, "Previous [t]odo comment")
  end,
}
