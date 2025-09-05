local nmap = require("utils").nmap

return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        nmap("]g", function()
          vim.schedule(function()
            gs.nav_hunk("next", { wrap = false, greedy = false })
          end)
        end, "Navigate to next unstaged hunk")

        nmap("[g", function()
          vim.schedule(function()
            gs.nav_hunk("prev", { wrap = false, greedy = false })
          end)
        end, "Navigate to prev unstaged hunk")

        -- Navigation
        nmap("]G", function()
          vim.schedule(function()
            gs.nav_hunk("next", { wrap = false, greedy = false, target = "all" })
          end)
        end, "Navigate to next [h]unk")

        nmap("[G", function()
          vim.schedule(function()
            gs.nav_hunk("prev", { wrap = false, greedy = false, target = "all" })
          end)
        end, "Navigate to prev [h]unk")

        local wk = require("which-key")
        -- Register normal mode keymaps
        wk.add({
          { "<leader>h",  group = "git [h]unks" },
          { "<leader>hs", gs.stage_hunk,        desc = "[s]tage" },
          { "<leader>hr", gs.reset_hunk,        desc = "[r]eset" },
          { "<leader>hS", gs.stage_buffer,      desc = "[S]tage buffer" },
          { "<leader>hu", gs.undo_stage_hunk,   desc = "[u]ndo stage" },
          { "<leader>hR", gs.reset_buffer,      desc = "[R]eset buffer" },
          { "<leader>hp", gs.preview_hunk,      desc = "[p]review" },
          { "<leader>hb", function() gs.blame_line({ full = true }) end, desc = "[b]lame line", },
          { "<leader>ht", gs.toggle_current_line_blame, desc = "[t]oggle line blame" },
          { "<leader>hd", gs.diffthis,                  desc = "[d]iff this" },
          { "<leader>hD", function() gs.diffthis("~") end, desc = "[D]iff this against '~'", },
          { "<leader>hT", gs.toggle_deleted, desc = "[T]oggle deleted" },
          {
            mode = { "v" },
            { "<leader>h", group = "git [h]unks" },
            { "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, desc = "[s]tage", },
            { "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, desc = "[r]eset", },
          },
        })

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
      end,
    })
  end,
}
