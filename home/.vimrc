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
set exrc
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
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
call neobundle#end()

NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }

NeoBundle 'Align'
NeoBundle 'AndrewRadev/splitjoin.vim'
NeoBundle 'AndrewRadev/switch.vim'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neocomplcache-rsense'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/vimshell'
NeoBundle 'adie/BlockDiff'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'briancollins/vim-jst'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'dgryski/vim-godef'
NeoBundle 'digitaltoad/vim-jade'
NeoBundle 'elzr/vim-json'
NeoBundle 'fuenor/JpFormat.vim'
NeoBundle 'fuenor/qfixgrep'
NeoBundle 'gregsexton/gitv'
NeoBundle 'groenewege/vim-less'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'kana/vim-textobj-indent'
NeoBundle 'kana/vim-textobj-line'
NeoBundle 'kana/vim-textobj-underscore'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'mattn/gist-vim'
NeoBundle 'mattn/livestyle-vim'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'mxw/vim-jsx'
NeoBundle 'rhysd/vim-textobj-ruby'
NeoBundle 'rking/ag.vim'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'slim-template/vim-slim'
NeoBundle 'thinca/vim-qfreplace'
NeoBundle 'thinca/vim-textobj-function-javascript'
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
NeoBundle 'vim-scripts/taglist.vim'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'yaymukund/vim-rabl'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'rizzatti/dash.vim'

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
nnoremap <leader>p :CtrlP<CR>
nnoremap <leader>P :CtrlPClearCache<CR>:CtrlP<CR><CR>

nnoremap [unite] <Nop>
nmap <Leader>u [unite]
nnoremap <silent> [unite]f :<C-u>Unite<space>-buffer-name=files<space>buffer_tab<space>file_mru<CR>
nnoremap <silent> [unite]bm :<C-u>Unite<Space>bookmark<CR>
nnoremap <silent> [unite]m :<C-u>Unite<space>file_mru<CR>
nnoremap <silent> [unite]g :<C-u>Unite<space>grep -no-quit<CR>
nnoremap <silent> [unite]o :<C-u>Unite<space>outline<CR>
nnoremap <silent> [unite]l :<C-u>Unite<space>line<CR>
nnoremap <silent> [unite]h :<C-u>Unite<space>qfixhowm<CR>

noremap <silent> gl :JpFormat<CR>

noremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

nnoremap <leader>m :<C-u>Switch<CR>

nnoremap <leader>vf :VimFiler<CR>
nnoremap <leader>vb :VimFilerBufferDir<CR>
nnoremap <leader>vs :VimShell<CR>

nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gw :Gwrite<CR>
nnoremap <leader>gcm :Gcommit<CR>
nnoremap <leader>gp :Gpush<CR>

" unite.vim
let g:unite_enable_start_insert=0
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '--nocolor --nogroup'
let g:unite_source_grep_recursive_opt = ''
let g:unite_source_grep_max_candidates = 200

autocmd FileType vimfiler call unite#custom_default_action('directory', 'lcd')

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

" neocomplcache
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_force_overwrite_completefunc = 1
let g:neocomplcache_max_list = 20
let g:neocomplcache_manual_completion_start_length = 3
let g:neocomplcache_enable_ignore_case = 1
let g:neocomplcache_enable_smart_case = 1
if !exists('g:neocomplcache_delimiter_patterns')
    let g:neocomplcache_delimiter_patterns = {}
endif

let g:rsenseUseOmniFunc = 1
let g:neocomplcache#sources#rsense#home_directory = '/usr/local/Cellar/rsense/0.3/libexec'

" ctrlp
if executable('ag')
  let g:ctrlp_use_caching = 0
  let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup -g ""'
endif

" syntastic
let g:syntastic_mode_map = { 'mode': 'active',
      \ 'active_filetypes': ['ruby', 'javascript'] }
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_javascript_checkers = ['eslint']

" open-browser
let g:netrw_nogx = 1
nmap <Leader>o <Plug>(openbrowser-smart-search)
vmap <Leader>o <Plug>(openbrowser-smart-search)

" Golang
set rtp^=$GOROOT/misc/vim
set rtp^=$GOPATH/src/github.com/nsf/gocode/vim
set path+=$GOPATH/src/**
let g:gofmt_command = 'goimports'
au BufWritePre *.go Fmt
au BufNewFile,BufRead *.go set sw=4 noexpandtab ts=4 completeopt=menu,preview
au FileType go compiler go
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

" lightline.vim
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ ['mode', 'paste'], ['fugitive', 'filename'] ]
      \ },
      \ 'component_function' : {
      \   'fugitive': 'MyFugitive'
      \ }
      \ }
function! MyFugitive()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head') && strlen(fugitive#head())
      return ' ' . fugitive#head()
    endif
  catch
  endtry
  return ''
endfunction

" vimshell
let g:vimshell_prompt_expr = 'getcwd()." > "'
let g:vimshell_prompt_pattern = '^\f\+ > '

" vimfiler
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_max_directory_histories = 100
let g:vimfiler_quick_look_command = 'qlmanage -p'
autocmd FileType vimfiler nmap <buffer> V <Plug>(vimfiler_quick_look)

" vim-json
let g:vim_json_syntax_conceal = 0

" taglist
set tags=tags
let Tlist_Ctags_Cmd = "/usr/local/bin/ctags"
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWiindow = 1
let Tlist_Use_Right_Window = 1
let Tlist_Enable_Fold_Column = 1
map <silent> <leader>tl :TlistToggle<CR>

" dash.vim
:nmap <silent> <leader>d <Plug>DashSearch

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
  "autocmd FileType html setlocal shiftwidth=4 tabstop=2 softtabstop=2
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

colorscheme hybrid

filetype plugin indent on
NeoBundleCheck

" load local vimrc
if filereadable(expand($HOME.'/.localsetting/vimrc_local'))
  source $HOME/.localsetting/vimrc_local
endif
