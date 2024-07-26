-- - auto-convert strings to f-strings when typing `{}` in a string
-- - also auto-converts f-strings back to regular strings when removing `{}`
return {
  "chrisgrieser/nvim-puppeteer",
  dependencies = "nvim-treesitter/nvim-treesitter",
  event = { "ModeChanged" },
  keys = {
    {"<leader>Pd", "<cmd>PuppeteerDisable<cr>", desc = "Disable Puppeteer"},
    {"<leader>Pe", "<cmd>PuppeteerEnable<cr>", desc = "Enable Puppeteer"},
    {"<leader>Pt", "<cmd>PuppeteerToggle<cr>", desc = "Toggle Puppeteer"},
  }
}
