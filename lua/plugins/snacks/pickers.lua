local M = {}

M.default_opts = {
  enabled = true,
  win = {
    input = {
      keys = {
        ["<C-j>"] = { "history_forward", mode = { "i", "n" } },
        ["<C-k>"] = { "history_back", mode = { "i", "n" } },
        ["<M-h>"] = { "tmux_navigate_left", mode = { "i", "n" } },
        ["<M-l>"] = { "tmux_navigate_right", mode = { "i", "n" } },
        ["<M-j>"] = { "tmux_navigate_down", mode = { "i", "n" } },
        ["<M-k>"] = { "tmux_navigate_up", mode = { "i", "n" } },
        ["<C-h>"] = { "toggle_hidden", mode = { "i", "n" } },
      },
    },
  },
  actions = {
    tmux_navigate = function(_, _, action)
      local directions = { ["left"] = "-L", ["right"] = "-R", ["down"] = "-D", ["up"] = "-U" }
      vim.system({ "tmux", "select-pane", directions[action.field] })
    end,
    tmux_navigate_left = { action = "tmux_navigate", field = "left" },
    tmux_navigate_right = { action = "tmux_navigate", field = "right" },
    tmux_navigate_down = { action = "tmux_navigate", field = "down" },
    tmux_navigate_up = { action = "tmux_navigate", field = "up" },
  },
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
      if item then
        local value = item[action.field] or item.data or item.text
        local after = action and action.field == "after" or false
        if not vim.o.modifiable then
          vim.print("Buffer is not modifiable")
          return
        end
        vim.api.nvim_put(vim.split(value, "\n"), "l", after, true)
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
