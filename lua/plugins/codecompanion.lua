local M = {
  "olimorris/codecompanion.nvim",
  keys = { { "<leader>cc", "<cmd>CodeCompanionChat<cr>" } },
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionCmd",
    "CodeCompanionActions",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- The following are optional:
    { "MeanderingProgrammer/render-markdown.nvim", ft = { "codecompanion" } },
    "ravitemer/codecompanion-history.nvim", -- history extension
  },
  opts = {
    extensions = {
      history = {
        enabled = true, -- defaults to true
        opts = {
          picker = "snacks",
          picker_keymaps = {
            delete = { n = "d", i = "<M-u>" },
          },
          continue_last_chat = true,
          auto_generate_title = false,
        },
      },
    },
    adapters = {
      acp = {
        claude_code = function()
          return require("codecompanion.adapters").extend("claude_code", {
            env = {
              CLAUDE_CODE_OAUTH_TOKEN = "CLAUDE_CODE_OAUTH_TOKEN_NVIM",
            },
          })
        end,
      },
      http = {
        llama3 = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "llama3", -- Give this adapter a different name to differentiate it from the default ollama adapter
            schema = {
              model = {
                default = "llama3.2:latest",
              },
              num_ctx = {
                default = 16384,
              },
              num_predict = {
                default = -1,
              },
            },
          })
        end,
        qwen25coder = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "qwen25coder", -- Give this adapter a different name to differentiate it from the default ollama adapter
            schema = {
              model = {
                default = "qwen2.5-coder:14b",
              },
            },
          })
        end,
      },
    },

    opts = {
      -- Set debug logging
      log_level = "DEBUG",
    },

    strategies = {
      chat = {
        adapter = "claude_code",
      },
      inline = {
        adapter = "claude_code",
      },
      cmd = {
        adapter = "claude_code",
      },
    },
  },
}

return M
