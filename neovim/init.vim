" Enable Packer for plugin management
lua require('plugins')

" Show line number
set number

" Use 2 spaces to replace tab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" Set theme
colorscheme dracula

" Save undo history for mundo
set undofile
set undodir=~/.vim/undo

" Neo tree shortcut
nnoremap <silent> <F2> :NvimTreeToggle<CR>

" Use pop-up window for LeaderF
let g:Lf_WindowPosition='popup'

" hop key bindings
nnoremap <silent> <Leader>w :HopWord<CR>
nnoremap <silent> <Leader>c :HopChar1<CR>
nnoremap <silent> <Leader>l :HopLine<CR>
