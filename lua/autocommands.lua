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
    vim.keymap.set("n", "<leader>ra", "<cmd>tab vnew term://python "..vim.fn.expand("%:p").."<cr>", { desc = "Run buffer with Python" })
    vim.keymap.set("n", "<leader>rA", ":tab vnew term://python "..vim.fn.expand("%:p").." ", { desc = "Start cmdline to run buffer with Python" })
  end
})

local editor_id = vim.api.nvim_create_augroup("Editor", {
  clear = true
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = editor_id,
  callback  = function()
    if vim.fn.has("nvim-0.13") == 1 then
      vim.hl.hl_op({higroup="IncSearch", timeout=300})
    else
      vim.hl.on_yank({higroup="IncSearch", timeout=300})
    end
  end
})

if vim.fn.has("nvim-0.13") == 1 then
  vim.api.nvim_create_autocmd("TextPutPost", {
    group = editor_id,
    callback  = function()
      vim.hl.hl_op({higroup="DiffAdd", timeout=300})
    end
  })
end

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
  pattern = [[\(COMMIT\|DESCRIBE\)_EDITMSG]],
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
    if fugitive_bufnr ~= -1 and vim.fn.bufwinid(fugitive_bufnr) ~= -1 then
      vim.api.nvim_buf_call(fugitive_bufnr, function()
        vim.cmd("G")
      end)
    end
    vim.cmd("set autoread | checktime")
  end
})

vim.api.nvim_create_autocmd("OptionSet", {
  group = editor_id,
  pattern = "keymap",
  callback = function()
    local keymap = vim.v.option_new
    if keymap == "czech" then
      vim.opt.spelllang = "cs"
    elseif keymap == "" or keymap == "ipa" then
      vim.opt.spelllang = "en_us"
    elseif keymap == "russian" then
      vim.opt.spelllang = "ru"
    end
  end,
})

local last_auto_updated = os.time()
local gitlab = vim.api.nvim_create_augroup("Gitlab", {})
vim.api.nvim_create_autocmd("BufEnter", {
  group = gitlab,
  callback = function()
    local last_updated = require("gitlab.state").discussion_tree.last_updated
    local updating = require("gitlab.state").discussion_tree.updating
    updating = type(updating) == "number" and updating or 0
    last_updated = last_updated and last_updated or 0
    if vim.bo.filetype == "gitlab" and (os.time() - math.max(last_auto_updated, last_updated) > 60) and not (updating > 0) then
      last_auto_updated = os.time()
      require("gitlab").refresh_data()
    end
  end,
  desc = "Refresh data when entering discussion tree"
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "metadata.csv",
  callback = function()
    vim.bo.filetype = "tsv"
  end,
})

-- Change cursor color when recording a macro
vim.api.nvim_set_hl(0, "MacroCursor", { fg = "#ffffff", bg = "#ff5555" }) -- red background
local macro_cursor = "n-v-c:block-MacroCursor,i-ci-ve:ver25-MacroCursor,r-cr:hor20-MacroCursor,o:hor50-MacroCursor,"
.. "a:blinkwait700-blinkoff400-blinkon250-MacroCursor/MacroCursor,sm:block-blinkwait175-blinkoff150-blinkon175-MacroCursor"
local rec_group = vim.api.nvim_create_augroup("MacroRecordingCursor", { clear = true })
vim.api.nvim_create_autocmd("RecordingEnter", {
  group = rec_group,
  callback = function()
    vim.g.guicursor_backup = vim.o.guicursor
    vim.o.guicursor = macro_cursor
  end,
})
vim.api.nvim_create_autocmd("RecordingLeave", {
  group = rec_group,
  callback = function()
    vim.o.guicursor = vim.g.guicursor_backup
  end,
})

-- Find a regular editing window in the current tabpage.
-- This skips terminal/help/quickfix/prompt/nofile buffers.
local function find_edit_window()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "" then
      return win
    end
  end
end

-- Parse a filepath starting at the WORD under the cursor.
-- Supports:
--   <path>
--   <path>:<line>
--   <path>:<line>-<range>
local function resolve_filepath_at_cursor(buf)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0)) -- row 1-based, col 0-based

  -- 1. Get current line
  local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]
  if not line then
    return nil
  end

  -- 2. Find WORD start in current line
  local before = line:sub(1, col + 1)
  local word_start = before:find("%S+$")
  if not word_start then
    return nil
  end

  -- 3. Cut everything before WORD start
  local text = line:sub(word_start)

  -- 4. Append subsequent lines to reconstruct a wrapped filepath.
  -- Wrapping is assumed to end at the first whitespace.
  local cur_row = row
  while not text:find("%s") do
    local next_line = vim.api.nvim_buf_get_lines(buf, cur_row, cur_row + 1, false)[1]
    if not next_line or next_line == "" then
      break
    end
    -- Strip leading whitespace from wrapped lines; continuation lines may
    -- be arbitrarily indented.
    text = text .. next_line:gsub("^%s+", "")
    cur_row = cur_row + 1
  end

  -- 5. Clamp again to a single WORD (cut everything after it)
  local word = text:match("^(%S+)")
  if not word then
    return nil
  end

  -- 6. Probe for a <path>:<line> suffix and return early if matched
  local path, lnum = word:match("^([%w%._%-/@~%+]+):(%d+)")
  if path then
    return path, tonumber(lnum)
  end

  -- 7. Extract a standalone filepath prefix (no line number). Allows '~'
  -- suffixes commonly used for backup files.
  path = word:match("^[%w%._%-/@~%+]+[%w~]")
  if path then
    return path
  end

  -- NOTE: This is a heuristic approach and has edge cases. It cannot
  -- always distinguish wrapped file paths from prose. Example:
  --   src/index.ts.
  --   Some text here ...
  -- In practice this is rare, as LLM output tends to introduce line
  -- breaks or whitespac frequently.

  return nil
end

-- Attempts to resolve a (possibly line-wrapped) filepath at the cursor and
-- open it in a suitable window, optionally jumping to a line number.
-- Falls back to the default <C-]> behavior if no file reference can be resolved.
local function goto_file_at_cursor(buf)
  local path, lnum = resolve_filepath_at_cursor(buf)
  path = path and path:gsub("^@", "") or nil

  -- 1. If no readable path, fall back to default behavior
  if not path or vim.fn.filereadable(path) ~= 1 then
    return vim.cmd("normal! <C-]>")
  end

  -- 2. Try to reuse an existing regular window
  local target_win = find_edit_window()

  -- 3. If none exists, open a new window (left of the LLM buffer)
  if not target_win then
    vim.cmd("leftabove vsplit")
    target_win = vim.api.nvim_get_current_win()
  else
    vim.api.nvim_set_current_win(target_win)
  end

  vim.cmd("edit " .. vim.fn.fnameescape(path))

  if lnum then
    vim.api.nvim_win_set_cursor(target_win, { lnum, 0 })
    vim.cmd("normal! zz")
  end
end

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function(ctx)
    vim.keymap.set("n", "<C-]>", function()
      goto_file_at_cursor(ctx.buf)
    end, { buffer = ctx.buf })
  end,
})
