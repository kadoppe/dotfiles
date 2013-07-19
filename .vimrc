set nocompatible
set noswapfile

set tabstop=2
set autoindent
set expandtab
set shiftwidth=2

set laststatus=2

nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l


if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

" Bundles
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'kien/ctrlp.vim'

NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'Lokaltog/powerline', { 'rtp' : 'powerline/bindings/vim'}

NeoBundle 'tpope/vim-rails'
NeoBundle 'tpope/vim-bundler'

NeoBundle 'altercation/vim-colors-solarized'

" NERDTree:
map <C-e> :NERDTreeToggle<CR>

syntax enable
set background=dark
colorscheme solarized

filetype plugin indent on
NeoBundleCheck


