-- A basic REPL that opens up as a horizontal split
return {
  "Vigemus/iron.nvim",
  keys = {
    {
      "<M-r>",
      function()
        local ft = vim.bo.filetype
        if ft == "lua" or ft == "python" or ft == "sh" then
          vim.cmd.IronFocus()
          vim.cmd.startinsert()
        else
          vim.notify("Can't open REPL with filetype: `" .. ft .. "`", vim.log.levels.WARN)
        end
      end,
      desc = "󱠤 Toggle REPL",
    },
    { "+", mode = { "n", "x" }, desc = "󱠤 Send-to-REPL Operator" },
    { "++", desc = "󱠤 Send Line to REPL" },
    {
      "<leader>rw",
      function()
        vim.cmd.IronWatch("file")
      end,
      desc = "󱠤 REPL watch file",
    },
    {
      "<leader>ru",
      function()
        require("iron.core").unwatch(0)
      end,
      desc = "󱠤 REPL unwatch file",
    },
  },
  -- irons's setup call is `require("iron.core").setup`
  main = "iron.core",
  opts = {
    keymaps = {
      send_line = "++",
      visual_send = "+",
      send_motion = "+",
      mark_visual = "<leader>m",
      cr = "<leader><cr>",
      interrupt = "<leader>ii",
      exit = "<leader>rq",
      clear = "<leader>rl",
    },
    config = {
      repl_open_cmd = "horizontal bot 15 split",
      -- Define which binary to use for the REPL.
      repl_definition = {
        python = {
          command = function()
            local ipythonAvailable = vim.fn.executable("ipython") == 1
            local binary = ipythonAvailable and "ipython" or "python3"
            return { binary }
          end,
        },
      },
    },
  },
}
