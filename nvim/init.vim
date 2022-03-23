call plug#begin(stdpath("data") . '/plugged')

" Plug 'morhetz/gruvbox'
" Plug 'vim-airline/vim-airline'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'nvim-lualine/lualine.nvim'
" If you want to have icons in your statusline choose one of these
Plug 'kyazdani42/nvim-web-devicons'

" Plug 'jiangmiao/auto-pairs'

Plug 'rust-lang/rust.vim'
call plug#end()

" Remapping

inoremap jk <Esc>
" vnoremap jk <Esc>

" Theme settings
let g:tokyonight_style = "storm"
let g:tokyonight_italic_functions = 1
let g:tokyonight_sidebars = [ "qf", "vista_kind", "terminal", "packer" ]

" Change the "hint" color to the "orange" color, and make the "error" color bright red
let g:tokyonight_colors = {
  \ 'hint': 'orange',
  \ 'error': '#ff0000'
\ }
colorscheme tokyonight
lua << END
require('lualine').setup()
END

" ThePrimegean aiutami tu
let mapleader = ' '

" Exting from window quickly
nnoremap <leader>q :Ex <Return>

" Command to save file when you open without sudo
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
