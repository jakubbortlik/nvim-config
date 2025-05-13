local nmap = require("utils").nmap

nmap(
  "<leader>ms",
  function()
    if vim.g.markdownCodeBlockSpell == true then
      vim.cmd.syn('region', 'markdownCodeBlock', 'matchgroup=markdownCodeDelimiter', [[start="^\s*\z(`\{3,\}\).*$"]], [[end="^\s*\z1\ze\s*$"]], 'keepend')
      vim.cmd.syn('region', 'markdownCode', 'matchgroup=markdownCodeDelimiter', [[start="`"]], [[end="`"]], 'keepend', 'contains=markdownLineStart')
      vim.g.markdownCodeBlockSpell = false
      vim.print("Don't check spelling in markdownCodeBlock.")
    else
      vim.cmd.syn('region', 'markdownCodeBlock', 'matchgroup=markdownCodeDelimiter', [[start="^\s*\z(`\{3,\}\).*$"]], [[end="^\s*\z1\ze\s*$"]], 'keepend', [[contains=@Spell]])
      vim.cmd.syn('region', 'markdownCode', 'matchgroup=markdownCodeDelimiter', [[start="`"]], [[end="`"]], 'keepend', 'contains=markdownLineStart,@Spell')
      vim.g.markdownCodeBlockSpell = true
      vim.print("Check spelling in markdownCodeBlock.")
    end
  end,
  "Enable spelling in markdown code block",
  0
)

local make_filename = function(filename, index)
  return vim.fn.expand("$HOME") .. "/Screenshots/" .. filename .. index .. ".png"
end

nmap(
  "gLP",
  function()
    local filename = "screenshot_"
    local index = 1
    while vim.fn.filereadable(make_filename(filename, index)) == 1 do
      index = index + 1
    end
    filename = make_filename(filename, index)
    vim.fn.system("wl-paste > " .. filename )
    vim.print("Image saved as " .. filename)
    vim.cmd.normal({ args = { "o" }, bang = true })
    vim.cmd.normal({ args = { "ZA" }, bang = false })
  end,
  "save current clipboard to image"
)
