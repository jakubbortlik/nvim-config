vim.api.nvim_create_autocmd({ "Filetype" }, {
  callback = function(event)
    local ignored_fts = {
      "snacks_notif",
      "snacks_input",
      "prompt",
    }

    if vim.tbl_contains(ignored_fts, event.match) then
      return
    end

    -- make sure nvim-treesitter is loaded
    local ok, nvim_treesitter = pcall(require, "nvim-treesitter")

    -- no nvim-treesitter, maybe fresh install
    if not ok then
      return
    end

    if
      vim.list_contains(
        nvim_treesitter.get_installed(),
        vim.treesitter.language.get_lang(event.match)
      )
    then
      vim.treesitter.start(event.buf)
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end
  end,
})

local M = {
  ---@module 'lazy'
  ---@type LazySpec
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    dependencies = {
      "LiadOz/nvim-dap-repl-highlights",
    },
    config = function(_, _)
      local ensure_installed = {
        "bash",
        "c",
        "cpp",
        "dap_repl",
        "dockerfile",
        "gitcommit",
        "gitignore",
        "git_rebase",
        "go",
        "html",
        "java",
        "javascript",
        "json",
        "latex",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "proto",
        "python",
        "r",
        "regex",
        "query",
        "sql",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      }

      -- make sure nvim-treesitter can load
      local ok, nvim_treesitter = pcall(require, "nvim-treesitter")

      -- no nvim-treesitter, maybe fresh install
      if not ok then
        return
      end

      nvim_treesitter.install(ensure_installed)

      -- This is required for the dap_repl parser to be installable
      require("nvim-dap-repl-highlights").setup()
    end,
  },

  ---@module 'lazy'
  ---@type LazySpec
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    branch = "main",
    keys = {
      {
        "[i",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous(
            "@conditional.inner",
            "textobjects"
          )
        end,
        desc = "prev conditional",
        mode = { "n", "x", "o" },
      },
      {
        "]i",
        function()
          require("nvim-treesitter-textobjects.move").goto_next("@conditional.inner", "textobjects")
        end,
        desc = "next conditional",
        mode = { "n", "x", "o" },
      },
      {
        "[m",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start(
            "@function.outer",
            "textobjects"
          )
        end,
        desc = "prev function",
        mode = { "n", "x", "o" },
      },
      {
        "]m",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start(
            "@function.outer",
            "textobjects"
          )
        end,
        desc = "next function",
        mode = { "n", "x", "o" },
      },
      {
        "[[",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start(
            "@class.outer",
            "textobjects"
          )
        end,
        desc = "prev class",
        mode = { "n", "x", "o" },
      },
      {
        "]]",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
        end,
        desc = "next class",
        mode = { "n", "x", "o" },
      },
      {
        "[]",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end(
            "@class.outer",
            "textobjects"
          )
        end,
        desc = "prev class end",
        mode = { "n", "x", "o" },
      },
      {
        "][",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
        end,
        desc = "next class end",
        mode = { "n", "x", "o" },
      },
      {
        "[M",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end(
            "@function.outer",
            "textobjects"
          )
        end,
        desc = "prev function end",
        mode = { "n", "x", "o" },
      },
      {
        "]M",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end(
            "@function.outer",
            "textobjects"
          )
        end,
        desc = "next function end",
        mode = { "n", "x", "o" },
      },
      {
        "[a",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start(
            "@parameter.outer",
            "textobjects"
          )
        end,
        desc = "prev argument",
        mode = { "n", "x", "o" },
      },
      {
        "]a",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start(
            "@parameter.outer",
            "textobjects"
          )
        end,
        desc = "next argument",
        mode = { "n", "x", "o" },
      },
      {
        "[A",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end(
            "@parameter.outer",
            "textobjects"
          )
        end,
        desc = "prev argument end",
        mode = { "n", "x", "o" },
      },
      {
        "]A",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end(
            "@parameter.outer",
            "textobjects"
          )
        end,
        desc = "next argument end",
        mode = { "n", "x", "o" },
      },
      {
        "[o",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start(
            "@loop.outer",
            "textobjects"
          )
        end,
        desc = "prev loop",
        mode = { "n", "x", "o" },
      },
      {
        "]o",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@loop.outer", "textobjects")
        end,
        desc = "next loop",
        mode = { "n", "x", "o" },
      },
      {
        "[S",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start(
            "@block.outer",
            "textobjects"
          )
        end,
        desc = "prev block",
        mode = { "n", "x", "o" },
      },
      {
        "]S",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@block.outer", "textobjects")
        end,
        desc = "next block",
        mode = { "n", "x", "o" },
      },
      {
        "<leader>[a",
        function()
          require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
        end,
        desc = "swap next argument",
      },
      {
        "<leader>]a",
        function()
          require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
        end,
        desc = "swap prev argument",
      },
    },

    opts = {
      select = {
        lookahead = true, -- Automatically jump forward to textobjects
        selection_modes = {
          ["@parameter.outer"] = "v", -- charwise
          ["@function.outer"] = "V", -- linewise
          ["@class.outer"] = "V",
          ["@loop.outer"] = "V",
          ["@loop.inner"] = "V",
        },
      },
      move = {
        set_jumps = true,
        disable = { "help" },
      },
    },
  },
}

-- Use the capture groups defined in `textobjects.scm`
local keymaps = {
  ["aa"] = {
    query = "@parameter.outer",
    group = "textobjects",
    desc = "Select outer parameter region",
  },
  ["ia"] = {
    query = "@parameter.inner",
    group = "textobjects",
    desc = "Select inner parameter region",
  },
  ["af"] = {
    query = "@function.outer",
    group = "textobjects",
    desc = "Select outer function region",
  },
  ["if"] = {
    query = "@function.inner",
    group = "textobjects",
    desc = "Select inner function region",
  },
  ["ac"] = { query = "@class.outer", group = "textobjects", desc = "Select outer class region" },
  ["ic"] = { query = "@class.inner", group = "textobjects", desc = "Select inner class region" },
  ["aC"] = { query = "@codeblock.outer", group = "textobjects", desc = "Select outer codeblock" },
  ["iC"] = { query = "@codeblock.inner", group = "textobjects", desc = "Select inner codeblock" },
  ["aP"] = {
    query = "@parameter.outer",
    group = "textobjects",
    desc = "Select outer parameter region",
  },
  ["iP"] = {
    query = "@parameter.inner",
    group = "textobjects",
    desc = "Select inner parameter region",
  },
  ["aI"] = {
    query = "@conditional.outer",
    group = "textobjects",
    desc = "Select outer conditional region",
  },
  ["iI"] = {
    query = "@conditional.inner",
    group = "textobjects",
    desc = "Select inner conditional region",
  },
  ["al"] = { query = "@loop.outer", group = "textobjects", desc = "Select outer loop region" },
  ["il"] = { query = "@loop.inner", group = "textobjects", desc = "Select inner loop region" },
  ["at"] = { query = "@comment.outer", group = "textobjects", desc = "Select outer comment region" },
  ["ae"] = { query = "@emphasis.outer", group = "textobjects", desc = "Select emphasis" },
  ["ie"] = { query = "@emphasis.inner", group = "textobjects", desc = "Select emphasis content" },
  ["it"] = { query = "@comment.inner", group = "textobjects", desc = "Select inner comment region" },
  ["as"] = { query = "@local.scope", group = "locals", desc = "Select local scope" },
}

for keys, opts in pairs(keymaps) do
  vim.keymap.set({ "x", "o" }, keys, function()
    require("nvim-treesitter-textobjects.select").select_textobject(opts.query, "textobjects")
  end, { desc = opts.desc })
end

return M
