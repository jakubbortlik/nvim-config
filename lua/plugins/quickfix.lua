return {
  "kevinhwang91/nvim-bqf",
  ft = { "qf" },
  dependencies = { {
    "junegunn/fzf",
    build = ":call fzf#install()",
  } },
  opts = {
    preview = {
      auto_preview = false,
    },
  },
}
