vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
vim.opt.backup = false
vim.opt.errorbells = false
vim.opt.sc = false
vim.opt.ru = false
vim.opt.sm = false
vim.opt.mouse = 'a'
vim.opt.swapfile = false
vim.opt.writebackup = false
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
vim.opt.whichwrap = "b,s,h,l"
vim.opt.inccommand = "split"

vim.opt.undofile = true
vim.opt.undodir = "./.vimundo,~/.vim/undo"

-- colorscheme
vim.opt.termguicolors = true

-- indents
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.backspace = "start,eol,indent"

-- python
vim.g.python_host_prog = "~/.pyenv/shims/python2"
vim.g.python3_host_prog = "/opt/homebrew/bin/python3"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('maps')
require('plug')