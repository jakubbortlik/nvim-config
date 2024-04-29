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
    wk.register({
      n = {
        name = "Neotest",   -- optional group name
        a = { function() neotest.run.run(vim.fn.getcwd()) end, "Run [n]eotest for current project" },
        d = { function() neotest.run.run({ vim.fn.expand("%"), strategy = "dap" }) end, "Run [n]eotest for current file with [d]ap" },
        f = { function() neotest.run.run({ vim.fn.expand("%") }) end, "Run [n]eotest for current [f]ile" },
        n = { neotest.run.run, "Run [n]eotest for [n]earest test" },
        l = { neotest.run.run_last, "Run [n]eotest for [l]ast position (same args and strategy)" },
        L = { function() neotest.run.run_last({ strategy = "dap" }) end, "Run [n]eotest for [L]ast position (same args but with DAP)" },
        w = { function() neotest.watch.toggle(vim.fn.expand("%")) end, "Toggle [n]eotest [w]atching the current file" },
        W = { neotest.watch.toggle, "Toggle [n]eotest [W]atching the nearest test" },
        o = { function() neotest.output.open({ enter = true, auto_close = true }) end, "Open [n]eotest [o]utput" },
        O = { function() neotest.output_panel.toggle() end, "Open [n]eotest [O]utput panel" },
        s = { neotest.summary.toggle, "Toggle [n]eotest [s]ummary" },
      },
    }, { prefix = "<leader>" })
    u.nmap("[n", function()
      neotest.jump.prev({ status = "failed" })
    end, "Jump to previous failed test" )
    u.nmap("]n", function()
      neotest.jump.next({ status = "failed" })
    end, "Jump to next failed test")
  end,
}
