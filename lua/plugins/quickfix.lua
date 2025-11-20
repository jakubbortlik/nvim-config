return {
  "kevinhwang91/nvim-bqf",
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
