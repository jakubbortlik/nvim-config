local nmap = require("utils").nmap
local vmap = require("utils").vmap

return {
  "harrisoncramer/gitlab.nvim",
  branch = "adding-winbar",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "stevearc/dressing.nvim",
  },
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
    gitlab.setup({
      debug = { go_request = true, go_response = true }, -- Which values to log
      discussion_tree = {
        size = "25%",                                    -- Size of split
        position = "bottom",
        toggle_node = "i",
        toggle_resolved = "s",
        tree_type = "by_file_name",
      },
      discussion_sign_and_diagnostic = {
        skip_resolved_discussion = false,
      },
      popup = {
        exit = "q",
        perform_action = "ZZ",
        perform_linewise_action = "<leader>l",
        opacity = 0.85,
      },
    })
    local create_mappings = function()
      nmap("c", gitlab.create_comment, "Gitlab Create Comment", true)
      vmap("c", gitlab.create_multiline_comment, "Gitlab Multiline Comment", true)
      vmap("s", gitlab.create_comment_suggestion, "Gitlab Suggestion", true)
      nmap("C", gitlab.create_note, "Gitlab Create note", true)
      nmap("td", gitlab.toggle_discussions, "Gitlab Toggle Discussions", true)
      nmap("aa", gitlab.add_assignee, "Gitlab Add Assignee", true)
      nmap("da", gitlab.delete_assignee, "Gitlab Delete Assignee", true)
      nmap("ar", gitlab.add_reviewer, "Gitlab Add Reviewer", true)
      nmap("dr", gitlab.delete_reviewer, "Gitlab Delete Reviewer", true)
      nmap("p", gitlab.pipeline, "Gitlab Pipeline", true)
      nmap("O", gitlab.open_in_browser, "Gitlab Open in browser", true)
      nmap(
        "m",
        gitlab.move_to_discussion_tree_from_diagnostic,
        "Move to discussion",
        true
      )
    end
    local id_gitlab = vim.api.nvim_create_augroup("gitlab", {
      clear = true,
    })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter" }, {
      group = id_gitlab,
      pattern = "diffview:///*",
      callback = create_mappings,
    })
    nmap("glr", gitlab.review, "Gitlab Review")
    nmap("gls", gitlab.summary, "Gitlab Summary")
    nmap("glA", gitlab.approve, "Gitlab Approve")
    nmap("glR", gitlab.revoke, "Gitlab Revoke")
    nmap("glc", gitlab.create_comment, "Gitlab Create Comment")
    vmap("glc", gitlab.create_multiline_comment, "Gitlab Multiline Comment")
    vmap("gls", gitlab.create_comment_suggestion, "Gitlab Suggestion")
    nmap("gln", gitlab.create_note, "Gitlab Create note")
    nmap("gld", gitlab.toggle_discussions, "Gitlab Toggle Discussions")
    nmap("glaa", gitlab.add_assignee, "Gitlab Add Assignee")
    nmap("glad", gitlab.delete_assignee, "Gitlab Delete Assignee")
    nmap("glva", gitlab.add_reviewer, "Gitlab Add Reviewer")
    nmap("glvd", gitlab.delete_reviewer, "Gitlab Delete Reviewer")
    nmap("glp", gitlab.pipeline, "Gitlab Pipeline")
    nmap("glo", gitlab.open_in_browser, "Gitlab Open in browser")
    nmap("glm", gitlab.move_to_discussion_tree_from_diagnostic, "Move to discussion")
  end,
}
