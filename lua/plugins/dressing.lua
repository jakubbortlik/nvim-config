return {
  "stevearc/dressing.nvim",
  opts = {
    select = {
      enabled = true,
      telescope = require('telescope.themes').get_dropdown({
        layout_config = {
          width = function(_, max_columns, _)
            return math.min(max_columns + 4, 180)
          end
        }
      })
    },
  },
}
