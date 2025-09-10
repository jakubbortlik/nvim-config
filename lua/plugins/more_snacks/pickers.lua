return {
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
      confirm = "close",
      win = {
        list = { keys = { ["<c-t>"] = "tab" } },
        preview = { wo = { wrap = false } },
      },
    },
    select = {
      layout = { preset = "vertical" },
      win = {
        list = {
          keys = {
            ["dd"] = { "delete_files", mode = { "i", "n" } },
          },
        },
        input = {
          keys = {
            ["<m-u>"] = { "delete_file", mode = { "i", "n" } },
          },
        },
        preview = { enabled = true, minimal = true },
      },
    },
    registers = {
      pattern = "reg:",
      win = {
        input = {
          keys = {
            ["<c-cr>"] = { "put_register", mode = { "n", "i" }, desc = "put, close" },
            ["<s-cr>"] = { "put_register_before", mode = { "n", "i" }, desc = "put before, close" },
            ["<C-'>"] = { "use_register", mode = { "i", "n" } },
            ["<C-g>"] = { "toggle_reg", mode = { "i", "n" } },
          },
        },
      },
      matcher = { smartcase = false },
      actions = {
        put_register = function(picker, item, action)
          ---@cast action snacks.picker.yank.Action
          picker:norm(function()
            if item then
              picker:close()
              if not vim.bo.modifiable then
                Snacks.notify("Buffer is not modifiable", { level = "error" })
                return
              end
              local command = action and action.field == "before" and "P" or "p"
              vim.fn.feedkeys('"' .. item.reg .. command)
            end
          end)
        end,
        put_register_before = { action = "put_register", field = "before" },
        use_register = function(picker, item, action)
          picker:norm(function()
            picker:close()
            local pattern = (picker.finder.filter.pattern):gsub("reg:", "")
            pattern = #pattern == 1 and pattern or item and item.reg or ""
            if action and action.field == "insert" then
              vim.fn.feedkeys('i' .. pattern, "nt")
            else
              vim.fn.feedkeys('"' .. pattern, "nt")
            end
          end)
        end,
        use_register_insert = { action = "use_register", field = "insert" },
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
    delete_file = function(picker, item)
      local selected = next(picker:selected()) and picker:selected() or { item }
      for _, sel in ipairs(selected) do
        if sel and sel.item and sel.item.file then
          local bufnr = vim.fn.bufnr(sel.item.file)
          if bufnr ~= -1 then
            vim.api.nvim_buf_delete(bufnr, { force = true })
          end
          os.remove(sel.item.file)
        end
        for i, item_ in ipairs(picker.finder.items) do
          if item_.idx == sel.idx then
            table.remove(picker.finder.items, i)
          end
        end
      end
      if #picker.finder.items == 0 then
        picker:close()
      end
      picker.list:set_selected()
    end,
  },
}
