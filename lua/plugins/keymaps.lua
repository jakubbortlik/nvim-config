local M = {
  {
    "folke/which-key.nvim", -- Show pending keybinds
    event = "VeryLazy",
    opts = {
      window = {
        border = "rounded",
      },
    }
  },
}

local nmap = require("utils").nmap

-- Override default behaviour
nmap("<C-e>", "3<C-E>", "Scroll down more")
nmap("<C-y>", "3<C-Y>", "Scroll up more")
nmap("J", "mzJ`z", "Join lines without moving cursor")
nmap("1<C-g>", "1<C-g>", "Print full path of current file name") -- Otherwise tmux-sessionizer is started

-- Navigation
vim.cmd [[let g:tmux_navigator_no_mappings = 1]]
vim.keymap.set({"n", "t"}, "<A-h>", "<cmd>TmuxNavigateLeft<cr>", { silent = true, desc = "Navigate left" })
vim.keymap.set({"n", "t"}, "<A-j>", "<cmd>TmuxNavigateDown<cr>", { silent = true, desc = "Navigate down" })
vim.keymap.set({"n", "t"}, "<A-k>", "<cmd>TmuxNavigateUp<cr>", { silent = true, desc = "Navigate up" })
vim.keymap.set({"n", "t"}, "<A-l>", "<cmd>TmuxNavigateRight<cr>", { silent = true, desc = "Navigate right" })
nmap("g<c-]>", "<cmd>tab split | execute 'normal <c-]>'<cr>", "Jump to definition in new tab.")
nmap("<leader>tc", vim.cmd.tabclose, "Close the current tab")

-- Miscellaneous mappings
vim.keymap.set({ "i", "n", "s", "v" }, "<C-s>", "<cmd>update<cr><esc>", { desc = "[s]ave file" })
nmap("co", "m`0:%s///gn<cr>", "[c]ount [o]ccurrences")
nmap("cp", "m`:g//p<cr>", "o[c]currences [p]review")
nmap("<C-w>N", "<cmd>vnew<cr>", "Create [N]ew vertical window")
nmap("<leader>ch", "<cmd>nohlsearch<cr>", "[c]lear [h]ighlighting")
nmap("<leader>la", "<cmd>Lazy<cr>", "Show plugins")
nmap("<leader>I", "<cmd>Inspect<cr>", "[i]nspect current position")
nmap("<leader>sa", [[:s/\%>.c]], "[s]ubstitute [a]fter")
nmap("<leader>su", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "[s]ubstitute word [u]nder cursor")
nmap("<leader>cp", [[<cmd>let @+ = expand('%') | echo "Copied to clipboard: " .. @+<cr>]], "[c]opy [p]ath of buffer to clipboard")
nmap("<leader>cP", [[<cmd>let @+ = expand('%:p') | echo "Copied to clipboard: " .. @+<cr>]], "[c]opy full [P]ath of buffer to clipboard")
nmap("<leader>c<c-p>", [[<cmd>let @+ = expand('%:t') | echo "Copied to clipboard: " .. @+<cr>]], "[c]opy basename of buffer to clipboard")
nmap("<leader>cl", [[<cmd>let @+ = expand('%') .. ':' .. line('.') | echo "Copied to clipboard: " .. @+<cr>]], "[c]opy [p]ath of buffer to clipboard")
nmap("<leader>cL", [[<cmd>let @+ = expand('%:p') .. ':' .. line('.') | echo "Copied to clipboard: " .. @+<cr>]], "[c]opy full [P]ath of buffer to clipboard")
nmap("<leader>c<c-l>", [[<cmd>let @+ = expand('%:t') .. ':' .. line('.') | echo "Copied to clipboard: " .. @+<cr>]], "[c]opy basename of buffer to clipboard")
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], {desc = "Exit terminal-mode"})
nmap("<BS>", "<Del>", "Delete the last digit when entering a number.")

-- TODO: add check that an LSP server is actually attached
nmap("<leader>L", "<cmd>vertical Verbose lua =vim.lsp.get_active_clients()[1].server_capabilities<cr>", "print [L]SP server capabilities")

-- Remaps by ThePrimeagen
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Visual mode paste without losing register" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })
nmap("<leader>Y", [["+y$]], "Add to system clipboard")
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to blackhole register" })
vim.keymap.set("n", "<leader>cx", "<cmd>!chmod +x %<cr>", { silent = true, desc = "Make current file executable" })
nmap("<C-g><C-s>", "<cmd>silent !tmux neww tmux-sessionizer<cr>", "Create tmux [s]ession or attach to one")

-- Adjust textwidth
nmap("<leader>w0", "<cmd>setlocal textwidth=0<cr>", "Set local text[w]idth to [0]" )
nmap("<leader>w7", "<cmd>setlocal textwidth=72<cr>", "Set local text[w]idth to [7]2" )
nmap("<leader>w*", "<cmd>setlocal textwidth=80<cr>", "Set local text[w]idth to [8]0" )
nmap("<leader>w8", "<cmd>setlocal textwidth=88<cr>", "Set local text[w]idth to [8]8" )
nmap("<leader>w9", "<cmd>setlocal textwidth=90<cr>", "Set local text[w]idth to [9]0" )
nmap("<leader>w1", "<cmd>setlocal textwidth=100<cr>", "Set local text[w]idth to [1]00" )

-- Diagnostic keymaps
if vim.fn.has("nvim-0.10") ~= 1 then
  nmap("[d", vim.diagnostic.goto_prev, "Go to previous diagnostic message")
  nmap("]d", vim.diagnostic.goto_next, "Go to next diagnostic message")
  nmap("<leader>do", vim.diagnostic.open_float, "Open floating diagnostic message")
end
nmap("<leader>ds", vim.diagnostic.show, "Show diagnostic message")

-- Keymaps for easier work with messages
nmap("<leader>me", "<cmd>messages<cr>", "View previously given messages")
nmap("<leader>mc", "<cmd>messages clear<cr>", "Clear all messages")
nmap(
  "<leader>mt",
  function()
    vim.cmd.tabnew()
    vim.cmd.Messages()
    vim.cmd.only()
  end,
  "Open [m]essages in new [t]ab"
)

-- Browsing
local open = function(issue)
  issue = issue:gsub("[():.,;]", "")
  if issue:match("^[A-Z]+[-]%d+$") then
    vim.cmd(
      "silent !firefox " .. vim.fn.expand("$JIRA_DOMAIN") .. "/browse/" .. issue
    )
  end
end

vim.keymap.set("n", "gX", function()
  local issue = vim.fn.expand("<cWORD>")
  open(issue)
end, { desc = "Open Jira issue", noremap = true})

vim.keymap.set("x", "gX", function()
  vim.cmd.normal("")
  local sl, sc = unpack(vim.api.nvim_buf_get_mark(0, "<"))
  local el, ec = unpack(vim.api.nvim_buf_get_mark(0, ">"))
  local issue = unpack(vim.api.nvim_buf_get_text(0, sl-1, sc, el-1, ec, {}))
  open(issue)
end, { desc = "Open selected Jira issue", noremap = true})

return M
