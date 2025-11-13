return {
  "folke/sidekick.nvim",
  opts = {
    -- add any options here
    nes = { enabled = false },
    cli = {
      mux = {
        backend = "tmux",
        enabled = true,
      },
      win = {
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
        require("sidekick.cli").toggle({ name = "claude", focus = true })
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
