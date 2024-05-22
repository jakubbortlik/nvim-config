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
  build = function()
    require("gitlab.server").build(true)
  end, -- Builds the Go binary
  config = function()
    require("dressing").setup({
      input = {
        enabled = true,
      },
    })
    local gitlab = require("gitlab")
    local gitlab_server = require("gitlab.server")
    gitlab.setup({
      debug = { go_request = true, go_response = true }, -- Which values to log
      attachment_dir = vim.fn.expand("$HOME") .. "/Pictures",
      reviewer_settings = {
        diffview = {
          imply_local = true,
        },
      },
      discussion_tree = {
        jump_to_reviewer = "a",
        refresh_data = "",
        size = "25%", -- Size of split
        position = discussion_tree_position,
        keep_current_open = true,
        expanded_by_default = { resolved = false, unresolved = true },
      },
      discussion_signs = {
        skip_resolved_discussion = true,
        virtual_text = true,
      },
      popup = {
        perform_action = "ZZ",
        opacity = 0.85,
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

    ---@param cb string Name of the API function to call
    local function execute_operatorfunc(cb)
      local old_opfunc = vim.opt.operatorfunc
      local cur_win = vim.api.nvim_get_current_win()
      local cur_pos = vim.api.nvim_win_get_cursor(cur_win)

      _G.CreateOperatorfunc = function(callback)
        return function()
          vim.cmd.execute([["normal! '[V']"]])
          vim.api.nvim_command(('lockmarks lua require("gitlab").%s()'):format(callback))
          vim.api.nvim_win_set_cursor(cur_win, cur_pos)
          vim.opt.operatorfunc = old_opfunc
        end
      end

      vim.opt.operatorfunc = ("v:lua.CreateOperatorfunc'%s'"):format(cb)
      vim.api.nvim_feedkeys("g@", "n", false)
    end

    require("diffview").setup({
      commit_log_panel = {
        win_config = function()
          return { type = "float", border = "rounded", }
        end
      },
      view = { default = { layout = "diff2_vertical" } },
      keymaps = {
        view = {
          { "n", "c", function() execute_operatorfunc("create_multiline_comment") end, { desc = "Create comment in range of motion"} },
          { "n", "s", function() execute_operatorfunc("create_comment_suggestion") end, { desc = "Create suggestion for range of motion"} },
          { "n", "a", function() require("gitlab").move_to_discussion_tree_from_diagnostic() end, { desc = "Move to discussion"} },
          { "v", "s", function () require("gitlab").create_comment_suggestion() end, {desc = "Create suggestion for selected text"}},
          { "v", "c", function () require("gitlab").create_multiline_comment() end, {desc = "Create comment for selected text"}},
        }
      },
    })

    u.nmap("glc", gitlab.choose_merge_request, "Gitlab choose MR")
    u.nmap("glr", gitlab.review, "Gitlab Review")
    u.nmap("gls", gitlab.summary, "Gitlab Summary")
    u.nmap("glA", gitlab.approve, "Gitlab Approve")
    u.nmap("glR", gitlab.revoke, "Gitlab Revoke")
    u.nmap("glO", gitlab.create_mr, "Gitlab Create MR")
    u.nmap("gln", gitlab.create_note, "Gitlab Create note")
    u.nmap("gld", gitlab.toggle_discussions, "Gitlab Toggle Discussions")
    u.nmap("glaa", gitlab.add_assignee, "Gitlab Add Assignee")
    u.nmap("glad", gitlab.delete_assignee, "Gitlab Delete Assignee")
    u.nmap("glva", gitlab.add_reviewer, "Gitlab Add Reviewer")
    u.nmap("glvd", gitlab.delete_reviewer, "Gitlab Delete Reviewer")
    u.nmap("glp", gitlab.pipeline, "Gitlab Pipeline")
    u.nmap("glo", gitlab.open_in_browser, "Gitlab Open in browser")
    u.nmap("glu", gitlab.copy_mr_url, "Copy URL of MR")
    u.nmap("glM", gitlab.merge, "Merge MR")
    u.nmap("gll", function()
      vim.cmd("tab new " .. vim.print(gitlab.state.settings.log_path))
    end, "Open gitlab.nvim.log in a new tab")
    u.nmap("glL", function()
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
    u.nmap("glS", function()
      vim.cmd.tabnew()
      vim.cmd.Verbose('lua require("gitlab").print_settings()')
      vim.cmd.only()
    end, "Gitlab print Settings")
    u.nmap("gl<C-r>", function()
      gitlab_server.restart(function()
        vim.cmd.tabclose()
        gitlab.review()
      end)
    end, "Gitlab Restart Server")
    u.nmap("glq", function()
      vim.cmd([[0,$yank *]])
      vim.cmd.normal("ZQ")
    end, "Save contents to * register & Close window")
    u.nmap("ZQ", function()
      local reg_backup = gitlab.state.settings.popup.temp_registers
      gitlab.state.settings.popup.temp_registers = {}
      vim.cmd("quit!")
      gitlab.state.settings.popup.temp_registers = reg_backup
    end)
    u.nmap("glD", gitlab.toggle_draft_mode, "Toggle between draft and live mode")
    u.nmap("glP", gitlab.publish_all_drafts, "Publish all drafts")
  end,
}
