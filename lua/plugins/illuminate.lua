local should_enable = function(bufnr)
  local ext = vim.api.nvim_buf_get_name(bufnr):match("%.([^%.]+)$")
  local extensions_denylist = {
    "mp3",
    "mp4",
    "wav",
    "flac",
    "ogg",
  }
  return not vim.tbl_contains(extensions_denylist, ext)
end

local M = {
  "RRethy/vim-illuminate",
  opts = {
    delay = 0,
    providers = { "lsp", "treesitter", "regex" },
    filetypes_denylist = {
      "codecompanion",
      "csv",
      "fugitive",
      "json",
      "phxstm",
      "text",
      "tsv",
    },
    large_file_cutoff = 2000,
    large_file_overrides = {
      providers = { "regex" },
      should_enable = should_enable,
    },
    should_enable = should_enable,
  },
  config = function(_, opts)
    require("illuminate").configure(opts)
  end,
}

return M
