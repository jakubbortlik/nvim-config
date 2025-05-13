local nmap = require("utils").nmap

local toggle_if_match = function(pattern)
  if not vim.api.nvim_get_current_line():match("^%s*[].*[✓-] ?") then
    vim.fn.search([[\(^\s*\)\@<=[].*[✓-] \?]], "b")
  end
  if vim.api.nvim_get_current_line():match(pattern) then
    vim.cmd.normal("t")
  end
end

if vim.g.gitlab_reviewer_follow_node == nil then
  vim.g.gitlab_reviewer_follow_node = true
end

nmap("F", function()
  if vim.g.gitlab_reviewer_follow_node then
    vim.g.gitlab_reviewer_follow_node = false
    vim.notify("gitlab.nvim: Don't follow node")
  else
    vim.g.gitlab_reviewer_follow_node = true
    vim.notify("gitlab.nvim: Follow node")
  end
end, "Toggle reviewer follow node", 0)

nmap("j", function()
  vim.cmd.normal("$")
  vim.fn.search("[] @")
  vim.cmd.normal("0")
end, "Go to next node", 0)
nmap("k", function()
  vim.fn.search("[] @", "b")
  vim.cmd.normal("0")
end, "Go to previous node", 0)

nmap("J", function()
  toggle_if_match("^%s*.*[✓-] ?")
  vim.fn.search([[\(^\s*\)\@<=[].*[✓-] \?]])
  toggle_if_match("^%s*")
  vim.cmd.normal("zt")
  if vim.g.gitlab_reviewer_follow_node then
    vim.cmd.normal("aa")
  end
end, "Go to next thread", true)
nmap("K", function()
  toggle_if_match("^%s*.*[✓-] ?")
  vim.fn.search([[\(^\s*\)\@<=[].*[✓-] \?]], "b")
  toggle_if_match("^%s*")
  vim.cmd.normal("zt")
  if vim.g.gitlab_reviewer_follow_node then
    vim.cmd.normal("aa")
  end
end, "Go to previous thread", true)

nmap("<C-j>", function()
  toggle_if_match("^%s*.*[✓-] ?")
  vim.fn.search("[] @\\S*.*[-]")
  toggle_if_match("^%s*")
  vim.cmd.normal("zt")
  if vim.g.gitlab_reviewer_follow_node then
    vim.cmd.normal("aa")
  end
end, "Go to next unresolved thread", true)
nmap("<C-k>", function()
  toggle_if_match("^%s*.*[✓-] ?")
  vim.fn.search("[] @\\S*.*[-]", "b")
  toggle_if_match("^%s*")
  vim.cmd.normal("zt")
  if vim.g.gitlab_reviewer_follow_node then
    vim.cmd.normal("aa")
  end
end, "Go to previous unresolved thread", true)

nmap(
  "<C-n>",
  [[<Cmd>call search('[] @jakub.bortlik')<CR>]],
  "Go to my next thread",
  true
)
nmap(
  "<C-p>",
  [[<Cmd>call search('[] @jakub.bortlik', 'b')<CR>]],
  "Go to my previous thread",
  true
)
nmap(
  "<C-h>",
  [[<Cmd>call search('[] @jakub.bortlik.*-')<CR>]],
  "Go to my next unresolved thread",
  true
)
nmap(
  "<C-l>",
  [[<Cmd>call search('[] @jakub.bortlik.*-', 'b')<CR>]],
  "Go to my previous unresolved thread",
  true
)
vim.keymap.set("n", "<", "Kt", { desc = "Toggle root node", buffer = true, nowait = true, remap = true })

nmap("<Tab>", require("diffview.actions").select_next_entry, "Open diff for the next file", true)
nmap("<S-Tab>", require("diffview.actions").select_prev_entry, "Open diff for the prev file", true)
nmap("<leader>e", require("diffview.actions").focus_files, "Bring focus to file panel", true)
nmap("gn", require("diffview.actions").focus_entry, "Bring focus to NEW file", true)
nmap("go", function()
    require("diffview.actions").focus_entry()
    vim.cmd.wincmd("W")
  end,
  "Bring focus to OLD file",
  true
)

vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.opt_local.textwidth = 0
vim.opt_local.breakindent = true
vim.opt_local.showbreak = "+ "
