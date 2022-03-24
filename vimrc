" Vundle
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=$HOME/.vim/bundle/Vundle.vim/
call vundle#begin('$HOME/.vim/bundle/')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Git plugin
Plugin 'tpope/vim-fugitive'

" Theme
Plugin 'chriskempson/base16-vim'

" File explorer
Plugin 'scrooloose/nerdtree'

" Buffer management
Plugin 'bufexplorer.zip'

" Easy motion
Plugin 'easymotion/vim-easymotion'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" End of Vundle

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

if has("gui_running")
  color base16-material
endif

" Use 2 spaces to replace tab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" Relative line number
set rnu

" Case-insensitive search
set ignorecase

" Map space as leader
nnoremap <Space> <Nop>
nmap <Space> <Leader>

" Let Y behave like C and D
nnoremap Y y$

" Centre the n, N and J
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
nnoremap <silent> <C-j> :cnext<CR>
nnoremap <silent> <C-k> :cprev<CR>

" NerdTree shortcuts
nnoremap <silent> <F2> :NERDTreeToggle<CR>

" Redraw screen and turn off the current highlight search
nnoremap <silent> <C-L> :nohl<CR><C-L>

" Exit shortcuts
nnoremap <silent> <Leader>x :wqa<CR>
nnoremap <silent> <Leader>q :qa!<CR>

" Colon map
nnoremap <Leader><Space> :

" Redraw screen and turn off the current highlight search
nnoremap <silent> <C-L> :nohl<CR><C-L>

map <Leader>jc <Plug>(easymotion-bd-f)
map <Leader>jl <Plug>(easymotion-bd-jk)
map <Leader>jw <Plug>(easymotion-bd-w)
