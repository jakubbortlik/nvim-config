local u = require("utils")

local title_input_width
local discussion_tree_size
local discussion_tree_position
local comment_position = { row = "92%", col = "100%" }
local comment_opts = { width = 112, height = 30, position = comment_position }
if vim.o.columns > 170 then
  title_input_width = 120
  discussion_tree_size = 96
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
    {
      require("utils").get_diffview_provider(),
      opts = {
        view = { default = { layout = "diff2_vertical" } },
      },
    },
    "nvim-tree/nvim-web-devicons", -- not required
  },
  lazy = false,
  enabled = u.host_jakub(),
  keys = {
    { "gl<C-r>", desc = "Gitlab Restart Server" },
    { "gl<C-a>", desc = "Show eligible approvers" },
    { "glA", desc = "Approve MR" },
    { "glC", desc = "Create MR" },
    { "glD", desc = "Toggle MR comment draft mode" },
    { "glL", desc = "Open gitlab.nvim.log in a new tab" },
    { "glM", desc = "Merge MR" },
    { "glm", desc = "Set MR to auto-merge" },
    { "glP", desc = "Publish all MR comment drafts" },
    { "glR", desc = "Revoke approval" },
    { "glS", desc = "Start Gitlab review" },
    { "gl<c-s>", desc = "Print gitlab.nvim settings" },
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
    { "gl<c-p>", desc = "Show CI pipeline with glab" },
    { "glra", desc = "Add MR reviewer" },
    { "glrd", desc = "Delete MR reviewer" },
    { "gls", desc = "Show MR summary" },
    { "glu", desc = "Copy MR url" },
  },
  config = function()
    local gitlab = require("gitlab")
    local gitlab_server = require("gitlab.server")
    ---@type GitlabSettings
    gitlab.setup({
      debug = { -- Which values to log
        request = false,
        response = false,
        gitlab_request = false,
        gitlab_response = false,
      },
      keymaps = {
        help_nowait = true,
        popup = {
          perform_linewise_action_nowait = true,
          next_field = "g<tab>", -- Cycle to the next field. Accepts |count|.
          prev_field = "g<S-tab>", -- Cycle to the previous field. Accepts |count|.
        },
        reviewer = {
          create_comment_nowait = true,
          create_suggestion_with_preview_nowait = true,
          create_suggestion_with_preview = "s",
          create_suggestion = "S",
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
      mergeability_checks = {
        statuses = {
          INACTIVE = false,
        },
      },
      discussion_tree = {
        indent_width = 2, -- Display columns that one level of nesting indents by. Indentation is drawn as virtual text, so it never enters the buffer and is not copied along with note text
        winopts = {
          linebreak = false,
          breakindent = true,
          showbreak = "X",
        },
        expanders = { -- Discussion tree icons
          expanded = " ", -- Icon for expanded discussion thread
          collapsed = " ", -- Icon for collapsed discussion thread
        },
        size = discussion_tree_size, -- Size of split
        position = discussion_tree_position,
        keep_current_open = true,
        expanded_by_default = { resolved = false, unresolved = true },
        draft_mode = true,
        sort_by = "original_comment",
        reviewer_follows_discussion = true,
      },
      emojis = {
        formatter = function(val)
          local tmux = os.getenv("TMUX")
          local emoji = val.moji:gsub("^([\226][\152][\157])([\239][\184][\143]?)", tmux and " %1%2 " or "%1%2 ") -- point up
          emoji = emoji:gsub("^([\226][\156][\140])([\239][\184][\143]?)", tmux and " %1%2 " or "%1%2 ") -- victory
          emoji = emoji:gsub("^([\226][\156][\141])([\239][\184][\143]?)", tmux and " %1%2 " or "%1%2 ") -- writing hand
          emoji = emoji:gsub("[\240][\159][\143][\187-\191]", "") -- remove skin tones
          emoji = emoji:gsub(tmux and "^ " or "^" .. "([\240][\159][\135][\166-\191])  ", tmux and "  %1" or "%1") -- prepend flags with a space
          return string.format("%s  %s | %s (%s)", emoji, val.shortname, val.name, val.category)
        end,
      },
      discussion_signs = {
        skip_resolved_discussion = true,
        virtual_text = true,
        use_diagnostic_signs = false,
        icons = {
          comment = "╭",
          range = "│",
        },
      },
      popup = {
        opacity = 0.75,
        width = "60%",
        temp_registers = { "g", "+" },
        comment = comment_opts,
        reply = comment_opts,
        edit = comment_opts,
        note = comment_opts,
        summary = { border = "single", height = "90%", width = "90%" },
      },
      info = {
        horizontal = true,
      },
      create_mr = {
        title_input = {
          width = title_input_width,
        },
        squash = true,
        delete_branch = true,
      },
      colors = {
        discussion_tree = {
          file_name = "Directory",
        }
      },
    })

    u.nmap("gl<C-a>", function()
      Snacks.terminal.open('glab mr approvers', {auto_close = false, win = {width = 90, height = 30, border = 'rounded'}})
    end, "Show eligible approvers")
    u.nmap("gl<c-p>", "<cmd>lua Snacks.terminal.open('glab ci view', {win = {width = 190}})<cr>", "Show CI pipeline with glab")
    u.nmap("glL", function()
      vim.cmd.tabnew()
      vim.cmd.edit(gitlab.state.settings.log_path)
    end, "Open gitlab.nvim.log in a new tab")
    u.nmap("gl<c-l>", function()
      local ok, err = os.remove(gitlab.state.settings.log_path)
      if not ok then
        vim.print(
          ("Unable to remove file %s, error %s"):format(gitlab.state.settings.log_path, err),
          vim.log.levels.ERROR
        )
      else
        vim.print("Removed file: " .. gitlab.state.settings.log_path)
      end
    end, "Remove the gitlab.nvim.log file")
    u.nmap("glb", function()
      vim.notify("Rebuilding Gitlab Go server.")
      gitlab_server.build(true)
    end, "Rebuild the Gitlab Go server")
    u.nmap("gle", require("gitlab").create_comment, "Create comment on current line")
    u.nmap("gl<c-e>", function()
      require("gitlab").create_comment({with_suggestion=true})
    end, "Create comment on current line")
    u.vmap("gl<c-e>", function()
      require("gitlab").create_comment({with_suggestion=true})
    end, "Create comment on current line")
    u.vmap("gle", require("gitlab").create_multiline_comment, "Create comment on current selection")
    u.vmap("glE", require("gitlab").create_comment_suggestion, "Create comment suggestion on current selection")
    u.nmap("gl<c-s>", function()
      vim.cmd.tabnew()
      local settings = vim.inspect(require("gitlab").state.settings)
      vim.api.nvim_put(vim.split(settings, "\n"), "l", true, true)
      vim.cmd.only()
      vim.o.buftype = "nofile"
    end, "Print gitlab.nvim settings")
  end,
}
