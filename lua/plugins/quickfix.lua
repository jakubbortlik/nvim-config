return {
  "kevinhwang91/nvim-bqf",
  event = { "QuickFixCmdPost" },
  dependencies = { {
    "junegunn/fzf",
    build = ":call fzf#install()"
  } },
  config = function()
    require("bqf").setup({
      preview = {
        auto_preview = false,
      }
    })
  end
}
