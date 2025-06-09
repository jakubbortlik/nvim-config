-- Use the DAP and Neotest plugins to debug code
-- Primarily focused on configuring the debugger for Python

local nmap = require("utils").nmap
local vmap = require("utils").vmap

local M = {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<F5>" },
      { "<F7>" },
      { "<F8>" },
      { "<leader>bb" },
      { "<leader>bc" },
      { "<leader>bC" },
    },
    dependencies = {
      "nvim-neotest/nvim-nio",
      -- Creates a beautiful debugger UI
      "rcarriga/nvim-dap-ui",
      "LiadOz/nvim-dap-repl-highlights",

      -- Show variable values as virtual text
      {"theHamsta/nvim-dap-virtual-text", config = true},
      -- Work with breakpoints
      {
        "Weissle/persistent-breakpoints.nvim",
        config = function()
          require("persistent-breakpoints").setup({ load_breakpoints_event = { "BufReadPost" } })
        end,
      },
      "ofirgall/goto-breakpoints.nvim",
      -- Add debuggers:
      "mfussenegger/nvim-dap-python",
      "leoluz/nvim-dap-go",
      "jbyuki/one-small-step-for-vimkind",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dap.configurations.lua = {
        {
          type = 'nlua',
          request = 'attach',
          name = "Attach to running Neovim instance",
        }
      }
      dap.adapters.nlua = function(callback, config)
        callback({
          type = 'server',
          host = config.host or "127.0.0.1",
          port = config.port or 8086,
        })
      end

      require("nvim-dap-virtual-text").setup({})

      local keymap = vim.keymap.set

      -- Basic debugging keymaps, feel free to change to your liking!
      keymap("n", "<F1>", function()
        dap.step_into()
        vim.cmd.normal("zz")
      end, { desc = "Dap step into" })
      keymap("n", "<F2>", function()
        dap.step_over()
        vim.cmd.normal("zz")
      end, { desc = "Dap step over" })
      keymap("n", "<F3>", function()
        dap.step_out()
        vim.cmd.normal("zz")
      end, { desc = "Dap step out" })
      keymap("n", "<F4>", dap.step_back, { desc = "Dap step out" })
      keymap("n", "<F5>", function()
        dap.continue()
        vim.cmd.normal("zz")
      end, { desc = "Dap continue" })
      keymap("n", "<F6>", dap.terminate, { desc = "Dap terminate" })
      -- Toggle to see last session result to see session output in case of unhandled exception
      keymap("n", "<F7>", function()
        dapui.toggle({ reset = true })
      end, { desc = "Dapui toggle" })

      keymap('n', '<F8>', [[:lua require("osv").launch({port = 8086})<CR>]], { desc = "Launch OSV server in debugee", noremap = true })

      local opts = { noremap = true, silent = true }
      local pbapi = require("persistent-breakpoints.api")
      -- Save breakpoints to file automatically.
      keymap(
        "n",
        "<leader>bb",
        pbapi.toggle_breakpoint,
        { unpack(opts), desc = "Dap toggle [b]reakpoint" }
      )
      keymap(
        "n",
        "<leader>bc",
        pbapi.set_conditional_breakpoint,
        { unpack(opts), desc = "Dap set [b]reakpoint [c]onditional" }
      )
      keymap(
        "n",
        "<leader>bC",
        pbapi.clear_all_breakpoints,
        { unpack(opts), desc = "Dap [b]reakpoints - [C]lear all" }
      )

      keymap("n", "]k", require("goto-breakpoints").next, { desc = "Go to next brea[k]point" })
      keymap("n", "[k", require("goto-breakpoints").prev, { desc = "Go to previous brea[k]point" })
      keymap("n", "]K", require("goto-breakpoints").stopped, { desc = "Go to brea[K]point at the current stopped line" })
      keymap("n", "[K", require("goto-breakpoints").stopped, { desc = "Go to brea[K]point at the current stopped line" })

      local widgets = require("dap.ui.widgets")

      keymap({ "n", "v" }, "<leader>dh", function()
        widgets.hover()
      end, { desc = "[D]ap widgets [H]over" })
      keymap({ "n", "v" }, "<leader>dp", function()
        widgets.preview()
      end, { desc = "[D]ap widgets [P]review" })
      keymap("n", "<leader>df", function()
        widgets.centered_float(widgets.frames)
      end, { desc = "[D]ap float widget [F]rames" })
      keymap("n", "<leader>dv", function()
        widgets.centered_float(widgets.scopes)
      end, { desc = "[D]ap float widget [V]ariable scopes" })

      -- Python specific config
      local dap_python = require("dap-python")
      dap_python.setup(vim.g.python3_host_prog)
      nmap("<leader>dm", dap_python.test_method, "Run test [m]ethod above cursor")
      nmap("<leader>dc", dap_python.test_class, "Run test [c]lass above cursor")
      vmap("<leader>ds", dap_python.debug_selection, "Debug selected code")

      -- Dap UI setup
      dapui.setup({
        -- Icons for trees
        icons = { current_frame = "*" },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.5 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              -- { id = "watches", size = 0.25 }
            },
            position = "left",
            size = 40
          },
          {
            elements = {
              { id = "repl", size = 0.90 }
            },
            position = "bottom",
            size = 10
          }
        },
      })

      -- Navigate between dapui elements
      -- TODO: Get rid of the repeating `win_gotoid` and `require` calls
      keymap({ "n", "i" }, "<C-q>b", "<cmd>call win_gotoid(win_getid(bufwinnr('DAP Breakpoints')))<cr>", { desc = "[G]o to [B]reakpoints" })
      keymap({ "n", "i" }, "<C-q>v", "<cmd>call win_gotoid(win_getid(bufwinnr('DAP Scopes')))<cr>", { desc = "[G]o to [V]ariable scopes" })
      keymap({ "n", "i" }, "<C-q>w", "<cmd>call win_gotoid(win_getid(bufwinnr('DAP Watches')))<cr>", { desc = "[G]o to [W]atches" })
      keymap({ "n", "i" }, "<C-q>r", "<cmd>call win_gotoid(win_getid(bufwinnr('\\[dap-repl\\]')))<cr>", { desc = "[G]o to [R]EPL" })
      keymap({ "n", "i" }, "<C-q>s", "<cmd>call win_gotoid(win_getid(bufwinnr('DAP Stacks')))<cr>", { desc = "[G]o to [S]tacks" })

      -- Debugger autocommands
      local id_dap = vim.api.nvim_create_augroup("DAP", {
        clear = false
      })
      vim.api.nvim_create_autocmd("WinEnter", {
        group = id_dap,
        pattern = "\\[dap-repl\\]",
        callback = vim.schedule_wrap(function(args)
          vim.api.nvim_set_current_win(vim.fn.bufwinid(args.buf))
        end)
      })

      vim.api.nvim_create_autocmd({ "WinEnter" }, {
        group = id_dap,
        pattern = "dap-\\(frames\\|float\\|hover\\|preview\\|scopes\\)*",
        callback = function()
          vim.keymap.set("n", "q", "<cmd>quit<cr>", { desc = "Quit this window", buffer = true })
        end
      })

      -- In the elements, use mappings similar to PUDB
      vim.api.nvim_create_autocmd("WinEnter", {
        group = id_dap,
        pattern = "\\(DAP \\(Scopes\\|Breakpoints\\|Stacks\\|Watches\\)\\|\\[dap-repl\\]\\)",
        callback = function()
          local dap_nmap = function(keys, func, desc)
            if desc then
              desc = "DAP: " .. desc
            end
            vim.keymap.set("n", keys, func, { desc = desc, buffer = true })
          end
          dap_nmap("B", "<cmd>call win_gotoid(win_getid(bufwinnr('DAP Breakpoints')))<cr>", "[G]o to [B]reakpoints")
          dap_nmap("V", "<cmd>call win_gotoid(win_getid(bufwinnr('DAP Scopes')))<cr>", "[G]o to [V]ariable scopes")
          dap_nmap("W", "<cmd>call win_gotoid(win_getid(bufwinnr('DAP Watches')))<cr>", "[G]o to [W]atches")
          dap_nmap("S", "<cmd>call win_gotoid(win_getid(bufwinnr('DAP Stacks')))<cr>", "[G]o to [S]tacks")
          dap_nmap("!!", "<cmd>call win_gotoid(win_getid(bufwinnr('\\[dap-repl\\]')))<cr>", "[G]o to [R]EPL")

          -- Move cursor up and down in insert mode (useful in dap REPL)
          vim.keymap.set("i", "<C-j>", "<Down>", { desc = "Move cursor down / Select next command", remap = true })
          vim.keymap.set("i", "<C-k>", "<Up>", { desc = "Move cursor up / Select previous command", remap = true })
        end
      })
      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close
      vim.fn.sign_define('DapBreakpoint',{ text ='🛑', texthl ='', linehl ='', numhl =''})
      vim.fn.sign_define('DapStopped',{ text ='▶️', texthl ='', linehl ='', numhl =''})
    end,
  },
}

return M
