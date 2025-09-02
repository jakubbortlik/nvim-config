return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        spell_errors = {
          finder = function(opts)
          finder = function(_, ctx)
          finder = function(opts, ctx)
            ctx.picker.finder.longest = 0
            local errors = {}
            local save_cursor = vim.api.nvim_win_get_cursor(0)
            local save_wrapscan = vim.o.wrapscan
            local save_iskeyword = vim.bo.iskeyword
            local save_spell = vim.o.spell
            local buf = vim.api.nvim_get_current_buf()
            local file = vim.api.nvim_buf_get_name(buf)

            local highlights = {
              caps = "Cap",
              bad = "Bad",
              ["local"] = "Local",
              rare = "Rare",
            }

            local suggestions_tbl = {}

            vim.o.spell = true
            vim.opt.iskeyword:remove({ '_' })

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
                if #spell_info[1] > ctx.picker.finder.longest then
                  ctx.picker.finder.longest = #spell_info[1]
                end
                local type = string.sub(spell_info[2], 1, 1)
                local cached = suggestions_tbl[spell_info[1]]
                local suggestions = cached or vim.fn.spellsuggest(spell_info[1], opts.max_suggestions or 5, type == "c")
                if cached == nil then
                  suggestions_tbl[spell_info[1]] = suggestions
                end

                errors[#errors + 1] = {
                  text = spell_info[1],
                  highlight = highlights[spell_info[2]],
                  type = type,
                  file = file,
                  buf = buf,
                  lnum = pos[1],
                  pos = pos,
                  end_pos = { pos[1], pos[2] + #spell_info[1] },
                  suggestions = suggestions,
                }
              end

              last_pos = pos
              vim.cmd('silent normal! ]s')
            end

            -- Restore settings
            vim.o.wrapscan = save_wrapscan
            vim.o.spell = save_spell
            vim.bo.iskeyword = save_iskeyword
            vim.api.nvim_win_set_cursor(0, save_cursor)
            return errors
          end,
          format = function(item, picker)
            local a = Snacks.picker.util.align
            local ret = {} ---@type snacks.picker.Highlight[]
            ret[#ret + 1] = { a("", picker.finder.longest - vim.fn.strcharlen(item.text), {align = "right"}) }
            ret[#ret + 1] = { item.text, "Spell" .. item.highlight }
            ret[#ret + 1] = { "  " }
            for i, sug in ipairs(item.suggestions) do
              ret[#ret + 1] = { tostring(i) .. ".", "Number" }
              ret[#ret + 1] = {a(sug, picker.finder.longest + 2, {align = "left"}), "Normal" }
            end
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
