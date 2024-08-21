local u = require("utils")

local title_input_width
local discussion_tree_position
if vim.o.columns > 170 then
  title_input_width = 120
  discussion_tree_position = "right"
else
  title_input_width = vim.fn.winwidth(0) - 10
  discussion_tree_position = "bottom"
end

return {
  "harrisoncramer/gitlab.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "stevearc/dressing.nvim",
    "nvim-tree/nvim-web-devicons", -- not required
  },
  enabled = u.host_jakub(),
  keys = {
    { "glc", desc = "Choose MR" },
    { "glC", desc = "Create MR" },
    { "glL", desc = "Open gitlab.nvim.log in a new tab" },
    { "glb", desc = "Rebuild gitlab server" },
    { "gls", desc = "Show MR status" },
    { "glS", desc = "Select MR" },
    { "gl<C-r>", desc = "Gitlab Restart Server" },
    { "glp", desc = "Show Gitlab pipeline" },
  },
  build = function()
    require("gitlab.server").build(true)
  end, -- Builds the Go binary
  config = function()
    local gitlab = require("gitlab")
    local gitlab_server = require("gitlab.server")
    gitlab.setup({
      debug = { go_request = true, go_response = true }, -- Which values to log
      keymaps = {
        help_nowait = true,
        popup = {
          perform_linewise_action_nowait = true,
        },
        reviewer = {
          create_comment_nowait = true,
        },
      },
      attachment_dir = vim.fn.expand("$HOME") .. "/Pictures",
      reviewer_settings = {
        diffview = {
          imply_local = true,
        },
      },
      discussion_tree = {
        size = "90", -- Size of split
        position = discussion_tree_position,
        keep_current_open = true,
        expanded_by_default = { resolved = false, unresolved = true },
      },
      discussion_signs = {
        skip_resolved_discussion = true,
        virtual_text = true,
        use_diagnostic_signs = false,
        icons = {
          comment = "╭",
          range = "│"
        },
      },
      popup = {
        opacity = 0.75,
        width = "60%",
        temp_registers = { '"', "g", "+" },
      },
      create_mr = {
        title_input = {
          width = title_input_width,
        },
        squash = true,
        delete_branch = true,
      },
    })

    require("diffview").setup({
      commit_log_panel = {
        win_config = function()
          return { type = "float", border = "rounded", }
        end
      },
      view = { default = { layout = "diff2_vertical" } },
    })

    u.nmap("glL", function()
      vim.cmd("tab new " .. vim.print(gitlab.state.settings.log_path))
    end, "Open gitlab.nvim.log in a new tab")
    u.nmap("gl<c-l>", function()
      local ok, err = os.remove(gitlab.state.settings.log_path)
      if not ok then
        vim.print(("Unable to remove file %s, error %s"):format(gitlab.state.settings.log_path, err), vim.log.levels.ERROR)
      else
        vim.print("Removed file: " .. gitlab.state.settings.log_path)
      end
    end, "Remove the gitlab.nvim.log file")
    u.nmap("glb", function()
      vim.notify("Rebuilding Gitlab Go server.")
      gitlab_server.build(true)
    end, "Rebuild the Gitlab Go server")
    u.nmap("gl<c-s>", function()
      vim.cmd.tabnew()
      vim.cmd.Verbose('lua require("gitlab").print_settings()')
      vim.cmd.only()
    end, "Print gitlab.nvim settings")
    u.nmap("gl<C-r>", function()
      gitlab_server.restart(function()
        vim.cmd.tabclose()
        gitlab.review()
      end)
    end, "Gitlab Restart Server")
  end,
}
