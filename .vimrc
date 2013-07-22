set nocompatible

set backup
set swapfile
set backupdir=~/.vim/backup
set directory=~/.vim/swap

if has('persistent_undo')
  set undofile
  set undodir=./.vimundo,~/.vim/undo
endif

set modeline

set tabstop=2
set autoindent
set expandtab
set shiftwidth=2

set laststatus=2

set clipboard=unnamed,autoselect
set nrformats=

nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

nnoremap <ESC><ESC> :nohlsearch<CR>

let mapleader=","

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

" Bundles
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'fuenor/qfixgrep'

NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'gregsexton/gitv'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'bling/vim-airline'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'sudo.vim'
NeoBundle 'sjl/gundo.vim'
NeoBundle 'adie/BlockDiff'
NeoBundle 'thinca/vim-visualstar'
NeoBundle 'ShowMarks'
NeoBundle 'YankRing.vim'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'tpope/vim-abolish'
NeoBundle 'Align'
NeoBundle 'tpope/vim-surround'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'kana/vim-textobj-indent'
NeoBundle 'kana/vim-textobj-lastpat'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'thinca/vim-ref'
NeoBundle 'Shougo/vimshell'
NeoBundle 'mattn/gist-vim'
NeoBundle 'mattn/webapi-vim'

NeoBundle 'Markdown'

NeoBundle 'tpope/vim-rails'
NeoBundle 'tpope/vim-bundler'

NeoBundle 'altercation/vim-colors-solarized'

" NERDTree
map <C-e> :NERDTreeToggle<CR>

" unite.vim
nnoremap [unite] <Nop>
nmap <Leader>u [unite]

let g:unite_enable_start_insert=0
nnoremap <silent> [unite]b :<C-u>Unite<space>buffer<CR>
nnoremap <silent> [unite]bm :<C-u>Unite<Space>bookmark<CR>
nnoremap <silent> [unite]m :<C-u>Unite<space>file_mru<CR>

" vimfiler
let g:vimfiler_safe_mode_by_default=0
let g:vimfiler_as_default_explorer=1

" gundo.vim
nnoremap <F5> :GundoToggle<CR>

" YankRing
nnoremap <silent> <F7> :YRShow<CR>
let g:yankring_history_dir = expand('$HOME')
let g:yankring_history_file = '.yankring_history'
let g:yankring_max_history = 10
let g:yankring_window_height = 13

" indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1

" gist-vim
let g:gist_detect_filetype = 1
let g:gist_show_privates = 1

" align
let g:Align_xstrlen = 3

" 選択した範囲のインデントサイズを連続変更
vnoremap < <gv
vnoremap > >gv

" :vimgrepでの検索後QuickFixウインドウを自動的に開く
augroup grepopen
  autocmd!
  autocmd QuickfixCmdPost vimgrep cw
augroup END

" ファイルを開いた時にカーソルを前回編集時の位置に移動
augroup previousline
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" gitvでDiffが折りたたまれて表示される問題の対策
augroup git
  autocmd!
  autocmd FileType git :setlocal foldlevel=99
augroup END

syntax enable
set background=dark
colorscheme solarized

filetype plugin indent on
NeoBundleCheck


