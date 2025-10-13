local u = require("utils")

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
  },
  config = function()
    require("neotest").setup({
      icons = {
        running_animated = {"⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷"}
      },
      adapters = {
        require("neotest-python")({
          dap = { justMyCode = true },
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
      {"<leader>t", group = "Neotest" },
      {"<leader>ta", function() neotest.run.run(vim.fn.getcwd()) end, desc = "Run neo[t]est for current [p]roject" },
      {"<leader>tc", neotest.output_panel.clear, desc = "neo[t]est output panel - [c]lear" },
      {"<leader>td", function() neotest.run.run({ strategy = "dap" }) end, desc = "Run neo[t]est for nearest test with [d]ap" },
      {"<leader>tD", function() neotest.run.run({ vim.fn.expand("%"), strategy = "dap" }) end, desc = "Run neo[t]est for current file with [D]ap" },
      {"<leader>tL", function() neotest.run.run_last({ strategy = "dap" }) end, desc = "Run neo[t]est for [L]ast position (same args, with DAP)" },
      {"<leader>tl", neotest.run.run_last, desc = "Run neo[t]est for [l]ast position (same args and strategy)" },
      {"<leader>tn", neotest.run.run, desc = "Run neo[t]est for [n]earest test" },
      {"<leader>tt", function() neotest.run.run({ vim.fn.expand("%") }) end, desc = "Run neo[t]est for [t]his file" },
      {"<leader>tu", neotest.run.stop, desc = "Stop running neo[t]est process" },
      {"<leader>tW", function() neotest.watch.toggle(vim.fn.expand("%")) end, desc = "Toggle neo[t]est [W]atching current file" },
      {"<leader>tw", neotest.watch.toggle, desc = "Toggle neo[t]est [w]atching nearest test" },
      {"<leader>to", function() neotest.output.open({ enter = true, auto_close = true, open_win = function()
        vim.cmd('tabnew')
        local win_id = vim.api.nvim_get_current_win()
        return win_id
      end}) end, desc = "Open neo[t]est [o]utput" },
      {"<leader>tp", function() neotest.output_panel.toggle() end, desc = "Open neo[t]est output [p]anel" },
      {"<leader>ts", neotest.summary.toggle, desc = "Toggle neo[t]est [s]ummary" },
    })
    u.nmap("[F", function()
      neotest.jump.prev({ status = "failed" })
    end, "Jump to previous failed test" )
    u.nmap("]F", function()
      neotest.jump.next({ status = "failed" })
    end, "Jump to next failed test")
  end,
}
