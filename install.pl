#!/usr/bin/perl

use warnings;
use strict;

use Env qw/HOME/;
use Getopt::Long;

# Global flags
my $ENABLE_YCM;
my $ENABLE_DASH;
my $ENABLE_LSP;
my $INSTALL_ALL;
my $SHOW_HELP;

sub fill_template {
  my $dest = shift;
  my $template = shift;
  my $placeholder_value = shift // {};

  open my $dest_fh, ">", $dest
    or return 0;
  open my $template_fh, "<", $template
    or return 0;

  while (<$template_fh>) {
    # If the line is a placeholder: <<<placerholder>>>
    if (/^<<<([^>]+)>>>$/) {
      my $placeholder = $1;
      if (exists $placeholder_value->{$placeholder}) {
        print $dest_fh $placeholder_value->{$placeholder};
      }
    } else {
      print $dest_fh $_;
    }
  }

  close $template_fh;
  close $dest_fh;

  return 1;
}

sub mkdir_unless_exists {
  `mkdir -p $_[0]` unless -d $_[0];
}

sub install_neovim {
  my $neovim_config_home = "${HOME}/.config/nvim/";

  # Make configuration directory
  mkdir_unless_exists("$neovim_config_home/lua");

  # Install Packer
  my $packer_vim = "${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim";
  `git clone --depth=1 https://github.com/wbthomason/packer.nvim $packer_vim` unless -e $packer_vim;

  # Compose init.vim
  my %init_placeholder_value;
  # Configure Dash
  $init_placeholder_value{"dash_config"} = <<'DASH_CONFIG' if $ENABLE_DASH;

" Dash
nnoremap <Leader>dq :Dash<CR>
nnoremap <Leader>dw :DashWord<CR>
DASH_CONFIG

  # Configure ycm plugin
  $init_placeholder_value{"ycm_config"} = <<'YCM_CONFIG' if $ENABLE_YCM;

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
YCM_CONFIG

  fill_template("$neovim_config_home/init.vim", "nvim/neovim/init.vim", \%init_placeholder_value);

  # Compose config.lua
  # Configure Dash plugin for telescope
  my %config_lua_placeholder_value;
  $config_lua_placeholder_value{"dash_config"} = <<'DASH_CONFIG_LUA' if $ENABLE_DASH;
telescope.setup({
  extensions = {
    dash = {
      search_engine = 'google',
      file_type_keywords = {
        ruby = { 'ruby', 'rails' },
        cmake = { 'cmake' },
        python = { 'python3', 'python' },
      }
    }
  }
})
DASH_CONFIG_LUA

  # Configure LSP
  if ($ENABLE_LSP) {
    print "Enable PLS LSP for Perl on neovim? [y/N]: \n";
    chomp(my $enable_pls = <STDIN>);
    if ($enable_pls eq "y") {
      $config_lua_placeholder_value{"lsp_config"} .= "require'lspconfig'.perlpls.setup{}\n";
      print "Enabled. Please remember to run `sudo cpan install -f PLS` after setup.\n";
    }

    print "Enable Pyright LSP for Python on neovim? [y/N]: \n";
    chomp(my $enable_pyright = <STDIN>);
    if ($enable_pyright eq "y") {
      $config_lua_placeholder_value{"lsp_config"} .= "require'lspconfig'.pyright.setup{}\n";
    }
  }

  fill_template("$neovim_config_home/lua/config.lua", "nvim/neovim/lua/config.lua", \%config_lua_placeholder_value);

  # Compose plugins.lua
  my %plugin_placeholder_value;
  # Install Dash plugin
  $plugin_placeholder_value{"dash_plugin"} = <<'DASH_PLUGIN' if $ENABLE_DASH;

  use {
    'mrjones2014/dash.nvim',
    run = 'make install',
    Event = 'VimEnter'
  }
DASH_PLUGIN

  # Install impatient plugin if Dash is not installed
  # impatient plugin and Dash plugin have conflicts
  # Dash cannot require libdash_nvim if impatient is installed
  # and the require command is hooked
  $plugin_placeholder_value{"impatient_plugin"} = <<'IMPATIENT_PLUGIN' unless $ENABLE_DASH;
  -- Speed up NeoVim startup
  use {
    'lewis6991/impatient.nvim',
    config = [[require('impatient')]]
  }

IMPATIENT_PLUGIN

  # Install LSP plugin
  $plugin_placeholder_value{"lsp_plugin"} = <<'LSP_PLUGIN' if $ENABLE_LSP;

  use { 'neovim/nvim-lspconfig' }
LSP_PLUGIN

  # Install ycm plugin
  $plugin_placeholder_value{"ycm_plugin"} = <<'YCM_PLUGIN' if $ENABLE_YCM;

  use {
    'ycm-core/YouCompleteMe',
    ft = { 'python', 'python3', 'c', 'cpp', 'rust' },
    cmd = 'python3 install.py --clangd-completer --rust-completer'
  }
YCM_PLUGIN

  fill_template("$neovim_config_home/lua/plugins.lua", "nvim/neovim/lua/plugins.lua", \%plugin_placeholder_value);

  # Install ftplugin
  mkdir_unless_exists("$neovim_config_home/ftplugin");
  `cp vim_common/ftplugin/*.vim $neovim_config_home/ftplugin`;

  print "Start nvim and run :PackerSync manually\n";
}

