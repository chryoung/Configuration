" Enable Packer for plugin management
lua require('plugins')
lua require('config')

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

" hop key bindings
nnoremap <silent> <Leader>jw :HopWord<CR>
nnoremap <silent> <Leader>jc :HopChar1<CR>
nnoremap <silent> <Leader>jl :HopLine<CR>

" auto-close tag for ruby on rails, react and react with typescript
let g:closetag_filenames = "*.html.erb,*.html,*.xhtml,*.phtml,*.tsx,*.jsx"

" Configuration commands
command Econfig edit $MYVIMRC
command ReloadConfig source $MYVIMRC
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
nnoremap <silent> <Leader>fj :cnext<CR>
nnoremap <silent> <Leader>fk :cprev<CR>

" Redraw screen and turn off the current highlight search
nnoremap <silent> <Leader>l :nohl<CR><C-L>

" wq Map
nnoremap <silent> <Leader>z :wq<CR>
nnoremap <silent> <Leader>q :q<CR>
nnoremap <silent> <Leader>w :w<CR>

" Colon map
nnoremap <Leader><Space> :

" Toggle Tarbar
nnoremap <silent> <F4> :TagbarToggle<CR>

" UltiSnip settings
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

let g:UltiSnipsEditSplit="vertical"

" Enable Emmet for eruby
autocmd FileType eruby EmmetInstall

let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>

" telescope
nnoremap <leader>f <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>g <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>b <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>h <cmd>lua require('telescope.builtin').help_tags()<cr>

" Dash
nnoremap <Leader>dq :Dash<CR>
nnoremap <Leader>dw :DashWord<CR>
