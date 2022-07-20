if &compatible
  set nocompatible
endif

syntax enable

"
" options
"
set autoread
set nobackup
set nowritebackup
set backupdir=~/.vim/backup
set clipboard=unnamed
set cmdheight=2
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
set shortmess+=c
set swapfile
set tabstop=2
set ttyfast
set updatetime=300
set visualbell t_vb=
set whichwrap=b,s,h,l
set mouse=a

if has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=yes
endif

if has('persistent_undo')
  set undofile
  set undodir=./.vimundo,~/.vim/undo
endif

if has('nvim')
  if has('mac')
    let g:python_host_prog = '~/.pyenv/shims/python2'
    let g:python3_host_prog = '/opt/homebrew/bin/python3'
  endif

  if has('unix')
    let g:python3_host_prog = '/usr/bin/python3'
  endif
endif

"
" load plugins
"
call plug#begin()
  if !has('nvim')
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif

  Plug 'airblade/vim-gitgutter'
  Plug 'cohama/lexima.vim'
  Plug 'dag/vim-fish'
  Plug 'dracula/vim', {'as': 'dracula' }
  Plug 'hashivim/vim-terraform'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'pangloss/vim-javascript'
  Plug 'plasticboy/vim-markdown'
  Plug 'preservim/nerdtree'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
  Plug 'tyru/caw.vim'

  if has('nvim')
    Plug  'neovim/nvim-lspconfig'
  endif

call plug#end()

filetype plugin indent on
syntax enable

"
" key mapping
"
let mapleader=","

nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

"
" plugin settings
"
"
" Define
"
nmap ; :Denite buffer<CR>
nmap <leader>t :DeniteProjectDir file/rec<CR>
nnoremap <leader>g :<C-u>Denite grep:. -no-empty<CR>
nnoremap <leader>j :<C-u>DeniteCursorWord grep:.<CR>

autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction


" nerdtree
nmap <leader>n :NERDTreeToggle<CR>

" coc
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')

nmap <leader>rn <Plug>(coc-rename)

xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" vim-markdown
let g:vim_markdown_folding_disabled = 1

"
" color scheme
"
colorscheme dracula

"
" misc
"


" load local vimrc
if filereadable(expand($HOME.'/.localsetting/vimrc_local'))
  source $HOME/.localsetting/vimrc_local
endif

