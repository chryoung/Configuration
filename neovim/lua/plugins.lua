-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Close the parenthesis
    use '9mm/vim-closer'

    -- Dispatch job asynchronously
    use { 'tpope/vim-dispatch', opt = true, cmd = { 'Dispatch', 'Make', 'Focus', 'Start' } }

    -- Matches the parenthesis and more
    use { 'andymass/vim-matchup', event = 'VimEnter' }

    -- Markdown support
    use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview' }
    use { 'preservim/vim-markdown', requires = { 'godlygeek/tabular' } }

    -- Themes
    use { 'dracula/vim', as = 'dracula' }

    -- File management
    use {
      'kyazdani42/nvim-tree.lua',
      requires = {
        'kyazdani42/nvim-web-devicons', -- optional, for file icon
      },
      config = function() require'nvim-tree'.setup {} end
    }

    -- Git support
    use 'tpope/vim-fugitive'

    -- File search
    use { 'Yggdroot/LeaderF', run = ':LeaderfInstallCExtension' }

    -- Commenet code. Type gcc to comment a line
    use { 'tpope/vim-commentary' }

    -- Fast move
    use {
      'phaazon/hop.nvim',
      branch = 'v1', -- optional but strongly recommended
      config = function()
        -- you can configure Hop the way you like here; see :h hop-config
        require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
      end
    }

    -- Snippet
    use 'SirVer/ultisnips'

    -- Status line
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true },
      config = function() require('lualine').setup() end
    }

    -- Command completion
    use { 'gelguy/wilder.nvim', run = ':UpdateRemotePlugins' }

    -- Type :AsyncRun to run a command aschronously
    use { 'skywind3000/asyncrun.vim', cmd = {'AsyncRun'} }

    -- Better highlighting
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

    -- Smooth scroll
    use { 'karb94/neoscroll.nvim', config = function() require('neoscroll').setup() end }

    use 'simnalamburt/vim-mundo'

    use {
      "folke/which-key.nvim",
      config = function() require("which-key").setup() end
    }

end)
