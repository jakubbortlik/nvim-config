local M = {}

M.default_opts = {
  enabled = true,
  sources = {
    buffers = {
      auto_confirm = true,
      current = false,
      sort_lastused = false,
      win = {
        input = {
          keys = {
            ["<M-u>"] = { "bufdelete", mode = { "i", "n" } },
            ["<C-x>"] = { "split", mode = { "i", "n" } },
          },
        },
      },
    },
    explorer = {
      win = {
        list = { keys = { ["<c-t>"] = "tab" } },
        preview = { wo = { wrap = false } },
      },
    },
  },
  win = {
    input = {
      keys = {
        ["<C-j>"] = { "history_forward", mode = { "i", "n" } },
        ["<C-k>"] = { "history_back", mode = { "i", "n" } },
        ["<M-h>"] = false,
        ["<C-h>"] = { "toggle_hidden", mode = { "i", "n" } },
        ["<C-x>"] = { "split", mode = { "i", "n" } },
        ["<M-r>"] = { "toggle_regex", mode = { "i", "n" } },
        ["<M-q>"] = { "loclist", mode = { "i", "n" } },
      },
    },
    -- Make file truncation consider window width.
    -- <https://github.com/folke/snacks.nvim/issues/1217#issuecomment-2661465574>
    list = {
      keys = {
        ["<M-h>"] = false,
        ["<M-q>"] = { "loclist", mode = { "i", "n" } },
      },
      on_buf = function(self)
        self:execute("calculate_file_truncate_width")
      end,
    },
    preview = {
      on_buf = function(self)
        self:execute("calculate_file_truncate_width")
      end,
      on_close = function(self)
        self:execute("calculate_file_truncate_width")
      end,
    },
  },
  actions = {
    calculate_file_truncate_width = function(self)
      local width = self.list.win:size().width
      self.opts.formatters.file.truncate = width - 6
    end,
  }
}

M.registers_opts = {
  pattern = "reg:",
  win = {
    input = {
      keys = {
        ["<C-CR>"] = { "put", mode = { "i", "n" } },
        ["<CR>"] = { "linewise_put_after", mode = { "i", "n" } },
        ["<S-CR>"] = { "linewise_put", mode = { "i", "n" } },
        ["<C-'>"] = { "use_register", mode = { "i", "n" } },
        ["<C-g>"] = { "toggle_reg", mode = { "i", "n" } },
      },
    },
  },
  layout = {
    preset = "vertical",
    layout = {
      backdrop = false,
      width = 0.5,
      min_width = 80,
      height = 0.8,
      min_height = 30,
      box = "vertical",
      border = "rounded",
      title = "{title} {live} {flags}",
      title_pos = "center",
      { win = "input", height = 1, border = "bottom" },
      { win = "list", border = "none" },
      { win = "preview", title = "{preview}", height = 6, border = "top" },
    },
  },
  matcher = { smartcase = false },
  format = function(item)
    local ret = {}
    ret[#ret + 1] = { " " }
    ret[#ret + 1] = { "[", "SnacksPickerDelim" }
    ret[#ret + 1] = {
      item.reg,
      string.match(item.reg, "[0-9]") and "Number" or string.match(item.reg, "[a-z]") and "String",
    }
    ret[#ret + 1] = { "]", "SnacksPickerDelim" }
    ret[#ret + 1] = { " " }
    local type = vim.fn.getregtype(item.reg)
    type = type == "v" and "c" or type == "V" and "l" or "b:" .. type:sub(2)
    ret[#ret + 1] = { type, "Comment" }
    ret[#ret + 1] = { " " }
    ret[#ret + 1] = { item.value }
    return ret
  end,
  actions = {
    linewise_put = function(picker, item, action)
      picker:close()
      if not vim.o.modifiable then
        vim.print("Buffer is not modifiable")
        return
      end
      if item then
        local after = action and action.field == "after"
        vim.api.nvim_put(vim.split(item.data, "\n"), "l", after, true)
      end
    end,
    linewise_put_after = { action = "linewise_put", field = "after" },
    use_register = function(picker, item)
      picker:close()
      local pattern = picker.finder.filter.pattern
      pattern = #pattern == 1 and pattern or item and item.reg or ""
      vim.defer_fn(function()
        vim.fn.feedkeys('"' .. pattern, "nt")
      end, 100)
    end,
    toggle_reg = function(picker)
      if string.match(picker.input.filter.pattern, "^reg:") then
        picker.input.filter.pattern = picker.input.filter.pattern:sub(5)
      else
        picker.input.filter.pattern = "reg:" .. picker.input.filter.pattern
      end
      picker.input:set()
      picker.input:update()
    end,
  },
}

return M
