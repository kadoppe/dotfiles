print('init.lua')

vim.cmd("autocmd!")

vim.opt.autoread = true
vim.opt.backupdir= "~/.vim/backup"
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 1
vim.opt.cursorline = true
vim.opt.directory = "~/.vim/swap"
vim.opt.expandtab = true
vim.opt.exrc = true
vim.opt.formatoptions:remove('ro')
vim.opt.helplang = "en"
vim.opt.hidden = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.laststatus = 2
vim.opt.listchars = {tab='^', trail='~'}
vim.opt.mouse = 'a'
vim.opt.nobackup = true
vim.opt.noerrorbells = true
vim.opt.nosc = true
vim.opt.noru = true
vim.opt.nosm = true
vim.opt.noswapfile = true
vim.opt.nowritebackup = true
vim.opt.nrformats = ''
vim.opt.number = true
vim.opt.scrolloff = 10
vim.opt.shortmess:append('c')
vim.opt.showcmd = true
vim.opt.smarttab = true
vim.opt.title = true
vim.opt.ttyfast = true
vim.opt.updatetime = 300
vim.opt.visualbell = true
vim.opt.t_vb = ''
vim.opt.whichwrap = "b,s,h,l"
vim.opt.inccommand = "split"

vim.opt.undofile = true
vim.opt.undodir = "./.vimundo,~/.vim/undo"

-- indents
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.nowrap = true
vim.opt.backspace = "start,eol,indent"

-- python
vim.g.python_host_prog = "~/.pyenv/shims/python2"
vim.g.python3_host_prog = "/opt/homebrew/bin/python3"

require('maps')
require('plug')

-- colorscheme
vim.opt.termguicolors = true
vim.cmd("colorscheme dracula")

