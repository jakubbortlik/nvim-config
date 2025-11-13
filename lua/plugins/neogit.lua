return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "folke/snacks.nvim",
  },
  event = { "CmdlineEnter" },
  keys = {
    { "gs", "<cmd>Neogit<cr>", desc = "Open Neo[g]it [s]tatus in new tab" },
    { "gS", "<cmd>Neogit kind=vsplit<cr>", desc = "Vsplit Neo[g]it [s]tatus" },
  },
  opts = {
    console_timeout = 5000,
    commit_editor = {
      staged_diff_split_kind = "auto",
    },
    integrations = {
      diffview = true,
      snacks = true,
    },
    git_services = {
      ["gitlab.cloud.phonexia.com"] = {
        pull_request = "https://gitlab.cloud.phonexia.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
        commit = "https://gitlab.cloud.phonexia.com/${owner}/${repository}/-/commit/${oid}",
        tree = "https://gitlab.cloud.phonexia.com/${owner}/${repository}/-/tree/${branch_name}?ref_type=heads",
      },
    },
    mappings = {
      status = {
        ["K"] = "OpenOrScrollUp",
        ["J"] = "OpenOrScrollDown",
        ["<c-t>"] = false,
        ["g<c-t>"] = "TabOpen",
      },
    },
  },
}
