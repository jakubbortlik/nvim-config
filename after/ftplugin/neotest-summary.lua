local nmap = require("utils").nmap

vim.o.wrap = false
nmap("q", "<cmd>close<cr>", "Close the Neotest Summary", true)
