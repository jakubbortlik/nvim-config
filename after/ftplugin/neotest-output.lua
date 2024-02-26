local nmap = require("utils").nmap

vim.o.wrap = true
nmap("q", "<cmd>close<cr>", "Close the Neotest Output", true)
