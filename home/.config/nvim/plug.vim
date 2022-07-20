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
Plug 'pangloss/vim-javascript'
Plug 'plasticboy/vim-markdown'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tyru/caw.vim'

if has('nvim')
  Plug 'neovim/nvim-lspconfig'
  Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'williamboman/nvim-lsp-installer'
endif

call plug#end()

