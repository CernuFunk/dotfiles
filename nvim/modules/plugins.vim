call plug#begin(stdpath("data") . '/plugged')

" Plug 'morhetz/gruvbox'
" Plug 'vim-airline/vim-airline'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'nvim-lualine/lualine.nvim'
" If you want to have icons in your statusline choose one of these
Plug 'kyazdani42/nvim-web-devicons'

" Plug 'jiangmiao/auto-pairs'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'rust-lang/rust.vim'

" LSP Config
Plug 'neovim/nvim-lspconfig'

call plug#end()
