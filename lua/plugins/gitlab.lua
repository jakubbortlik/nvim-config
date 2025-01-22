local u = require("utils")

local title_input_width
local discussion_tree_size
local discussion_tree_position
if vim.o.columns > 170 then
  title_input_width = 120
  discussion_tree_size = 90
  discussion_tree_position = "right"
else
  title_input_width = vim.fn.winwidth(0) - 10
  discussion_tree_size = 25
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
    { "gl<C-r>", desc = "Gitlab Restart Server" },
    { "gl<C-a>", desc = "Show eligible approvers" },
    { "glA", desc = "Approve MR" },
    { "glC", desc = "Create MR" },
    { "glD", desc = "Toggle MR comment draft mode" },
    { "glL", desc = "Open gitlab.nvim.log in a new tab" },
    { "glM", desc = "Merge MR" },
    { "glP", desc = "Publish all MR comment drafts" },
    { "glR", desc = "Revoke approval" },
    { "glS" , desc = "Start Gitlab review" },
    { "glaa", desc = "Add MR assignee" },
    { "glad", desc = "Delete MR assignee" },
    { "glb", desc = "Rebuild gitlab server" },
    { "glc", desc = "Choose MR for review" },
    { "gld", desc = "Toggle MR discussions" },
    { "glla", desc = "Add MR label" },
    { "glld", desc = "Delete MR label" },
    { "gln", desc = "Create MR note" },
    { "glo", desc = "Open MR in browser" },
    { "glp", desc = "Show MR pipeline status" },
    { "glra", desc = "Add MR reviewer" },
    { "glrd", desc = "Delete MR reviewer" },
    { "gls", desc = "Show MR summary" },
    { "glu", desc = "Copy MR url" },
  },
  build = function()
    require("gitlab.server").build(true)
  end, -- Builds the Go binary
  config = function()
    local gitlab = require("gitlab")
    local gitlab_server = require("gitlab.server")
    gitlab.setup({
      debug = { -- Which values to log
        request = true,
        response = true,
        gitlab_request = true,
        gitlab_response = true,
      },
      keymaps = {
        help_nowait = true,
        popup = {
          perform_linewise_action_nowait = true,
        },
        reviewer = {
          create_comment_nowait = true,
        },
        discussion_tree = {
          switch_view = "C",
        },
      },
      attachment_dir = vim.fn.expand("$HOME") .. "/Screenshots",
      reviewer_settings = {
        jump_with_no_diagnostics = true,
        diffview = {
          imply_local = true,
        },
      },
      discussion_tree = {
        size = discussion_tree_size, -- Size of split
        position = discussion_tree_position,
        keep_current_open = true,
        expanded_by_default = { resolved = false, unresolved = true },
        draft_mode = true,
        sort_by = "original_comment",
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

    u.nmap("gl<C-a>", "<cmd>!glab mr approvers<cr>", "Show eligible approvers")
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
