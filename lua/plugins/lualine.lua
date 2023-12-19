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
    require("lualine").setup({
      options = {
        theme = "powerline",
      },
      sections = {
        lualine_a = {
          function()
            return mode_map[vim.api.nvim_get_mode().mode] or "__"
          end,
        },
        lualine_x = { function() return codeium_status() end, "encoding", "fileformat", "filetype" },
      },
    })
  end,
}
