set nocompatible

syntax enable

set autoindent
set autoread
set backup
set backupdir=~/.vim/backup
set clipboard=unnamed,autoselect
set cursorline
set directory=~/.vim/swap
set expandtab
set helplang=en
set hidden
set laststatus=2
set lazyredraw
set list
set listchars=tab:^\ ,trail:~
set modeline
set noerrorbells
set nrformats=
set number
set scrolloff=5
set shiftwidth=2
set swapfile
set tabstop=2
set ttyfast
set visualbell t_vb=
set whichwrap=b,s,h,l

" Vimを終了してもUndo
if has('persistent_undo')
  set undofile
  set undodir=./.vimundo,~/.vim/undo
endif

" NeoBundle
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#rc(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Align'
NeoBundle 'AndrewRadev/splitjoin.vim'
NeoBundle 'AndrewRadev/switch.vim'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/vimshell'
NeoBundle 'adie/BlockDiff'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'briancollins/vim-jst'
NeoBundle 'digitaltoad/vim-jade'
NeoBundle 'fuenor/JpFormat.vim'
NeoBundle 'fuenor/qfixgrep'
NeoBundle 'gregsexton/gitv'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'kana/vim-textobj-indent'
NeoBundle 'kana/vim-textobj-lastpat'
NeoBundle 'kana/vim-textobj-line'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'mattn/gist-vim'
NeoBundle 'mattn/livestyle-vim'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'mhinz/vim-startify'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'rhysd/vim-textobj-ruby'
NeoBundle 'rking/ag.vim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'thinca/vim-qfreplace'
NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-visualstar'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'tpope/vim-abolish'
NeoBundle 'tpope/vim-bundler'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-markdown'
NeoBundle 'tpope/vim-rails'
NeoBundle 'tpope/vim-speeddating'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'yaymukund/vim-rabl'

let mapleader=","

nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

vnoremap < <gv
vnoremap > >gv

nnoremap <ESC><ESC> :nohlsearch<CR>

nnoremap <leader>h :<C-u>help<space>
noremap <leader>l :Align
nnoremap <leader>t :NERDTreeToggle<CR>
nnoremap <leader>p :CtrlP<CR>
nnoremap <leader>P :CtrlPClearCache<CR>:CtrlP<CR><CR>

nnoremap [unite] <Nop>
nmap <Leader>u [unite]
nnoremap <silent> [unite]f :<C-u>Unite<space>-buffer-name=files<space>buffer_tab<space>file_mru<space>file_rec<space>file<CR>
nnoremap <silent> [unite]bm :<C-u>Unite<Space>bookmark<CR>
nnoremap <silent> [unite]m :<C-u>Unite<space>file_mru<CR>
nnoremap <silent> [unite]g :<C-u>Unite<space>grep -no-quit<CR>
nnoremap <silent> [unite]o :<C-u>Unite<space>outline<CR>
nnoremap <silent> [unite]l :<C-u>Unite<space>line<CR>
nnoremap <silent> [unite]h :<C-u>Unite<space>qfixhowm<CR>

noremap <silent> gl :JpFormat<CR>

noremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

nnoremap <leader>m :<C-u>Switch<CR>

" unite.vim
let g:unite_enable_start_insert=0
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '--nocolor --nogroup'
let g:unite_source_grep_recursive_opt = ''
let g:unite_source_grep_max_candidates = 200

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

" lightline.vim
let g:lightline = {
      \ 'colorscheme': 'solarized'
      \ }

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

augroup indent
  autocmd!
  autocmd FileType html setlocal shiftwidth=4 tabstop=2 softtabstop=2
augroup END

augroup complete
  autocmd!
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

" Strip trailing whitespace
" http://rails-bestpractices.com/posts/60-remove-trailing-whitespace
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

augroup trailingwhitespace
  autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
augroup END

" カラースキームをsolarized(dark)に設定
set background=light
colorscheme solarized

filetype plugin indent on
NeoBundleCheck
