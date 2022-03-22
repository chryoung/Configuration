" Enable Packer for plugin management
lua require('plugins')

" Show line number
set rnu

" Use 2 spaces to replace tab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" Case-insensitive search
set ignorecase

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

" Map LeaderF for lazy load
nnoremap <silent> <Leader>f :LeaderfFile<CR>
nnoremap <silent> <Leader>b :LeaderfBuffer<CR>

" hop key bindings
nnoremap <silent> <Leader>jw :HopWord<CR>
nnoremap <silent> <Leader>jc :HopChar1<CR>
nnoremap <silent> <Leader>jl :HopLine<CR>

" auto-close tag for ruby on rails, react and react with typescript
let g:closetag_filenames = "*.html.erb,*.html,*.xhtml,*.phtml,*.tsx,*.jsx"

" Configuration commands
command Econf edit $MYVIMRC
command ReloadConf source $MYVIMRC
command Eplugin edit $HOME/.config/nvim/lua/plugins.lua

" Let Y do things like C and D
nnoremap Y y$

" Centre the search jump and J
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Undo break points
inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u
inoremap _ _<C-g>u
inoremap - -<C-g>u
inoremap ( (<C-g>u
inoremap ) )<C-g>u
inoremap [ [<C-g>u
inoremap ] ]<C-g>u

" Register j, k move into C-i and C-o
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" Move lines around
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
inoremap <C-j> <ESC>:m .+1<CR>==
inoremap <C-k> <ESC>:m .-2<CR>==
nnoremap <Leader>mj :m .+1<CR>==
nnoremap <Leader>mk :m .-2<CR>==

" Toggle quickfix window
function! ToggleQuickFix()
  if empty(filter(getwininfo(), 'v:val.quickfix'))
    copen
  else
    cclose
  endif
endfunction

nnoremap <silent> <C-q> :call ToggleQuickFix()<CR>

" Jump between quickfix items
nnoremap <C-j> :cnext
nnoremap <C-k> :cprev

" Redraw screen and turn off the current highlight search
nnoremap <C-L> :nohl<CR><C-L>

" Exit
nnoremap <silent> <Leader>x :wqa<CR>
nnoremap <silent> <Leader>q :qa!<CR>

" Colon map
nnoremap <Leader><Space> :
