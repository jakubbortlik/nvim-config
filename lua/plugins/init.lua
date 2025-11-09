return {
  -- Plugins for enhanced editing
  "tpope/vim-repeat", -- Repeat other plugins with . command
  {
    "tpope/vim-capslock",
    keys = {
      { "<C-G>c", mode = "i", desc = "Temporarily toggle caps lock" },
      { "gC", mode = "n", desc = "Toggle caps lock" },
    },
  },
  "tpope/vim-unimpaired", -- Pairs of handy bracket mappings
  {
    "jakubbortlik/vim-keymaps", -- Switch keyboard layouts
    keys = {
      { "ckj", desc = "Next keymap" },
      { "ckk", desc = "Previous keymap" },
      { "ckl", desc = "Show keymaps" },
      { mode = { "i", "c" }, "<C-k><C-j>", desc = "Next keymap" },
      { mode = { "i", "c" }, "<C-k><C-k>", desc = "Previous keymap" },
      { mode = { "i", "c" }, "<C-k><C-l>", desc = "Show keymaps" },
    },
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    lazy = false,
    opts = { keymaps = { useDefaults = true, disabledDefaults = { "gw", "gc" } } },
  },

  -- Navigation
  {
    "christoomey/vim-tmux-navigator", -- Navigate easily in vim and tmux
    cmd = {
      "TmuxNavigateDown",
      "TmuxNavigateLeft",
      "TmuxNavigatePrevious",
      "TmuxNavigateRight",
      "TmuxNavigateUp",
    },
  },

  -- Unicode tables and digraphs expansion
  {
    "chrisbra/unicode.vim",
    config = function()
      vim.g.Unicode_no_default_mappings = true
    end,
    keys = {
      { "ga", "<Plug>(UnicodeGA)", mode = "n", desc = "Get detailed Unicode info" },
      {
        "<C-x><C-g>",
        "<Plug>(DigraphComplete)",
        mode = "i",
        desc = "Complete Digraph before cursor",
      },
    },
    cmd = "UnicodeTable",
  },
  {
    "m-demare/hlargs.nvim",
    config = function()
      require("hlargs").setup({
        color = "#5fafff",
        excluded_argnames = {
          declarations = {
            python = { "self", "cls" },
            lua = { "self" },
          },
          usages = {
            python = { "self", "cls" },
            lua = { "self" },
          },
        },
      })
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    opts = {
      show_in_active_only = true,
      set_hightlights = true,
      hide_if_all_visible = true,
      handle = {
        blend = 15,
        highlight = "Search",
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      enabled = true,
      indent = {
        char = "│",
        highlight = { "IBLIndent" },
      },
      scope = {
        show_start = false,
        show_end = false,
      },
    },
  },

  { dir = "~/projects/vim-phxstm", ft = "phxstm" },
}
