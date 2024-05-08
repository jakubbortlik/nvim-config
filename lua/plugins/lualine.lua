local mode_map = {
  ["n"] = "NORMAL",
  ["no"] = "O-PENDING",
  ["nov"] = "O-PENDING",
  ["noV"] = "O-PENDING",
  ["no\22"] = "O-PENDING",
  ["niI"] = "(insert)",
  ["niR"] = "(replace)",
  ["niV"] = "(vreplace)",
  ["nt"] = "(TERMINAL)",
  ["ntT"] = "(terminal)",
  ["v"] = "VISUAL",
  ["vs"] = "(visual)",
  ["V"] = "V-LINE",
  ["Vs"] = "(visual)",
  ["\22"] = "V-BLOCK",
  ["\22s"] = "(v-block)",
  ["s"] = "SELECT",
  ["S"] = "S-LINE",
  ["\19"] = "S-BLOCK",
  ["i"] = "INSERT",
  ["ic"] = "INSERT",
  ["ix"] = "INSERT",
  ["R"] = "REPLACE",
  ["Rc"] = "REPLACE",
  ["Rx"] = "REPLACE",
  ["Rv"] = "V-REPLACE",
  ["Rvc"] = "V-REPLACE",
  ["Rvx"] = "V-REPLACE",
  ["c"] = "COMMAND",
  ["cv"] = "EX",
  ["ce"] = "EX",
  ["r"] = "REPLACE",
  ["rm"] = "MORE",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  ["t"] = "TERMINAL",
}

--- @param trunc_width number|nil trunctate when window width is less then trunc_width
--- @param trunc_len number truncate to trunc_len number of chars
--- @param hide_width number|nil hide component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '…' at end after truncation
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
  return function(str)
    local win_width = vim.fn.winwidth(0)
    if hide_width ~= nil and win_width < hide_width then return ''
    elseif trunc_width ~= nil then
      if win_width < trunc_width and #str > trunc_len then
        return str:sub(1, trunc_len) .. (no_ellipsis and '' or '…')
      end
    end
    return str
  end
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "Exafunction/codeium.vim" },
  config = function()
    local codeium_status = function()
      return "{…}" .. vim.api.nvim_call_function("codeium#GetStatusString", {})
    end
    local conditions = {
      window_wider_than = function(limit)
        if limit == nil then
          limit = 95
        end
        return vim.fn.winwidth(0) > limit
      end,
    }
    require("lualine").setup({
      options = {
        theme = "powerline",
      },
      sections = {
        lualine_a = {
          {
            function()
              if conditions.window_wider_than(115) then
                return mode_map[vim.api.nvim_get_mode().mode] or "__"
              else
                -- Abbreviate mode indicator
                return string.gsub(
                  mode_map[vim.api.nvim_get_mode().mode],
                  "(%a)%a+",
                  "%1"
                ) or "__"
              end
            end,
          },
          function() return vim.o.keymap end
        },
        lualine_b = {{'branch', fmt=trunc(150, 20, nil, false)}, 'diff', 'diagnostics'},
        lualine_c = {{'filename', path=1}},
        -- Show components only when window is wide enough
        lualine_x = {
          {
            function()
              return codeium_status()
            end,
            cond = function()
              return conditions.window_wider_than(95)
            end,
          },
          {
            "encoding",
            cond = function()
              return conditions.window_wider_than(120)
            end,
          },
          {
            "fileformat",
            cond = function()
              return conditions.window_wider_than(110)
            end,
          },
          {
            "filetype",
            cond = function()
              return conditions.window_wider_than(100)
            end,
          },
        },
      },
    })
  end,
}
