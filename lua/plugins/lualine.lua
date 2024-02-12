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
