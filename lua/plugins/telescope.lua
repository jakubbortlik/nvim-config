local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function focus_preview(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local prompt_win = picker.prompt_win
  local previewer = picker.previewer
  local bufnr = previewer.state.bufnr or previewer.state.termopen_bufnr
  local winid = previewer.state.winid or vim.fn.win_findbuf(bufnr)[1]
  vim.keymap.set("n", "<tab>", function()
    vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", prompt_win))
  end, { buffer = bufnr })
  vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", winid))
end

local M = {
  -- Fuzzy Finder (files, lsp, etc)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nyarthan/telescope-code-actions.nvim",
      'nvim-telescope/telescope-ui-select.nvim',
      "xiyaowong/telescope-emoji.nvim",
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          dynamic_preview_title = true,
          mappings = {
            n = {
              ["<Tab>"] = focus_preview,
            },
          },
        },
        pickers = {
          live_grep = {
            mappings = {
              i = { ["<c-;>"] = actions.to_fuzzy_refine },
            },
          },
          lsp_references = {
            show_line = false,
          },
          buffers = {
            show_all_buffers = true,
            sort_lastused = true,
            mappings = {
              i = {
                ["<c-k><c-o>"] = "delete_buffer",
                ["<c-s>"] = function()
                  local selection = actions.state.get_selected_entry()
                  vim.api.nvim_buf_call(selection.bufnr, function()
                    vim.cmd.update()
                  end)
                end,
              }
            }
          }
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({})
          },
        },
      })
      pcall(telescope.load_extension, "fzf")          -- Enable telescope fzf native, if installed
      pcall(telescope.load_extension, "code_actions") -- Enable telescope code actions, if installed
      pcall(telescope.load_extension, "ui-select")    -- Enable telescope for UI selection if installed
      pcall(telescope.load_extension, "emoji")
      local builtin = require("telescope.builtin")

      local keymap = function(keys, func, desc, mode)
        mode = mode ~= nil and mode or "n"
        if desc then
          desc = "Telescope: " .. desc
        end
        vim.keymap.set(mode, keys, func, { desc = desc })
      end

      keymap("<leader>te", ":Telescope ", "Fill the commnd line with :Telescope")
      keymap("<leader>?", builtin.oldfiles, "[?] Find recently opened files")
      keymap("<leader><space>", builtin.buffers, "[ ] Find existing buffers")
      keymap("<leader>/", function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, "[/] Fuzzily search in current buffer")

      keymap("<leader>sd", builtin.diagnostics, "[s]earch [d]iagnostics")
      keymap("<leader>sf", builtin.find_files, "[s]earch [f]iles")
      keymap("<leader>sF", builtin.git_files, "[s]earch [F]iles relative to Git repo")
      keymap("<leader>sg", builtin.live_grep, "[s]earch by [g]rep")
      keymap("<leader>sG", function()
        builtin.live_grep({ cwd = "../../" })
      end, "[s]earch by [G]rep relative to Git repo")
      keymap("<leader>sh", builtin.help_tags, "[s]earch [h]elp")
      keymap("<leader>sr", builtin.resume, "[s]earch - [r]esume")
      keymap("<leader>sw", builtin.grep_string, "[s]earch current [w]ord", {"n", "v"})
      keymap("<leader>sz",
        function()
          builtin.grep_string({
            shorten_path = true,
            word_match = "-w",
            only_sort_text = true,
            search =
            ''
          })
        end, "[s]earch by grep fu[z]zily")
    end,
  },

}

return M
