local gitlab = require("gitlab")
local nmap = require("utils").nmap

local toggle_if_match = function(pattern)
  if not vim.api.nvim_get_current_line():match("^%s*[].*[✓-]$") then
    vim.fn.search([[\(^\s*\)\@<=[].*[✓-]$]], "b")
  end
  if vim.api.nvim_get_current_line():match(pattern) then
    vim.cmd.normal("t")
  end
end

nmap("aa", gitlab.add_assignee, "Gitlab Add Assignee", true)
nmap("da", gitlab.delete_assignee, "Gitlab Delete Assignee", true)
nmap("ar", gitlab.add_reviewer, "Gitlab Add Reviewer", true)
nmap("dr", gitlab.delete_reviewer, "Gitlab Delete Reviewer", true)
nmap("P", gitlab.pipeline, "Gitlab Pipeline", true)

nmap("j", [[<Cmd>call search('[] @')<CR>]], "Go to next node", true)
nmap("k", [[<Cmd>call search('[] @', 'b')<CR>]], "Go to previous node", true)

nmap("J", function()
  toggle_if_match("^%s*.*[✓-]$")
  vim.fn.search([[\(^\s*\)\@<=[].*[✓-]$]])
  toggle_if_match("^%s*")
end, "Go to next thread", true)
nmap("K", function()
  toggle_if_match("^%s*.*[✓-]$")
  vim.fn.search([[\(^\s*\)\@<=[].*[✓-]$]], "b")
  toggle_if_match("^%s*")
end, "Go to previous thread", true)

nmap("<C-j>", function()
  toggle_if_match("^%s*.*[✓-]$")
  vim.fn.search([[[] @\S*.*-$]])
  toggle_if_match("^%s*")
end, "Go to next unresolved thread", true)
nmap("<C-k>", function()
  toggle_if_match("^%s*.*[✓-]$")
  vim.fn.search([[[] @\S*.*-$]], "b")
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
  [[<Cmd>call search('[] @jakub.bortlik.*-$')<CR>]],
  "Go to my next unresolved thread",
  true
)
nmap(
  "<C-l>",
  [[<Cmd>call search('[] @jakub.bortlik.*-$', 'b')<CR>]],
  "Go to my previous unresolved thread",
  true
)

vim.o.number = false
vim.o.relativenumber = false
vim.o.textwidth = 0
vim.o.breakindent = true
