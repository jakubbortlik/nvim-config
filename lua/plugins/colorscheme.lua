return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = true,
        background = {
          dark = "wave",
          light = "lotus",
        },
        colors = {
          theme = {
            wave = {
              ui = {
                bg = "none",
                bg_p1 = "#161616",
                bg_p2 = "#161616",
              },
              diff = {
                add = "#182015",
                change = "#151527",
              }
            },
            all = { ui = { bg_gutter = "none" }, },
          },
        },
        overrides = function(colors)
          local theme = colors.theme
          return {
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
            WinSeparator = { fg = theme.ui.nontext },
            IBLIndent = { bg="NONE", fg="#1a1a1a", nocombine=true },
            ["@type.builtin.python"] = { fg = "#cc4dcc" },
            QuickFixLine = { link = "WarningMsg" },
            Substitute = { bg="#c34043", fg="#000000"},
            EndOfBuffer = { link = "NonText" },

            -- Save a hlgroup with dark background and dimmed foreground
            -- so that you can use it where your still want darker windows.
            -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },  -- add `blend = vim.o.pumblend` to enable transparency
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
          }
        end,
      })
      vim.cmd.colorscheme("kanagawa")
    end,
  },
}
