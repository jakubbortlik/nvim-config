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
    vim.keymap.set("n", "<leader>ra", "<cmd>vnew term://python "..vim.fn.expand("%:p").."<cr>", { desc = "Run buffer with Python" })
    vim.keymap.set("n", "<leader>rA", ":vnew term://python "..vim.fn.expand("%:p").." ", { desc = "Start cmdline to run buffer with Python" })
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

local mappings = {}
vim.api.nvim_create_autocmd({"BufEnter"}, {
  group = editor_id,
  callback = function(_)
    if not vim.bo.modifiable then
      local keymaps_to_delete = { "<P", "<p", ">p", "<s", "<s<ESC>", "cxc", "cx", "cxx", "cs", "cS" }
      for _, keymap in ipairs(keymaps_to_delete) do
        local keymap_dict = vim.fn.maparg(keymap, "n", false, true)
        if keymap_dict["buffer"] == 0 then
          mappings[keymap] = keymap_dict
          pcall(vim.keymap.del, "n", keymap)
        end
      end
    elseif vim.bo.modifiable then
      for _, keymap_dict in pairs(mappings) do
        vim.keymap.set(
          "n",
          keymap_dict["lhs"],
          keymap_dict["rhs"],
          {
            noremap = keymap_dict["noremap"],
            nowait = keymap_dict["nowait"],
            silent = keymap_dict["silent"]
          }
        )
      end
    end
  end
})

vim.api.nvim_create_autocmd({"VimEnter"}, {
  group = editor_id,
  callback = function(_)
    local keymaps_to_delete = { "[CC", "]CC" }
    for _, keymap in ipairs(keymaps_to_delete) do
      pcall(vim.keymap.del, "n", keymap)
    end
  end
})

vim.api.nvim_create_autocmd('InsertEnter', {
  group = editor_id,
  pattern = "COMMIT_EDITMSG",
  callback = function()
    if vim.fn.line('.') == 1 and vim.fn.col('.') == 1 then
      vim.schedule(function()
        vim.fn.complete(1, {'build', 'chore', 'ci', 'docs', 'feat', 'fix', 'perf', 'refactor', 'revert', 'style', 'test'})
      end)
    end
  end
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'GitSignsChanged',
  callback = function()
    local fugitive_bufnr = vim.fn.bufnr("fugitive://")
    if fugitive_bufnr == -1 then
      return
    end
    vim.api.nvim_buf_call(fugitive_bufnr, function()
      vim.cmd("G")
    end)
  end
})
