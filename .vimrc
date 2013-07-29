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
set number

set tabstop=2
set autoindent
set expandtab
set shiftwidth=2

set laststatus=2

set clipboard=unnamed,autoselect
set nrformats=

set list
set listchars=tab:^\ ,trail:~

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
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'fuenor/qfixgrep'

NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'gregsexton/gitv'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'sudo.vim'
NeoBundle 'adie/BlockDiff'
NeoBundle 'thinca/vim-visualstar'
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
NeoBundle 'yaymukund/vim-rabl'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'fuenor/JpFormat.vim'
NeoBundle 'briancollins/vim-jst'
NeoBundle 'thinca/vim-qfreplace'
NeoBundle 'fuenor/qfixhowm'
NeoBundle 'tpope/vim-speeddating'
NeoBundle 'Shougo/neocomplcache'

NeoBundle 'Markdown'

NeoBundle 'tpope/vim-rails'
NeoBundle 'tpope/vim-bundler'

NeoBundle 'altercation/vim-colors-solarized'

" NERDTree
map <C-e> :NERDTreeToggle<CR>

" unite.vim
nnoremap [unite] <Nop>
nmap <Leader>u [unite]

nnoremap <silent> [unite]f :<C-u>Unite<space>-buffer-name=files<space>buffer_tab<space>file_rec<space>file<space>file_mru<CR>
nnoremap <silent> [unite]bm :<C-u>Unite<Space>bookmark<CR>
nnoremap <silent> [unite]m :<C-u>Unite<space>file_mru<CR>
nnoremap <silent> [unite]g :<C-u>Unite<space>grep -no-quit<CR>
nnoremap <silent> [unite]o :<C-u>Unite<space>outline<CR>
nnoremap <silent> [unite]l :<C-u>Unite<space>line<CR>

let g:unite_enable_start_insert=0
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '--nocolor --nogroup'
let g:unite_source_grep_recursive_opt = ''
let g:unite_source_grep_max_candidates = 200

" vimfiler
let g:vimfiler_safe_mode_by_default=0
let g:vimfiler_as_default_explorer=1

" indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1

" gist-vim
let g:gist_detect_filetype = 1
let g:gist_show_privates = 1

" align
let g:Align_xstrlen = 3

" JpFormat
let JpCountChars = 38
let JpCountLines = 34
noremap <silent> gl :JpFormat<CR>

" qfixhowm
let QFixHowm_Key = 'g'
let howm_dir = '~/Dropbox/howm'
let howm_filename = '%Y/%m/%Y-%m-%d-%H%M%S.mkd'
let howm_fileencoding = 'utf-8'
let howm_fileformat = 'unix'
let QFixHowm_FileType = 'markdown'
let QFixHowm_Title = '#'

" neocomplcache
let g:neocomplcache_enable_at_startup = 1

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


