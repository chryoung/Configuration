set nocompatible
filetype plugin indent on

function! PackInit() abort
    packadd minpac
    call minpac#init()

    call minpac#add('rstacruz/vim-closer')
    call minpac#add('tpope/vim-dispatch')
    call minpac#add('andymass/vim-matchup')
    call minpac#add('dracula/vim')
    call minpac#add('kyazdani42/nvim-web-devicons')
    call minpac#add('tpope/vim-fugitive')
    call minpac#add('tpope/vim-commentary')
    call minpac#add('phaazon/hop.nvim')
    call minpac#add('SirVer/ultisnips')
    call minpac#add('nvim-lualine/lualine.nvim')
    call minpac#add('gelguy/wilder.nvim')
    call minpac#add('simnalamburt/vim-mundo')
    call minpac#add('alvan/vim-closetag')
    call minpac#add('machakann/vim-sandwich')
    call minpac#add('mattn/emmet-vim')
    call minpac#add('christoomey/vim-tmux-navigator')
    call minpac#add('neovim/nvim-lspconfig')
    call minpac#add('junegunn/fzf')
    call minpac#add('junegunn/fzf.vim')
    call minpac#add('scrooloose/nerdtree')
    call minpac#add('Yggdroot/indentLine')
endfunction

command! PackUpdate source $MYVIMRC | call PackInit() | call minpac#update()
command! PackClean  source $MYVIMRC | call PackInit() | call minpac#clean()
command! PackStatus packadd minpac | call minpac#status()

syntax on
set rnu

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
  color dracula
endif

" Set space as leader
nnoremap <Space> <Nop>
let mapleader=" "

" Colon map
nnoremap <Leader><Space> :

nnoremap Y y$

" Centre the n, N and J
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Redraw screen and turn off the current highlight search
nnoremap <silent> <Leader>l :nohl<CR><C-L>

" wq Map
nnoremap <silent> <Leader>z :wq<CR>
nnoremap <silent> <Leader>q :q<CR>
nnoremap <silent> <Leader>w :w<CR>

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
nnoremap <silent> <Leader>hj :cnext<CR>
nnoremap <silent> <Leader>hk :cprev<CR>

" Configuration commands
command Econfig edit $MYVIMRC
command ReloadConfig source $MYVIMRC

" Save undo history for mundo
set undofile
set undodir=~/.vim/undo

" Mundo shortcut
nnoremap <silent> <F3> :MundoToggle<CR>

" hop init
lua require'hop'.setup { keys = "etovxqpdygfblzhckisuran" }
" hop key bindings
nnoremap <silent> <Leader>jw :HopWord<CR>
nnoremap <silent> <Leader>jc :HopChar1<CR>
nnoremap <silent> <Leader>jl :HopLine<CR>

" fzf.vim
nnoremap <silent> <Leader>ff :Files<CR>
nnoremap <silent> <Leader>fb :Buffers<CR>

" auto-close tag for ruby on rails, react and react with typescript
let g:closetag_filenames = "*.html.erb,*.html,*.xhtml,*.phtml,*.tsx,*.jsx"

" Enable Emmet for html family
autocmd FileType eruby,html,javascriptreact,typescriptreact EmmetInstall

let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>

" Ignore folder for vimgrep
set wildignore+=*/node_modules/**
set wildignore+=*/venv/**

" NerdTree shortcuts
nnoremap <silent> <F2> :NERDTreeToggle<CR>
