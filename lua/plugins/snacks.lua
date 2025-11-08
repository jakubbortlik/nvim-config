vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "Directory" })
vim.api.nvim_set_hl(0, "SnacksPickerMatch", { link = "IncSearch" })

return {
  enabled = true,
  zen = { enabled = true },
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    dim = { enabled = true, animate = { enabled = false }},
    explorer = { enabled = true },
    indent = { enabled = false },
    input = { enabled = true },
    picker = require("plugins.more_snacks.pickers"),
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = false, cursor = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = true },
    zen = { enabled = true, toggles = { dim = true }}
  },
  keys = {
    -- Top Pickers & Explorer
    { "<leader>sP", function() Snacks.picker() end, desc = "Pickers" },
    { "<leader><space>", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sn", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>se", function() Snacks.picker.explorer({layout = {preview = "main"}}) end, desc = "File Explorer" },
    -- find
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    -- git
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git log" },
    { "<leader>g<c-l>", function()
      vim.ui.input({prompt="git log -S <string>"}, function(item)
        if item then
          Snacks.picker.git_log({pickaxe = item})
        end
      end)
    end, desc = "Git log -S" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    { "<leader>gb", function() Snacks.gitbrowse({ notify=false }) end, desc = "Git browse", mode = { "n", "x" } },
    { "<leader>gy", function()
      Snacks.gitbrowse({ what = "permalink", open = function(url)
        local start_line, end_line = url:match("#L(%d+)%-L(%d+)$")
        if tonumber(start_line) == tonumber(end_line) then
          url = url:gsub("%-L%d+$", "")
        end
        vim.fn.setreg("+", url)
        Snacks.notify(url)
      end,
      notify = false,
      url_patterns = {
        ["gitlab.*%.com"] = {
          branch = "/-/tree/{branch}",
          file = "/-/blob/{branch}/{file}#L{line_start}-L{line_end}",
          permalink = "/-/blob/{commit}/{file}#L{line_start}-L{line_end}",
          commit = "/-/commit/{commit}",
        },
      },})
      local mode = vim.fn.mode()
      if mode == "v" or mode == "V" then
        vim.cmd.visual()
      end
    end, desc = "Git browse", mode = { "n", "x" } },
    { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
    { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
    { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
    { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
    -- grep
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>ss", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>sg", function() Snacks.picker.git_grep() end, desc = "Git Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    { "<c-'>", function() Snacks.picker.registers() end, desc = "Registers", mode = "n" },
    { "<c-'>", function() Snacks.picker.registers({
      title = "Registers (insert)",
      win = {
        input = {
          keys = {
            ["<C-'>"] = { "use_register_insert", mode = { "n", "i" } },
          },
        },
      },
    }) end, desc = "Registers", mode = "i" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    { "<leader>sp", function() Snacks.picker.spell_errors() end, desc = "Colorschemes" },
    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "grR", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gry", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    -- Other
    { "\\z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "\\Z",  function() Snacks.zen({on_open = function()
      vim.o.diff = false
    end}) end, desc = "Toggle Zen Mode without diff" },
    { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>nh",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<c-t>",      function()
      if vim.v.count1 % 2 == 0 then
        Snacks.terminal(nil, {win = {position = "right"}})
      else
        Snacks.terminal()
      end
    end, desc = "Toggle Terminal", mode = { "n", "t", "x" } },
    { "<m-n>",         function() Snacks.words.jump(vim.v.count1, true) end, desc = "Next Reference", mode = { "n", "t", "x" } },
    { "<m-p>",         function() Snacks.words.jump(-vim.v.count1, true) end, desc = "Prev Reference", mode = { "n", "t", "x" } },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.diagnostics():map("\\d")
        Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("\\c")
        Snacks.toggle.treesitter():map("\\T")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("\\b")
        Snacks.toggle.inlay_hints():map("\\h")
        Snacks.toggle.dim():map("\\D")
      end,
    })
  end,
}
