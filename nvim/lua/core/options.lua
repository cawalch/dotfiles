vim.opt.guicursor = 'n-v-c:block,i-ci-ve:ver100/,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor'
vim.opt.cursorline = true

vim.opt.number = true
vim.opt.list = false
vim.opt.scrolloff = 8
vim.opt.fillchars.eob = ' '
vim.opt.wrap = false
vim.opt.sidescrolloff = 8
vim.opt.linebreak = true
vim.opt.textwidth = 120
vim.cmd('set fo-=1')


vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.signcolumn = 'yes'
vim.opt.foldcolumn = '1'
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.conceallevel = 0
vim.opt.formatoptions = vim.o.formatoptions:gsub('cro', '')
vim.opt.updatetime = 300
vim.opt.mouse = 'a'
vim.opt.cmdheight = 1
vim.opt.breakindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignore:append {'*/node_modules/*'}

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.laststatus = 3

vim.g.markdown_recommended_style = 0
