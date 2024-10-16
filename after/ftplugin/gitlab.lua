local discussions = require("gitlab.actions.discussions")
local nmap = require("utils").nmap

local toggle_if_match = function(pattern)
  if not vim.api.nvim_get_current_line():match("^%s*[].*[✓-] ?") then
    vim.fn.search([[\(^\s*\)\@<=[].*[✓-] \?]], "b")
  end
  if vim.api.nvim_get_current_line():match(pattern) then
    vim.cmd.normal("t")
  end
end

nmap("j", [[<Cmd>call search('[] @')<CR>]], "Go to next node", 0)
nmap("k", [[<Cmd>call search('[] @', 'b')<CR>]], "Go to previous node", 0)

nmap("J", function()
  toggle_if_match("^%s*.*[✓-] ?")
  vim.fn.search([[\(^\s*\)\@<=[].*[✓-] \?]])
  toggle_if_match("^%s*")
end, "Go to next thread", true)
nmap("K", function()
  toggle_if_match("^%s*.*[✓-] ?")
  vim.fn.search([[\(^\s*\)\@<=[].*[✓-] \?]], "b")
  toggle_if_match("^%s*")
end, "Go to previous thread", true)

nmap("<C-j>", function()
  toggle_if_match("^%s*.*[✓-] ?")
  vim.fn.search("[] @\\S*.*[-]")
  toggle_if_match("^%s*")
end, "Go to next unresolved thread", true)
nmap("<C-k>", function()
  toggle_if_match("^%s*.*[✓-] ?")
  vim.fn.search("[] @\\S*.*[-]", "b")
  toggle_if_match("^%s*")
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

nmap(
  "<C-r>", function()
    discussions.load_discussions(discussions.rebuild_discussion_tree)
    vim.print("Discussions reloaded")
  end, "Reload discussions", true
)

nmap("<Tab>", require("diffview.actions").select_next_entry, "Open the diff for the next file")
nmap("<S-Tab>", require("diffview.actions").select_prev_entry, "Open the diff for the previous file")
nmap("<leader>e", require("diffview.actions").focus_files, "Bring focus to the file panel")

vim.o.number = false
vim.o.relativenumber = false
vim.o.textwidth = 0
vim.o.breakindent = true
