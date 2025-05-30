local set_hl = vim.api.nvim_set_hl

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function ()
    set_hl(0, "ColorColumn", { link = "CursorLine" })
    set_hl(0, "@variable.builtin.python", { fg = "#e46876", italic = true })
    set_hl(0, "@variable.python", { link = "Identifier" })
    set_hl(0, "@parameter.python", { fg = "#5fafff" })
    set_hl(0, "@type.builtin.python", { fg = "#ff5fff" })
    set_hl(0, "@constant.builtin.python", { link = "Constant" })
    set_hl(0, "QuickFixLine", { link = "WarningMsg" })
    set_hl(0, "NeoTreeGitUntracked", { fg = "#76946a" })
    set_hl(0, "IBLIndent", { bg="NONE", fg="#1a1a1a", nocombine=true })
    set_hl(0, "MatchParen", { bg="#363646", fg="#ff9e3b" })
    set_hl(0, "CursorLine", { bg="#161616" })
    set_hl(0, "Substitute", { bg="#c34043", fg="#000000"})
    set_hl(0, "DiffAdd",  { bg="#182015" })
    set_hl(0, "DiffChange", { bg="#151525" })
    set_hl(0, "SnacksPickerListCursorLine", { link = "Cursorline" })
  end
})


return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = true,
        transparent = true,
        background = {
          dark = "wave",
          light = "lotus",
        },
        colors = {
          theme = { all = { ui = { bg_gutter = "none" }, }, },
        },
        overrides = function(colors)
          local theme = colors.theme
          return {
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
            TelescopeBorder = { bg = "none" },
            WinSeparator = { fg = theme.ui.nontext },

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
      vim.cmd.colorscheme("kanagawa-wave")
    end,
  },
}
