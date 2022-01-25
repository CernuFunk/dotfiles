call plug#begin(stdpath("data") . '/plugged')

Plug 'morhetz/gruvbox'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-airline/vim-airline'

call plug#end()

" Remapping

inoremap jk <Esc>
" vnoremap jk <Esc>


colorscheme gruvbox
" Non so che fa
highlight Normal guibg=none
set background=dark " use dark mode
" set background=light " uncomment to use light mode


" ThePrimegean aiutami tu
let mapleader = ' '

" Exting from window quickly
nnoremap <leader>q :Ex <Return>

" Command to save file when you open without sudo
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
