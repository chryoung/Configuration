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

" Set space as leader
nnoremap <Space> <Nop>
let mapleader=" "

" Save undo history for mundo
set undofile
set undodir=~/.vim/undo

" Mundo shortcut
nnoremap <silent> <F3> :MundoToggle<CR>

" Neo tree shortcut
nnoremap <silent> <F2> :NvimTreeToggle<CR>

" Use pop-up window for LeaderF
let g:Lf_WindowPosition='popup'

" hop key bindings
nnoremap <silent> <Leader>jw :HopWord<CR>
nnoremap <silent> <Leader>jc :HopChar1<CR>
nnoremap <silent> <Leader>jl :HopLine<CR>

" auto-close tag for ruby on rails, react and react with typescript
let g:closetag_filenames = "*.html.erb,*.html,*.xhtml,*.phtml,*.tsx,*.jsx"