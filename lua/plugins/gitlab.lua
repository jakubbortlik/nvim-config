local nmap = require("utils").nmap
local vmap = require("utils").vmap

return {
  "harrisoncramer/gitlab.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "stevearc/dressing.nvim",
  },
  dev = true,
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
        size = "25%", -- Size of split
        position = "right",
        keep_current_open = true,
        expanded_by_default = { resolved = false, unresolved = true },
      },
      discussion_signs = {
        skip_resolved_discussion = true,
        virtual_text = true,
      },
      popup = {
        exit = "q",
        perform_action = "ZZ",
        opacity = 0.85,
        width = "60%",
        temp_registers = { '"', "g", "+" },
      },
      create_mr = {
        title_input = {
          width = vim.fn.winwidth(0) > 120 and 120 or vim.fn.winwidth(0) - 10,
        },
        squash = false,
        delete_branch = true,
      },
    })
    nmap("glr", gitlab.review, "Gitlab Review")
    nmap("gls", gitlab.summary, "Gitlab Summary")
    nmap("glA", gitlab.approve, "Gitlab Approve")
    nmap("glR", gitlab.revoke, "Gitlab Revoke")
    nmap("glc", gitlab.create_comment, "Gitlab Create Comment")
    vmap("glc", gitlab.create_multiline_comment, "Gitlab Multiline Comment")
    vmap("gls", gitlab.create_comment_suggestion, "Gitlab Suggestion")
    nmap("glO", gitlab.create_mr, "Gitlab Create MR")
    nmap("gln", gitlab.create_note, "Gitlab Create note")
    nmap("gld", gitlab.toggle_discussions, "Gitlab Toggle Discussions")
    nmap("glaa", gitlab.add_assignee, "Gitlab Add Assignee")
    nmap("glad", gitlab.delete_assignee, "Gitlab Delete Assignee")
    nmap("glva", gitlab.add_reviewer, "Gitlab Add Reviewer")
    nmap("glvd", gitlab.delete_reviewer, "Gitlab Delete Reviewer")
    nmap("glp", gitlab.pipeline, "Gitlab Pipeline")
    nmap("glo", gitlab.open_in_browser, "Gitlab Open in browser")
    nmap("glm", gitlab.move_to_discussion_tree_from_diagnostic, "Move to discussion")
    nmap("gl<C-r>", function()
      gitlab_server.restart(function()
        vim.cmd.tabclose()
        gitlab.review()
      end)
    end, "Gitlab Restart Server")
    nmap("glq", function()
      vim.cmd([[0,$yank *]])
      vim.cmd.normal("ZQ")
    end, "Save contents to * register & Close window")
  end,
}
