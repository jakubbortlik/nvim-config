-- Terminal autocommands
local term_id = vim.api.nvim_create_augroup("Terminal", {
  clear = true
})

-- always enter insert mode when switching to a terminal window
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
  group = term_id,
  pattern = { "term://*", "\\[dap-repl\\]" },
  callback = function()
    vim.cmd [[startinsert]]
  end
})
-- always leave insert mode when switching from a terminal window
vim.api.nvim_create_autocmd({ "BufWinLeave", "WinLeave" }, {
  group = term_id,
  pattern = { "term://*", "\\[dap-repl\\" },
  callback = function()
    vim.cmd [[stopinsert]]
  end
})
-- don't show line numbers in a terminal window
vim.api.nvim_create_autocmd({ "TermOpen" }, {
  group = term_id,
  pattern = { "term://*" },
  callback = function()
    vim.cmd [[setlocal listchars= nonumber norelativenumber]]
  end
})

local python_id = vim.api.nvim_create_augroup("Python", {
  clear = true
})
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
  group = python_id,
  pattern = { "*py" },
  callback = function()
    vim.keymap.set("n", "<leader>ra", "<cmd>vnew term://python "..vim.fn.expand("%:p").."<cr>", { desc = "Run current file with Python" })
    vim.keymap.set("n", "<leader>rr", ":vnew term://python "..vim.fn.expand("%:p").." ", { desc = "Run current file with Python" })
  end
})

local editor_id = vim.api.nvim_create_augroup("Editor", {
  clear = true
})
vim.api.nvim_create_autocmd({"TextYankPost"}, {
  group = editor_id,
  callback  = function()
    vim.highlight.on_yank({higroup="IncSearch", timeout=250})
  end
})
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  group = editor_id,
  callback = function()
    if not vim.bo.modifiable then
      local keymaps_to_delete = { "<P", "<p", ">p", "<s", "<s<ESC>", "cm", "cxc", "cx", "cxx", "cs", "cS" }
      for _, keymap in ipairs(keymaps_to_delete) do
          pcall(vim.keymap.del, "n", keymap)
      end
    end
  end
})

vim.api.nvim_create_autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  callback = function(args)
    if args.data ~= nil then
      if args.data.filetype ~= "help" then
        vim.wo.number = true
      elseif args.data.bufname:match("*.csv") then
        vim.wo.wrap = false
      end
    end
  end,
})
