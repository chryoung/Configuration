-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

local packer = require('packer')

packer.init({
  git = {
    clone_timeout = 300 -- Timeout, in seconds, for git clones
  }
})

return packer.startup(function()
--<<<impatient>>>
  -- Speed up NeoVim startup
  use {
    'lewis6991/impatient.nvim',
    config = [[require('impatient')]]
  }

--<<</impatient>>>
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Close the parenthesis
  use { 'rstacruz/vim-closer', event = 'VimEnter' }

  -- Dispatch job asynchronously
  use {
    'tpope/vim-dispatch',
    opt = true,
    cmd = { 'Dispatch', 'Make', 'Focus', 'Start' }
  }

  -- Matches the parenthesis and more
  use { 'andymass/vim-matchup', event = 'VimEnter' }

  -- Markdown support
  use {
    'iamcco/markdown-preview.nvim',
    run = 'cd app && yarn install',
    cmd = 'MarkdownPreview',
    ft = { 'markdown' }
  }

  use {
    'preservim/vim-markdown',
    requires = { 'godlygeek/tabular' },
    ft = { 'markdown' }
  }

  -- Themes
  use { 'dracula/vim', as = 'dracula' }

  -- File management
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    cmd = { 'NvimTreeToggle', 'NvimTreeOpen' },
    config = function() require'nvim-tree'.setup {} end
  }

  -- Git support
  use {
    'tpope/vim-fugitive',
    cmd = { 'G', 'Git' }
  }

  -- Commenet code. Type gcc to comment a line
  use { 'tpope/vim-commentary', event = 'VimEnter' }

  -- Fast move
  use {
    'phaazon/hop.nvim',
    branch = 'v1', -- optional but strongly recommended
    event = 'VimEnter',
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }

  -- Snippet
  use { 'SirVer/ultisnips', event = 'VimEnter' }

  -- Status line
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    event = 'VimEnter',
    config = function() require('lualine').setup() end
  }

  -- Command completion
  use {
    'gelguy/wilder.nvim',
    run = ':UpdateRemotePlugins',
    event = 'VimEnter'
  }

  -- Type :AsyncRun to run a command aschronously
  use { 'skywind3000/asyncrun.vim', cmd = { 'AsyncRun' } }

  use { 'simnalamburt/vim-mundo', cmd = { 'MundoToggle', 'MundoShow' }}

  use {
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function() require('which-key').setup() end
  }

  use { 'alvan/vim-closetag', event = 'VimEnter' }

  use { 'machakann/vim-sandwich', event = 'VimEnter' }

  use {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    config = function ()
        require'alpha'.setup(require'alpha.themes.startify'.config)
    end
  }

  use {
    'preservim/tagbar',
    ft = { 'c', 'cpp', 'rust' }
  }

  use {
    'mattn/emmet-vim',
    event = 'VimEnter'
  }

  use {
    'lukas-reineke/indent-blankline.nvim',
    event = 'VimEnter'
  }

  use { 'christoomey/vim-tmux-navigator' }

  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } },
    Event = 'VimEnter'
  }

  use {
    'tpope/vim-rails',
    ft = { 'ruby', 'eruby' }
  }
--<<<lsp_plugin>>>

  use { 'neovim/nvim-lspconfig' }
--<<</lsp_plugin>>>
--<<<ycm_plugin>>>

  use {
    'ycm-core/YouCompleteMe',
    ft = { 'python', 'python3', 'c', 'cpp', 'rust' },
    cmd = 'python3 install.py --clangd-completer --rust-completer'
  }
--<<</ycm_plugin>>>
--<<<dash_config>>>

  use {
    'mrjones2014/dash.nvim',
    run = 'make install',
    Event = 'VimEnter'
  }
--<<</dash_config>>>

end)
