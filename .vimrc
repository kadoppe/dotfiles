set nocompatible

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
NeoBundle 'Shougo/vimproc'
NeoBundle 'git://github.com/Shougo/unite.vim.git'
NeoBundle 'scrooloose/nerdtree'

" NERDTree:
map <C-t> :NERDTreeToggle<CR>

filetype plugin indent on
NeoBundleCheck


