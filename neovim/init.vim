" Enable Packer for plugin management
lua require('plugins')

" Show relative line number
set rnu

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

" Auto close Ruby on Rails, React template tags
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.html.erb,*.jsx,*.tsx'