sub install_vim {
  # Install Vundle
  `git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim` unless -d "${HOME}/.vim/bundle/Vundle.vim";

  # Compose .vimrc
  my %vimrc_placeholder_value;

  # Install Dash plugin
  $vimrc_placeholder_value{"dash_plugin"} = <<'VIMRC_DASH_PLUGIN' if $ENABLE_DASH;

Plugin 'rizzatti/dash.vim'
VIMRC_DASH_PLUGIN

  $vimrc_placeholder_value{"dash_config"} = <<'VIMRC_DASH_CONFIG' if $ENABLE_DASH;

" Dash
nnoremap <silent> <Leader>dw :Dash<CR>
VIMRC_DASH_CONFIG

  fill_template("${HOME}/.vimrc", "vim/vimrc", \%vimrc_placeholder_value);

  # Install ftplugin
  mkdir_unless_exists("${HOME}/.vim/ftplugin");
  `cp vim_common/ftplugin/*.vim ${HOME}/.vim/ftplugin`;

  print "Start vim and run :PluginInstall manually\n";
}

sub install_tmux {
  my $linux_powerline = "/usr/share/powerline/bindings/tmux/powerline.conf";
  my %tmux_placeholder_value;

  if ($^O eq "linux" and -e "/usr/bin/apt-get") {
    unless (-e $linux_powerline) {
      print "Installing Powerline...\n";
      `sudo apt-get -y install powerline` 
    }

    print "Use Powerline for tmux theme\n";
    $tmux_placeholder_value{"theme"} = <<"TMUX_POWERLINE";
run-shell "powerline-daemon -q"
source $linux_powerline
TMUX_POWERLINE
  } else {
    print "Use customized tmux theme\n";
    $tmux_placeholder_value{"theme"} = <<'TMUX_CUSTOMIZED_THEME';
# Status bar
# colors
set -g status-bg black
set -g status-fg white

# alignment
set-option -g status-justify centre

# spot at left
set-option -g status-left '#[bg=black,fg=green][#[fg=cyan]#S#[fg=green]]'
set-option -g status-left-length 20

# window list
setw -g automatic-rename on
set-window-option -g window-status-format '#[dim]#I:#[default]#W#[fg=grey,dim]'
set-window-option -g window-status-current-format '#[fg=cyan,bold]#I#[fg=blue]:#[fg=cyan]#W#[fg=dim]'

# spot at right
set -g status-right '#[fg=green][#[fg=cyan]%Y-%m-%d#[fg=green]]'
TMUX_CUSTOMIZED_THEME
  }

  fill_template("${HOME}/.tmux.conf", "tmux/tmux.conf", \%tmux_placeholder_value);
}

sub install_fish {
  mkdir_unless_exists("${HOME}/.config/fish");
  `cp -r fish/* ${HOME}/.config/fish/`;
}

GetOptions(
  "ycm"  => \$ENABLE_YCM,
  "dash" => \$ENABLE_DASH,
  "lsp"  => \$ENABLE_LSP,
  "all"  => \$INSTALL_ALL,
  "h"    => \$SHOW_HELP,
);

my @install_targets = @ARGV;

my %all_targets = (
  "vim"    => \&install_vim,
  "neovim" => \&install_neovim,
  "tmux"   => \&install_tmux,
  "fish"   => \&install_fish,
);

if ($SHOW_HELP) {
    print "install.pl [options] <targets>\n";
    print "targets:\n";
    foreach my $target (sort keys %all_targets) {
        print "    $target\n";
    }

    print "options:\n";
    print "    --ycm install ycm to neovim\n";
    print "    --dash install dash extension to vim and neovim\n";
    print "    --lsp enable LSP support for neovim\n";
    print "    --all install all targets\n";
    print "    --h show this help\n";
} elsif ($INSTALL_ALL) {
  install_neovim;
  print "Finish install neovim\n";

  install_vim;
  print "Finish install vim\n";

  install_tmux;
  print "Finish install tmux\n";

  install_fish;
  print "Finish install fish\n";

  print "Finish installing all\n";
} else {
  foreach my $target (@install_targets) {
    &{$all_targets{$target}} if exists $all_targets{$target};
    print "Finish installing $target\n";
  }
}

