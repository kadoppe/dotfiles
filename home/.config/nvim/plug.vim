packadd vim-jetpack
call jetpack#begin()

if !has('nvim')
  Jetpack 'roxma/nvim-yarp'
  Jetpack 'roxma/vim-hug-neovim-rpc'
endif

Jetpack 'cohama/lexima.vim'
Jetpack 'dag/vim-fish'
Jetpack 'dracula/vim', {'as': 'dracula' }
Jetpack 'github/copilot.vim'
Jetpack 'hashivim/vim-terraform'
Jetpack 'pangloss/vim-javascript'
Jetpack 'plasticboy/vim-markdown'
Jetpack 'tpope/vim-fugitive'
Jetpack 'tpope/vim-rhubarb'
Jetpack 'tpope/vim-surround'
Jetpack 'tyru/open-browser-github.vim'
Jetpack 'tyru/open-browser.vim'
Jetpack 'wuelnerdotexe/vim-astro'

if has('nvim')
  Jetpack 'MunifTanjim/nui.nvim'
  Jetpack 'RRethy/vim-illuminate'
  Jetpack 'SmiteshP/nvim-navic'
  Jetpack 'akinsho/flutter-tools.nvim'
  Jetpack 'dense-analysis/ale'
  Jetpack 'folke/lsp-colors.nvim'
  Jetpack 'folke/noice.nvim'
  Jetpack 'folke/todo-comments.nvim'
  Jetpack 'folke/trouble.nvim'
  Jetpack 'folke/which-key.nvim'
  Jetpack 'glepnir/lspsaga.nvim', { 'branch': 'main' }
  Jetpack 'haringsrob/nvim_context_vt'
  Jetpack 'hrsh7th/cmp-buffer'
  Jetpack 'hrsh7th/cmp-cmdline'
  Jetpack 'hrsh7th/cmp-nvim-lsp'
  Jetpack 'hrsh7th/cmp-nvim-lsp-signature-help'
  Jetpack 'hrsh7th/cmp-nvim-lua'
  Jetpack 'hrsh7th/cmp-path'
  Jetpack 'hrsh7th/cmp-vsnip'
  Jetpack 'hrsh7th/nvim-cmp'
  Jetpack 'hrsh7th/vim-vsnip'
  Jetpack 'j-hui/fidget.nvim'
  Jetpack 'kevinhwang91/nvim-hlslens'
  Jetpack 'kyazdani42/nvim-tree.lua'
  Jetpack 'kyazdani42/nvim-web-devicons'
  Jetpack 'lewis6991/gitsigns.nvim'
  Jetpack 'mvllow/modes.nvim'
  Jetpack 'neovim/nvim-lspconfig'
  Jetpack 'neovim/nvim-lspconfig'
  Jetpack 'norcalli/nvim-colorizer.lua'
  Jetpack 'numToStr/Comment.nvim'
  Jetpack 'nvim-lua/plenary.nvim'
  Jetpack 'nvim-lua/popup.nvim'
  Jetpack 'nvim-lualine/lualine.nvim'
  Jetpack 'nvim-telescope/telescope-frecency.nvim'
  Jetpack 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
  Jetpack 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Jetpack 'onsails/lspkind-nvim'
  Jetpack 'petertriho/nvim-scrollbar'
  Jetpack 'phaazon/hop.nvim'
  Jetpack 'rmagatti/auto-session'
  Jetpack 'sindrets/diffview.nvim'
  Jetpack 'tami5/sqlite.lua'
  Jetpack 'williamboman/mason-lspconfig.nvim'
  Jetpack 'williamboman/mason.nvim'
  Jetpack 'xiyaowong/transparent.nvim'
endif

call jetpack#end()

