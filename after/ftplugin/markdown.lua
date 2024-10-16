local nmap = require("utils").nmap

nmap(
  "<leader>ms",
  function()
    if vim.g.markdownCodeBlockSpell == true then
      vim.cmd.syn('region', 'markdownCodeBlock', 'matchgroup=markdownCodeDelimiter', [[start="^\s*\z(`\{3,\}\).*$"]], [[end="^\s*\z1\ze\s*$"]], 'keepend')
      vim.g.markdownCodeBlockSpell = false
      vim.print("Don't check spelling in markdownCodeBlock.")
    else
      vim.cmd.syn('region', 'markdownCodeBlock', 'matchgroup=markdownCodeDelimiter', [[start="^\s*\z(`\{3,\}\).*$"]], [[end="^\s*\z1\ze\s*$"]], 'keepend', [[contains=@Spell]])
      vim.g.markdownCodeBlockSpell = true
      vim.print("Check spelling in markdownCodeBlock.")
    end
  end,
  "Enable spelling in markdown code block",
  0
)
