autocmd!

if &compatible
  set nocompatible
endif

set autoread
set backupdir=~/.vim/backup
set clipboard=unnamedplus
set cmdheight=1
set cursorline
set directory=~/.vim/swap
set expandtab
set exrc
set formatoptions-=ro
set helplang=en
set hidden
set hlsearch
set ignorecase
set smartcase
set laststatus=2
set lazyredraw
set listchars=tab:^\ ,trail:~
set mouse=a
set nobackup
set noerrorbells
set nosc noru nosm
set noswapfile
set nowritebackup
set nrformats=
set number
set scrolloff=10
set shortmess+=c
set showcmd
set smarttab
set swapfile
set title
set ttyfast
set updatetime=300
set visualbell t_vb=
set whichwrap=b,s,h,l

if has('nvim') 
  set inccommand=split
end

if has('persistent_undo')
  set undofile
  set undodir=./.vimundo,~/.vim/undo
endif

" indents
filetype plugin indent on
set shiftwidth=2
set tabstop=2
set autoindent
set smartindent
set nowrap
set backspace=start,eol,indent

if has('nvim')
  if has('mac')
    let g:python_host_prog = '~/.pyenv/shims/python2'
    let g:python3_host_prog = '/opt/homebrew/bin/python3'
  endif

  if has('unix')
    let g:python3_host_prog = '/usr/bin/python3'
  endif
endif


runtime ./plug.vim
runtime ./maps.vim

if exists("&termguicolors") && exists("&winblend")
  set termguicolors
endif

