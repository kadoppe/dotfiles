set nocompatible

syntax enable

"
" options
"
set backup
set backupdir=~/.vim/backup
set clipboard=unnamed,autoselect
set cmdheight=1
set directory=~/.vim/swap
set expandtab
set exrc
set helplang=en
set hidden
set listchars=tab:^\ ,trail:~
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

if has('persistent_undo')
  set undofile
  set undodir=./.vimundo,~/.vim/undo
endif

"
" load plugins
"
set runtimepath+=~/.vim/bundle/repos/github.com/Shougo/dein.vim
call dein#begin('~/.vim/bundle')

call dein#add('Shougo/dein.vim')

" Add or remove your plugins here:
call dein#add('Lokaltog/vim-easymotion')
call dein#add('Shougo/neocomplcache')
call dein#add('Shougo/neocomplcache-rsense')
call dein#add('Shougo/neomru.vim')
call dein#add('Shougo/unite.vim')
call dein#add('airblade/vim-gitgutter')
call dein#add('briancollins/vim-jst')
call dein#add('bronson/vim-trailing-whitespace')
call dein#add('ctrlpvim/ctrlp.vim')
call dein#add('dag/vim-fish')
call dein#add('digitaltoad/vim-pug')
call dein#add('dracula/vim')
call dein#add('elzr/vim-json')
call dein#add('groenewege/vim-less')
call dein#add('itchyny/lightline.vim')
call dein#add('junegunn/vim-easy-align')
call dein#add('kana/vim-textobj-indent')
call dein#add('kana/vim-textobj-line')
call dein#add('kana/vim-textobj-underscore')
call dein#add('kana/vim-textobj-user')
call dein#add('kchmck/vim-coffee-script')
call dein#add('leafgarland/typescript-vim')
call dein#add('mxw/vim-jsx')
call dein#add('pangloss/vim-javascript')
call dein#add('posva/vim-vue')
call dein#add('rhysd/vim-textobj-ruby')
call dein#add('rizzatti/dash.vim')
call dein#add('rking/ag.vim')
call dein#add('scrooloose/nerdtree')
call dein#add('slim-template/vim-slim')
call dein#add('thinca/vim-qfreplace')
call dein#add('tmux-plugins/vim-tmux')
call dein#add('tomtom/tcomment_vim')
call dein#add('tpope/vim-fugitive')
call dein#add('tpope/vim-markdown')
call dein#add('tpope/vim-rails')
call dein#add('tpope/vim-surround')
call dein#add('vim-airline/vim-airline')
call dein#add('vim-ruby/vim-ruby')
call dein#add('w0rp/ale')

call dein#end()

if dein#check_install()
  call dein#install()
endif

"
" key mapping
"
let mapleader=","

nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

nnoremap <ESC><ESC> :nohlsearch<CR>

nnoremap <leader>P :CtrlPClearCache<CR>:CtrlP<CR><CR>

nnoremap [unite] <Nop>
nmap <Leader>u [unite]
nnoremap <silent> [unite]f :<C-u>Unite<space>-buffer-name=files<space>buffer_tab<space>file_mru<CR>
nnoremap <silent> [unite]bm :<C-u>Unite<Space>bookmark<CR>
nnoremap <silent> [unite]m :<C-u>Unite<space>file_mru<CR>
nnoremap <silent> [unite]g :<C-u>Unite<space>grep -no-quit<CR>

noremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" NERDTree
nnoremap <leader>t :NERDTreeToggle<CR>

" dash
nmap <silent> <leader>d <Plug>DashSearch

"
" plugin settings
"

" unite.vim
let g:unite_enable_start_insert=0
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '--nocolor --nogroup'
let g:unite_source_grep_recursive_opt = ''
let g:unite_source_grep_max_candidates = 200

" neomru.vim
call unite#custom#source('file_mru', 'converters', 'converter_relative_word')

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

" easymotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
nmap s <Plug>(easymotion-overwin-f)
let g:EasyMotion_smartcase = 1
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" vim-json
let g:vim_json_syntax_conceal = 0

"
" color scheme
"
colorscheme dracula
hi Pmenu ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#64666d gui=NONE
hi PmenuSel ctermfg=NONE ctermbg=24 cterm=NONE guifg=NONE guibg=#204a87 gui=NONE

"
" misc
"

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

" load local vimrc
if filereadable(expand($HOME.'/.localsetting/vimrc_local'))
  source $HOME/.localsetting/vimrc_local
endif

" vue
autocmd FileType vue syntax sync fromstart

filetype plugin indent on
