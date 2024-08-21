local u = require("utils")

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-neotest/neotest-python",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-python")({
          dap = { justMyCode = true },
          python = u.python_path(),
          args = { "-vv", "--cov", "--cov-report", "term", "--cov-report", "xml:coverage.xml" },
        }),
      },
      diagnostic = {
        enabled = true,
        severity = 1
      },

      quickfix = {
        enabled = true,
        open = false,
      },
    })
    local neotest = package.loaded.neotest
    local wk = require("which-key")
    -- Register normal mode keymaps
    wk.add({
      {"<leader>n", group = "Neotest" },
      {"<leader>na", function() neotest.run.run(vim.fn.getcwd()) end, desc = "Run [n]eotest for current project" },
      {"<leader>nd", function() neotest.run.run({ vim.fn.expand("%"), strategy = "dap" }) end, desc = "Run [n]eotest for current file with [d]ap" },
      {"<leader>nf", function() neotest.run.run({ vim.fn.expand("%") }) end, desc = "Run [n]eotest for current [f]ile" },
      {"<leader>nn", neotest.run.run, desc = "Run [n]eotest for [n]earest test" },
      {"<leader>nl", neotest.run.run_last, desc = "Run [n]eotest for [l]ast position (same args and strategy)" },
      {"<leader>nL", function() neotest.run.run_last({ strategy = "dap" }) end, desc = "Run [n]eotest for [L]ast position (same args but with DAP)" },
      {"<leader>nw", function() neotest.watch.toggle(vim.fn.expand("%")) end, desc = "Toggle [n]eotest [w]atching the current file" },
      {"<leader>nW", neotest.watch.toggle, desc = "Toggle [n]eotest [W]atching the nearest test" },
      {"<leader>no", function() neotest.output.open({ enter = true, auto_close = true }) end, desc = "Open [n]eotest [o]utput" },
      {"<leader>nO", function() neotest.output_panel.toggle() end, desc = "Open [n]eotest [O]utput panel" },
      {"<leader>ns", neotest.summary.toggle, desc = "Toggle [n]eotest [s]ummary" },
    })
    u.nmap("[n", function()
      neotest.jump.prev({ status = "failed" })
    end, "Jump to previous failed test" )
    u.nmap("]n", function()
      neotest.jump.next({ status = "failed" })
    end, "Jump to next failed test")
  end,
}
