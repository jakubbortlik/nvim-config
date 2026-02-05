-- Lua version of "set 'option'"
vim.opt.colorcolumn = "+1"
vim.opt.completeopt = "menuone,longest,preview,fuzzy"
vim.opt.cursorline = true
vim.opt.diffopt:append({"linematch:60"})
vim.opt.expandtab = true
vim.opt.fileformat = "unix"
vim.opt.grepprg = "rg --color=never --no-heading --with-filename --line-number --column --smart-case --sort=path"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
vim.opt.hlsearch = false
vim.opt.history = 10000
vim.opt.ignorecase = true
vim.opt.jumpoptions = "view"
vim.opt.linebreak = true
vim.opt.listchars = "tab:>\\ ,trail:-,extends:>,precedes:<,nbsp:+"
vim.opt.number = true
vim.opt.nrformats:remove("octal")
vim.opt.scrolloff = 2
vim.opt.shiftwidth = 4
vim.opt.showmode = false
vim.opt.sidescrolloff = 2
vim.opt.signcolumn = "auto:1-4"
vim.opt.smartcase = true
vim.opt.softtabstop = 4
vim.opt.spelllang = "en_us"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.suffixes:remove({".info"})
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.textwidth = 88
vim.opt.timeoutlen = 500
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.updatetime = 50
vim.opt.wildmode = "longest,full"
vim.opt.shada:append("r/media")
vim.opt.winborder = "rounded"
vim.opt.cmdwinheight = 20
