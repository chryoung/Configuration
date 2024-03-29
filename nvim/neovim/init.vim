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

" Enable Emmet for eruby
autocmd FileType eruby EmmetInstall

let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>

" telescope
nnoremap <Leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <Leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <Leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <Leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
"<<<dash>>>

" Dash
nnoremap <Leader>dq :Dash<CR>
nnoremap <Leader>dw :DashWord<CR>
"<<</dash>>>

" Disable Markdown fold
let g:vim_markdown_folding_disabled = 1

" Ignore folder for vimgrep
set wildignore+=*/node_modules/**
set wildignore+=*/venv/**
"<<<ycm>>>

" YouCompleteMe
" Rebind sematic completion
let g:ycm_key_invoke_completion = '<C-x>'
let completeopt="menu,popup"
nnoremap <leader>gtr :YcmCompleter GoToReferences<cr>
nnoremap <leader>gd :YcmCompleter GetDoc<cr>
nnoremap <leader>yfi :YcmCompleter FixIt<cr>
nnoremap <leader>yfmt :YcmCompleter Format<cr>
nnoremap <F8> :YcmCompleter GoToDefinition<cr>
nnoremap <F9> :YcmCompleter GoToInclude<cr>
nnoremap <F10> :YcmCompleter GoToAlternateFile<cr>
nnoremap <F12> :YcmCompleter GoTo<cr>
"<<</ycm>>>
