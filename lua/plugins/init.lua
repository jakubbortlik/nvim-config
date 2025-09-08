return {
  -- Plugins for enhanced editing
  "tpope/vim-repeat", -- Repeat other plugins with . command
  {
    "tpope/vim-capslock",
    keys = {
      { "<C-G>c", mode = "i", desc = "Temporarily toggle caps lock" },
      { "gC",     mode = "n", desc = "Toggle caps lock" },
    },
  },
  {
    "tpope/vim-speeddating", -- Let <C-A>, <C-X> work on dates properly
    keys = {
      { "<C-a>", mode = { "n", "v" }, desc = "Increment component under cursor" },
      { "<C-x>", mode = { "n", "v" }, desc = "Decrement component under cursor" },
    },
    cmd = "SpeedDatingFormat",
  },
  "tpope/vim-surround",    -- Parentheses, brackets, quotes, and more
  "tpope/vim-unimpaired",  -- Pairs of handy bracket mappings
  {
    "vim-scripts/VisIncr", -- In/decreasing columns of Ns and dates
    cmd = {
      "I",
      "IA",
      "IB",
      "ID",
      "IDMY",
      "IIB",
      "IIO",
      "IIPOW",
      "IIR",
      "IIX",
      "IM",
      "IMDY",
      "IO",
      "IPOW",
      "IR",
      "IX",
      "IYMD",
    },
  },
  {
    "jakubbortlik/vim-keymaps", -- Switch keyboard layouts
    keys = {
      { "ckj",      desc = "Next keymap" },
      { "ckk",      desc = "Previous keymap" },
      { "ckl",      desc = "Show keymaps" },
      { mode = "i", "<C-k><C-j>",            desc = "Next keymap" },
      { mode = "i", "<C-k><C-k>",            desc = "Previous keymap" },
      { mode = "i", "<C-k><C-l>",            desc = "Show keymaps" },
    },
  },
  {
    "tversteeg/registers.nvim",
    name = "registers",
    keys = {
      { '"',     mode = { "n", "v" } },
      { "<C-R>", mode = "i" },
    },
    cmd = "Registers",
    opts = {
      show_empty = false,
      window = { border = vim.o.winborder },
    }
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    lazy = false,
    opts = { keymaps = { useDefaults = true, disabledDefaults = { "gw", "gc" }} },
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
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      label = { after = false, before = { 0, 0 } },
      modes = { search = { enabled = false, highlight = { backdrop = true } } },
    },
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x" }, function() require("flash").jump() end,              desc = "Flash" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },

  -- Language specific plugins
  {
    "alunny/pegjs-vim",
    ft = "pegjs",
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
    dependencies = {
      "kevinhwang91/nvim-hlslens",
      config = function()
        require("scrollbar.handlers.search").setup()
      end
    },
    config = function()
      require("scrollbar").setup({
        show_in_active_only = true,
        set_hightlights = true,
        hide_if_all_visible = true,
        handle = {
          blend = 15,
          highlight = "Search",
        },
      })
    end,
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
