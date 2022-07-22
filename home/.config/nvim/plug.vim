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
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'EdenEast/nightfox.nvim'

if has('nvim')
  Plug 'neovim/nvim-lspconfig'
  Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/cmp-nvim-lua'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'williamboman/nvim-lsp-installer'
  Plug 'onsails/lspkind-nvim'
  Plug 'nvim-lua/popup.nvim'
  Plug 'rcarriga/nvim-notify'
  Plug 'folke/lsp-colors.nvim'
  Plug 'j-hui/fidget.nvim'
  Plug 'tami5/sqlite.lua'
  Plug 'nvim-telescope/telescope-frecency.nvim'
  Plug 'haringsrob/nvim_context_vt'
  Plug 'SmiteshP/nvim-navic'
  Plug 'RRethy/vim-illuminate'
  Plug 'norcalli/nvim-colorizer.lua'
  Plug 'folke/todo-comments.nvim'
  Plug 'mvllow/modes.nvim'
  Plug 'kevinhwang91/nvim-hlslens'
  Plug 'petertriho/nvim-scrollbar'
  Plug 'phaazon/hop.nvim'
  Plug 'MunifTanjim/nui.nvim'
  Plug 'nvim-neo-tree/neo-tree.nvim'
  Plug 'folke/which-key.nvim'
  Plug 'numToStr/Comment.nvim'
  Plug 'TimUntersberger/neogit'
  Plug 'sindrets/diffview.nvim'
endif

call plug#end()

