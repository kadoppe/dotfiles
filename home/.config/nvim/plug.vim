packadd vim-jetpack
call jetpack#begin()

if !has('nvim')
  Jetpack 'roxma/nvim-yarp'
  Jetpack 'roxma/vim-hug-neovim-rpc'
endif

Jetpack 'cohama/lexima.vim'
Jetpack 'dag/vim-fish'
Jetpack 'dracula/vim', {'as': 'dracula' }
Jetpack 'hashivim/vim-terraform'
Jetpack 'pangloss/vim-javascript'
Jetpack 'plasticboy/vim-markdown'
Jetpack 'tpope/vim-fugitive'
Jetpack 'tpope/vim-rhubarb'
Jetpack 'tpope/vim-surround'
Jetpack 'tyru/open-browser.vim'
Jetpack 'tyru/open-browser-github.vim'
Jetpack 'EdenEast/nightfox.nvim'

if has('nvim')
  Jetpack 'neovim/nvim-lspconfig'
  Jetpack 'glepnir/lspsaga.nvim', { 'branch': 'main' }
  Jetpack 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Jetpack 'hrsh7th/cmp-nvim-lsp'
  Jetpack 'hrsh7th/cmp-nvim-lsp-signature-help'
  Jetpack 'hrsh7th/cmp-buffer'
  Jetpack 'hrsh7th/cmp-path'
  Jetpack 'hrsh7th/cmp-cmdline'
  Jetpack 'hrsh7th/cmp-nvim-lua'
  Jetpack 'hrsh7th/nvim-cmp'
  Jetpack 'hrsh7th/cmp-vsnip'
  Jetpack 'hrsh7th/vim-vsnip'
  Jetpack 'nvim-lua/plenary.nvim'
  Jetpack 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
  Jetpack 'kyazdani42/nvim-web-devicons'
  Jetpack 'kyazdani42/nvim-tree.lua'
  Jetpack 'nvim-lualine/lualine.nvim'
  Jetpack 'onsails/lspkind-nvim'
  Jetpack 'nvim-lua/popup.nvim'
  Jetpack 'folke/lsp-colors.nvim'
  Jetpack 'j-hui/fidget.nvim'
  Jetpack 'tami5/sqlite.lua'
  Jetpack 'nvim-telescope/telescope-frecency.nvim'
  Jetpack 'haringsrob/nvim_context_vt'
  Jetpack 'SmiteshP/nvim-navic'
  Jetpack 'RRethy/vim-illuminate'
  Jetpack 'norcalli/nvim-colorizer.lua'
  Jetpack 'folke/todo-comments.nvim'
  Jetpack 'mvllow/modes.nvim'
  Jetpack 'kevinhwang91/nvim-hlslens'
  Jetpack 'petertriho/nvim-scrollbar'
  Jetpack 'phaazon/hop.nvim'
  Jetpack 'MunifTanjim/nui.nvim'
  Jetpack 'folke/which-key.nvim'
  Jetpack 'numToStr/Comment.nvim'
  Jetpack 'sindrets/diffview.nvim'
  Jetpack 'lewis6991/gitsigns.nvim'
  Jetpack 'rmagatti/auto-session'
  Jetpack 'akinsho/flutter-tools.nvim'
  Jetpack 'folke/trouble.nvim'
  Jetpack 'williamboman/mason.nvim'
  Jetpack 'williamboman/mason-lspconfig.nvim'
  Jetpack 'neovim/nvim-lspconfig'
  Jetpack 'dense-analysis/ale'
  Jetpack 'folke/noice.nvim'
endif

call jetpack#end()

