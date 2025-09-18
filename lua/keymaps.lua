local imap = require("utils").imap
local nmap = require("utils").nmap
local vmap = require("utils").vmap

-- Override default behaviour
nmap("<C-e>", "3<C-E>", "Scroll down more")
nmap("<C-y>", "3<C-Y>", "Scroll up more")
nmap("1<C-g>", "1<C-g>", "Print full path of current file name") -- Otherwise tmux-sessionizer is started

nmap("_", function()
  if vim.v.count == 0 then
    local cur_height = vim.api.nvim_win_get_height(0)
    local total_height = vim.o.lines - 2
    if (total_height > cur_height) and (cur_height > total_height / 2) then
      vim.cmd("resize " .. math.floor(total_height / 2)) -- equalize
    else
      vim.cmd("wincmd _") -- maximize
    end
  else
    vim.cmd(vim.v.count .. "wincmd _") -- set to count
  end
end, "Maximize/equalize win height or set to [count]")

-- Navigation
local tmux_navigate = function(keymap)
  local cfg = vim.api.nvim_win_get_config(0)
  local directions = {
    ["<A-h>"] = { "Left", "-L" },
    ["<A-l>"] = { "Right", "-R" },
    ["<A-j>"] = { "Down", "-D" },
    ["<A-k>"] = { "Up", "-U" },
  }
  -- Navigate with Tmux when in a floating window
  if cfg.external or #cfg.relative ~= 0 then
    vim.system({ "tmux", "select-pane", directions[keymap][2] })
  else
    vim.cmd(string.format("TmuxNavigate%s", directions[keymap][1]))
  end
end

vim.cmd([[let g:tmux_navigator_no_mappings = 1]])
vim.keymap.set({ "n", "t", "i" }, "<A-h>", function()
  tmux_navigate("<A-h>")
end, { silent = true, desc = "Navigate left" })
vim.keymap.set({ "n", "t", "i" }, "<A-j>", function()
  tmux_navigate("<A-j>")
end, { silent = true, desc = "Navigate down" })
vim.keymap.set({ "n", "t", "i" }, "<A-k>", function()
  tmux_navigate("<A-k>")
end, { silent = true, desc = "Navigate up" })
vim.keymap.set({ "n", "t", "i" }, "<A-l>", function()
  tmux_navigate("<A-l>")
end, { silent = true, desc = "Navigate right" })

nmap("g<c-t>", "<cmd>tab split | execute 'normal <c-]>'<cr>", "Jump to definition in new tab.")
nmap("g<c-v>", "<cmd>vsplit | execute 'normal <c-]>'<cr>", "Jump to definition in new vertical split.")
nmap("g<c-x>", "<cmd>split | execute 'normal <c-]>'<cr>", "Jump to definition in new horizontal split.")
nmap("<leader>tq", vim.cmd.tabclose, "Close the current tab")
nmap("g<c-o>", function()
  local previous_file = vim.fn.expand("%:p")
  local jump_count = 0
  while jump_count < 100 do
    vim.cmd.normal({ args = { "" }, bang = true })
    jump_count = jump_count + 1
    local current_file = vim.fn.expand("%:p")
    if current_file ~= previous_file and current_file ~= "" then
      vim.api.nvim_command("bwipe #")
      return
    end
  end
end, "Go back to previously visited file and bufwipe current file")

-- Miscellaneous mappings
nmap("co", "m`0:%s///gn<cr>", "[c]ount [o]ccurrences")
nmap("cp", "m`:g//p<cr>", "o[c]currences [p]review")
nmap("<C-w>N", "<cmd>vnew<cr>", "Create [N]ew vertical window")
nmap("<leader>ch", "<cmd>nohlsearch<cr>", "[c]lear [h]ighlighting")
nmap("<leader>cc", "<cmd>cclose<cr>", "[c]lose [c]uickfix window")
nmap("<leader>ly", "<cmd>Lazy<cr>", "Show plugins")
nmap("<leader>I", "<cmd>Inspect<cr>", "[i]nspect current position")
nmap("<leader>sa", [[:s/\%>.c]], "[s]ubstitute [a]fter")

nmap("g<C-j>", "mzJ`z", "Join lines without moving cursor")

local get_relative_path = function()
  local path = vim.fn.expand("%")
  local workspaces = vim.lsp.buf.list_workspace_folders()
  if workspaces[1] then
    path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":s?" .. workspaces[1] .. "/??")
  end
  return path
end

local copy_path_to_clipboard = function(path, with_line)
  if with_line then
    path = string.format("`%s` line %s", path, vim.fn.line("."))
  end
  print("Copied to clipboard: " .. path)
  vim.fn.setreg("+", path)
end

nmap("<leader>cp", function()
  copy_path_to_clipboard(get_relative_path())
end, "[c]opy [p]ath of buffer to clipboard")
nmap("<leader>cP", function()
  copy_path_to_clipboard(vim.fn.expand("%:p"))
end, "[c]opy full [P]ath of buffer to clipboard")
nmap("<leader>c<c-p>", function()
  copy_path_to_clipboard(vim.fn.expand("%:t"))
end, "[c]opy basename of buffer to clipboard")

nmap("<leader>cl", function()
  copy_path_to_clipboard(get_relative_path(), true)
end, "[c]opy [p]ath of buffer to clipboard")
nmap("<leader>cL", function()
  copy_path_to_clipboard(vim.fn.expand("%:p"), true)
end, "[c]opy full [P]ath of buffer to clipboard")
nmap("<leader>c<c-l>", function()
  copy_path_to_clipboard(vim.fn.expand("%:t"), true)
end, "[c]opy basename of buffer to clipboard")

