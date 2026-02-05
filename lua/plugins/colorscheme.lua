return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      require("kanagawa").setup({
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
          local c = require("kanagawa.lib.color")

          return {
            NormalFloat = { bg = "none" },
            FloatBorder = { link = "BlinkCmpMenuBorder" },
            FloatTitle = { bg = "none" },
            WinSeparator = { fg = theme.ui.nontext },
            IBLIndent = { bg="NONE", fg="#1a1a1a", nocombine=true },
            ["@type.builtin.python"] = { fg = "#cc4dcc" },
            QuickFixLine = { link = "WarningMsg" },
            Substitute = { bg="#c34043", fg="#000000"},
            EndOfBuffer = { link = "NonText" },
            Comment = { fg="#929189"},
            MinuetVirtualText = { fg = "#cc8080" },
            SpellCap = {undercurl=true, sp="#ff9e3b"},
            SpellLocal = {undercurl=true, sp="#7e9cd8"},
            SpellRare = {undercurl=true, sp="#98bb6c"},
            NotificationInfo = { link = "MsgArea" },
            NotificationWarning = { link = "WarningMsg" },
            NotificationError = { link = "ErrorMsg" },
            ['@string.special.url'] = { underline = true, undercurl = false },
            -- Neogit
            NeogitDiffDelete = { bg = c(theme.diff.delete):brighten(-0.5, theme.diff.delete):to_hex(), fg = c(theme.diff.delete):brighten(0.6, theme.diff.delete):to_hex() },
            NeogitDiffDeleteCursor = { bg = c(theme.diff.delete):brighten(-0.5, theme.diff.delete):to_hex() },
            NeogitDiffDeleteHighlight = { bg = theme.diff.delete, fg = c(theme.diff.delete):brighten(0.8, theme.diff.delete):to_hex()  },
            --
            NeogitDiffAdd = { bg = c(theme.diff.add):brighten(-0.5, theme.diff.add):to_hex(), fg = c(theme.diff.add):brighten(0.6, theme.diff.add):to_hex() },
            NeogitDiffAddCursor = { bg = c(theme.diff.add):brighten(-0.5, theme.diff.add):to_hex() },
            NeogitDiffAddHighlight = { bg = theme.diff.add, fg = c(theme.diff.add):brighten(0.8, theme.diff.add):to_hex() },
            --
            NeogitDiffContext = { bg = theme.ui.bg, fg = theme.ui.fg_dim },
            NeogitDiffContextCursor = { bg = c(theme.diff.change):brighten(-0.5, theme.diff.change):to_hex() },
            NeogitDiffContextHighlight = { bg = theme.ui.bg_p1, fg = theme.ui.fg },
            --
            NeogitHunkHeader = { fg = theme.syn.fun },
            NeogitHunkHeaderHighlight = { fg = theme.syn.constant, bg = theme.diff.change },
            NeogitHunkHeadercursor = { fg = theme.syn.constant, bg = theme.diff.change },
            --
            NeogitChangeModified           = { fg = theme.vcs.changed, italic = true },
            NeogitChangeAdded              = { fg = theme.vcs.added, italic = true },
            NeogitChangeDeleted            = { fg = theme.vcs.removed, italic = true },
            NeogitChangeRenamed            = { fg = theme.syn.parameter, italic = true },
            NeogitChangeUpdated            = { fg = theme.syn.constant, italic = true },
            NeogitChangeCopied             = { fg = theme.syn.fun, italic = true },
            NeogitChangeUnmerged           = { fg = theme.syn.identifier, italic = true },
            NeogitChangeNewFile            = { fg = theme.syn.string, italic = true },
            NeogitSectionHeader            = { fg = theme.syn.preproc },

            DiffviewFilePanelSelected = { link = "WarningMsg" },

            -- Save a hlgroup with dark background and dimmed foreground
            -- so that you can use it where your still want darker windows.
            -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            BlinkCmpMenuBorder = { bg = theme.ui.bg },
            BlinkCmpScrollBarThumb = { bg = theme.ui.bg_search },
            BlinkCmpMenuSelection = { fg = "NONE", bg = theme.ui.bg_search },

            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg },
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_search },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
          }
        end,
      })
      vim.cmd.colorscheme("kanagawa")
    end,
  },
}
