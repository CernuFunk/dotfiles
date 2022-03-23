set encoding=utf-8
set number relativenumber
set noswapfile
" set scrolloff=7
set backspace=indent,eol,start

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set fileformat=unix


" For rust.vim
syntax enable
filetype plugin indent on
" Rust
let g:rustfmt_autosave = 1


" Use LSP omni-completion in Rust files
autocmd Filetype rust setlocal omnifunc=v:lua.vim.lsp.omnifunc
" rustfmt on write using autoformat
" autocmd BufWrite * :Autoformat
 
" RUST configuration LSP
lua << EOF
local nvim_lsp = require'lspconfig'
 
local on_attach = function(client)
    require'completion'.on_attach(client)
end
 
nvim_lsp.rust_analyzer.setup({
    on_attach=on_attach,
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    }
})
EOF
 
" Python LSP server
lua require'lspconfig'.pylsp.setup{}
