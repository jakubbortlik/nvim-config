local gitlab = require("gitlab")
local nmap = require("utils").nmap

nmap("C", gitlab.create_note, "Gitlab Create note", true)
nmap("td", gitlab.toggle_discussions, "Gitlab Toggle Discussions", true)
nmap("aa", gitlab.add_assignee, "Gitlab Add Assignee", true)
nmap("da", gitlab.delete_assignee, "Gitlab Delete Assignee", true)
nmap("ar", gitlab.add_reviewer, "Gitlab Add Reviewer", true)
nmap("dr", gitlab.delete_reviewer, "Gitlab Delete Reviewer", true)
nmap("p", gitlab.pipeline, "Gitlab Pipeline", true)
nmap("O", gitlab.open_in_browser, "Gitlab Open in browser", true)

nmap("j", [[<Cmd>call search('[] @')<CR>]], "Go to next thread", true)
nmap("k", [[<Cmd>call search('[] @', 'b')<CR>]], "Go to previous thread", true)
nmap("J", [[<Cmd>call search('^[] @\S*')<CR>]], "Go to next thread", true)
nmap(
  "K",
  [[<Cmd>call search('^[] @\S*', 'b')<CR>]],
  "Go to previous thread",
  true
)

-- nmap("<C-j>", [[<Cmd>call search('[] @\S*.*-$')<CR>]], "Go to next unresolved thread", true)
nmap(
  "<C-k>",
  [[<Cmd>call search('[] @\S*.*-$', 'b')<CR>]],
  "Go to previous unresolved thread",
  true
)

nmap("<C-j>", function()
  if vim.api.nvim_get_current_line():match("^") then
    vim.cmd.normal("i")
  end
  vim.fn.search([[[] @\S*.*-$]])
  if vim.api.nvim_get_current_line():match("^") then
    vim.cmd.normal("i")
  end
end, "Go to next unresolved thread", true)
nmap("<C-k>", function()
  if vim.api.nvim_get_current_line():match("^") then
    vim.cmd.normal("i")
  end
  vim.fn.search([[[] @\S*.*-$]], "b")
  if vim.api.nvim_get_current_line():match("^") then
    vim.cmd.normal("i")
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
