return {
  "milanglacier/minuet-ai.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
  },
  cmd = { "Minuet" },
  event = { "InsertEnter" },
  opts = {
    provider = "claude",
    context_window = 1000,
    virtualtext = {
      auto_trigger_ft = {},
      keymap = {
        accept = "<M-;>", -- accept whole completion
        accept_line = "<M-a>", -- accept one line
        accept_n_lines = "<M-z>", -- e.g. "<M-z>2<CR>" accept 2 lines
        prev = "<M-[>", -- Cycle back or invoke completion
        next = "<M-]>", -- Cycle forward or invoke completion
        dismiss = "<M-e>",
      },
    },
    provider_options = {
      claude = {
        api_key = function()
          return os.getenv("ANTHROPIC_API_KEY_NVIM")
        end,
      },
    },
  },
}
