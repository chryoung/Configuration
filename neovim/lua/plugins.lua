-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Speed up NeoVim startup
  use {
    'lewis6991/impatient.nvim',
    config = [[require('impatient')]]
  }

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Close the parenthesis
  use { '9mm/vim-closer', event = 'VimEnter' }

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
    ft = { "markdown" }
  }

  use {
    'preservim/vim-markdown',
    requires = { 'godlygeek/tabular' },
    ft = { "markdown" }
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
  use { 'tpope/vim-fugitive', event = 'User InGitRepo' }

  -- File search
  use {
    'Yggdroot/LeaderF',
    run = ':LeaderfInstallCExtension',
    cmd = 'Leaderf'
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

  -- Better highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    event = 'VimEnter'
  }

  -- Smooth scroll
  use { 'karb94/neoscroll.nvim', config = function() require('neoscroll').setup() end }

  use { 'simnalamburt/vim-mundo', cmd = { 'MundoToggle', 'MundoShow' }}

  use {
    "folke/which-key.nvim",
    event = 'VimEnter',
    config = function() require("which-key").setup() end
  }

  use { 'alvan/vim-closetag', event = 'VimEnter' }

  use { 'machakann/vim-sandwich', event = 'VimEnter' }

end)