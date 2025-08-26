return {
  "kevinhwang91/nvim-bqf",
  ft = { "qf" },
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
