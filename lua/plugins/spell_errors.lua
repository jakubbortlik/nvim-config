return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        spell_errors = {
          finder = function(opts)
            local errors = {}
            local save_cursor = vim.api.nvim_win_get_cursor(0)
            local save_wrapscan = vim.o.wrapscan
            local save_spell = vim.o.spell
            local buf = vim.api.nvim_get_current_buf()
            local file = vim.api.nvim_buf_get_name(buf)

            local highlights = {
              caps = "Cap",
              bad = "Bad",
              ["local"] = "Local",
              rare = "Rare",
            }

            vim.o.spell = true

            -- Go to end of buffer to get misspelled word in first column of first line.
            -- This doesn't handle the corner case of a single character in buffer.
            vim.o.wrapscan = true
            vim.cmd("normal! G$")
            local last_pos = vim.api.nvim_win_get_cursor(0)
            vim.cmd('silent normal! ]s')
            vim.o.wrapscan = false

            while true do
              local pos = vim.api.nvim_win_get_cursor(0)

              -- Cursor didn't move
              if pos[1] == last_pos[1] and pos[2] == last_pos[2] then
                break
              end

              local word = vim.fn.expand('<cword>')
              local spell_info = vim.fn.spellbadword(word)

              -- Corner case for capitalization in first word of line
              if spell_info[1] == "" then
                for _, capture in ipairs(vim.treesitter.get_captures_at_cursor(0)) do
                  if capture == "spell" then
                    spell_info = { word, "caps" }
                    break
                  end
                end
              end

              if spell_info[1] ~= "" then
                errors[#errors + 1] = {
                  text = spell_info[1],
                  highlight = highlights[spell_info[2]],
                  type = string.sub(spell_info[2], 1, 1),
                  file = file,
                  buf = buf,
                  lnum = pos[1],
                  pos = pos,
                  end_pos = { pos[1], pos[2] + #spell_info[1] },
                }
              end

              last_pos = pos
              vim.cmd('silent normal! ]s')
            end

            -- Restore settings
            vim.o.wrapscan = save_wrapscan
            vim.o.spell = save_spell
            vim.api.nvim_win_set_cursor(0, save_cursor)
            return errors
          end,
          format = function(item)
            local ret = {} ---@type snacks.picker.Highlight[]
            ret[#ret + 1] = { item.text, "Spell" .. item.highlight }
            return ret
          end,
          win = {
            input = {
              keys = {
                ["<C-g>"] = { "toggle_type", mode = { "i", "n" } },
              },
            },
            preview = {
              wo = {
                spell = true,
              },
            },
          },
          actions = {
            toggle_type = function(picker)
              if string.match(picker.input.filter.pattern, "^type:") then
                picker.input.filter.pattern = picker.input.filter.pattern:sub(8)
              else
                picker.input.filter.pattern = "type:b " .. picker.input.filter.pattern
              end
              picker.input:set()
              picker.input:update()
            end,
          },
        },
      },
    },
  },
}
