" Remapping

inoremap jk <Esc>
" vnoremap jk <Esc>


" ThePrimegean aiutami tu
let mapleader = ' '

" Exting from window quickly
nnoremap <leader>q :Ex <Return>

" Command to save file when you open without sudo
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