local v_copy_path_to_clipboard = function(path)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", false, true, true), "nx", false)
  local sel_start = vim.fn.line("'<")
  local sel_end = vim.fn.line("'>")
  local text = string.format("`%s` lines %s-%s", path, sel_start, sel_end)
  print("Copied to clipboard: " .. text)
  vim.fn.setreg("+", text)
end
vmap("<leader>cl", function()
  v_copy_path_to_clipboard(vim.fn.expand("%"))
end, "[c]opy path with [l]ine numbers to clipboard")
vmap("<leader>cL", function()
  v_copy_path_to_clipboard(vim.fn.expand("%:p"))
end, "[c]opy full path with [l]ine numbers to clipboard")
vmap("<leader>c<C-l>", function()
  v_copy_path_to_clipboard(vim.fn.expand("%:t"))
end, "[c]opy basename with [l]ine numbers to clipboard")

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal-mode" })
nmap("<BS>", "<Del>", "Delete the last digit when entering a number.")

-- Make n and N behave the same regardless of previous search direction
vim.keymap.set({ "n" }, "n", "/<CR>", { silent = true, desc = "Search forward" })
vim.keymap.set({ "n" }, "N", "?<CR>", { silent = true, desc = "Search backward" })

-- LSP-related keymaps
nmap("<leader>lc", function()
  local active_clients = vim.lsp.get_clients()
  if next(active_clients) == nil then
    vim.notify("No active LSP client is available.")
    return
  end
  local lines = {}
  for _, client in ipairs(active_clients) do
    table.insert(lines, client.name .. " (id " .. tostring(client.id) .. "):")
    local capabilities_str = vim.inspect(client.server_capabilities)
    for line in capabilities_str:gmatch("[^\r\n]+") do
      table.insert(lines, line)
    end
    table.insert(lines, "") -- Add an empty line between clients
  end
  vim.api.nvim_command("new")
  vim.bo.buftype = "nofile"
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.keymap.set("n", "q", "<cmd>bwipeout<cr>", { buffer = buf })
end, "[l]ist LSP server [c]apabilities")

nmap("grf", vim.lsp.buf.format, "vim.lsp.buf.format()")
nmap("gD", "<cmd>normal! gd<cr>", "[g]o to local [D]efinition")
nmap("K", vim.lsp.buf.hover, "vim.lsp.buf.hover()")
imap("<C-k>", vim.lsp.buf.signature_help, "vim.lsp.buf.signature_help()")
nmap("<leader>lr", "<cmd>LspRestart<cr>", "Restart LSP")
nmap("<leader>ls", "<cmd>LspStop<cr>", "Stop LSP")

-- Remaps by ThePrimeagen
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Visual mode paste without losing register" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })
nmap("<leader>Y", [["+y$]], "Copy cursor->EOL to system clipboard")
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to blackhole register" })
vim.keymap.set("n", "<leader>cx", "<cmd>!chmod +x %<cr>", { silent = true, desc = "Make current file executable" })
nmap("<C-g><C-s>", "<cmd>silent !tmux neww tmux-sessionizer<cr>", "Create tmux [s]ession or attach to one")

-- Adjust textwidth
nmap("<leader>w0", "<cmd>setlocal textwidth=0<cr>", "Set local text[w]idth to [0]")
nmap("<leader>w7", "<cmd>setlocal textwidth=72<cr>", "Set local text[w]idth to [7]2")
nmap("<leader>w*", "<cmd>setlocal textwidth=80<cr>", "Set local text[w]idth to [8]0")
nmap("<leader>w8", "<cmd>setlocal textwidth=88<cr>", "Set local text[w]idth to [8]8")
nmap("<leader>w9", "<cmd>setlocal textwidth=90<cr>", "Set local text[w]idth to [9]0")
nmap("<leader>w1", "<cmd>setlocal textwidth=100<cr>", "Set local text[w]idth to [1]00")

-- Diagnostic keymaps
if vim.fn.has("nvim-0.10") ~= 1 then
  nmap("[d", vim.diagnostic.jump, "Go to previous diagnostic message")
  nmap("]d", function()
    vim.diagnostic.jump({ count = -1 })
  end, "Go to next diagnostic message")
  nmap("<leader>do", vim.diagnostic.open_float, "Open floating diagnostic message")
end
nmap("<leader>ds", vim.diagnostic.show, "Show diagnostic message")

nmap("<leader>uv", function()
  local config = vim.diagnostic.config() or {}
  local virtual_lines = not config.virtual_lines
  vim.diagnostic.config({ virtual_lines = virtual_lines })
end, "Toggle virtual_lines for diagnostics")

-- Keymaps for easier work with messages
nmap("<leader>mv", "<cmd>messages<cr>", "[m]essages [v]iew")
nmap("<leader>mc", "<cmd>messages clear<cr>", "[m]essages [c]lear")
nmap("<leader>mt", function()
  vim.cmd.tabnew()
  vim.cmd("put =execute('messages')")
end, "Open [m]essages in new [t]ab")

vim.keymap.set({"o", "x"}, "O", function()
  local small = require("various-textobjs.config.config").config.forwardLooking.small
  local core = require("various-textobjs.charwise-core")
  local row, _, endCol = core.getTextobjPos("().([[{(])", "inner", small)
  core.selectFromCursorTo({ row, endCol }, small)
end, {desc = "toNextOpeningBracket textobj"})
