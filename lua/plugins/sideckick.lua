return {
  "folke/sidekick.nvim",
  opts = {
    nes = { enabled = false },
    cli = {
      mux = {
        enabled = true,
      },
      win = {
        split = {
          width = 90,
        },
        keys = {
          prompt = { "<c-k><c-p>", "prompt", mode = "t", desc = "insert prompt or context" },
        },
      },
    },
  },
  keys = {
    {
      "<c-.>",
      function()
        local new_layout = vim.v.count1 == 1 and "right" or "bottom"
        require("sidekick.config").cli.win.layout = new_layout
        require("sidekick.cli.state").with(function(state, attached)
          if state.terminal then
            state.terminal.opts.layout = new_layout
            if attached then
              state.terminal:show()
              state.terminal:focus()
            elseif state.terminal:is_open() then
              state.terminal:hide()
              state.terminal:show()
              state.terminal:focus()
            else
              state.terminal:toggle()
              if state.terminal:is_open() then
                state.terminal:focus()
              end
            end
          end
        end, {
          attach = true,
          filter = { name = "claude" },
        })
      end,
      desc = "Sidekick Toggle Claude",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>ks",
      function()
        require("sidekick.cli").select({ filter = { installed = true } })
      end,
      desc = "Select CLI",
    },
    {
      "<leader>kt",
      function()
        require("sidekick.cli").send({ msg = "{this}", name = "claude", focus = true })
      end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>kf",
      function()
        require("sidekick.cli").send({ msg = "{file}", name = "claude", focus = true })
      end,
      desc = "Send File",
    },
    {
      "<leader>kv",
      function()
        require("sidekick.cli").send({ msg = "{selection}", name = "claude", focus = true })
      end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>kp",
      function()
        require("sidekick.cli").prompt({ name = "claude", focus = true })
      end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
  },
}
