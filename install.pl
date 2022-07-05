#!/usr/bin/perl

use warnings;
use strict;

use Env qw/HOME/;
use Fcntl qw/SEEK_SET/;
use Getopt::Long;

# Global flags
my $ENABLE_YCM;
my $INSTALL_ALL;

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
  `git clone --depth=1 https://github.com/wbthomason/packer.nvim ${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim` unless -e "${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim";

  # Compose init.vim
  my %init_placeholder_value;
  # Configure Dash if running on macOS
  $init_placeholder_value{"dash_config"} = <<'DASH_CONFIG' if $^O eq "darwin";

" Dash
nnoremap <Leader>dq :Dash<CR>
nnoremap <Leader>dw :DashWord<CR>
DASH_CONFIG

  # Configure ycm plugin
  $init_placeholder_value{"ycm_config"} = <<'YCM_CONFIG' if $ENABLE_YCM;

" YouCompleteMe
let g:ycm_key_invoke_completion = '<C-x>'
YCM_CONFIG

	fill_template("$neovim_config_home/init.vim", "neovim/init.vim", \%init_placeholder_value);

  # Copy config.lua
	`cp neovim/lua/config.lua $neovim_config_home/lua`;

  # Compose plugins.lua
  my %plugin_placeholder_value;
  # Install Dash plugin for macOS
  $plugin_placeholder_value{"dash_plugin"} = <<'DASH_PLUGIN' if $^O eq "darwin";

  use {
    'mrjones2014/dash.nvim',
    run = 'make install',
    Event = 'VimEnter'
  }
DASH_PLUGIN

  # Enable ycm plugin
  $plugin_placeholder_value{"ycm_plugin"} = <<'YCM_PLUGIN' if $ENABLE_YCM;

  use {
    'ycm-core/YouCompleteMe',
    ft = { 'python', 'python3', 'c', 'cpp', 'rust' },
    cmd = 'python3 install.py --clangd-completer --rust-completer'
  }
YCM_PLUGIN

  fill_template("$neovim_config_home/lua/plugins.lua", "neovim/lua/plugins.lua", \%plugin_placeholder_value);

  # Install ftplugin
  mkdir_unless_exists("$neovim_config_home/ftplugin");
  `cp ftplugin/*.vim $neovim_config_home/ftplugin`;

	print "Start nvim and run :PackerSync manually\n";
}

sub install_vim {
  # Install Vundle
	`git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim` unless -d "${HOME}/.vim/bundle/Vundle.vim";

  # Compose .vimrc
  my %vimrc_placeholder_value;

  # Install Dash plugin for macOS
  $vimrc_placeholder_value{"dash_plugin"} = <<'VIMRC_DASH_PLUGIN';

Plugin 'rizzatti/dash.vim'
VIMRC_DASH_PLUGIN

  $vimrc_placeholder_value{"dash_config"} = <<'VIMRC_DASH_CONFIG';

" Dash
nnoremap <silent> <Leader>dw :Dash<CR>
VIMRC_DASH_CONFIG

  fill_template("${HOME}/.vimrc", "vimrc", \%vimrc_placeholder_value);

  # Install ftplugin
  mkdir_unless_exists("${HOME}/.vim/ftplugin");
  `cp ftplugin/*.vim ${HOME}/.vim/ftplugin`;

	print "Start vim and run :PluginInstall manually\n";
}

sub install_tmux {
  my $linux_powerline = "/usr/share/powerline/bindings/tmux/powerline.conf";
  my %tmux_placeholder_value;

  if ($^O eq "linux") {
    unless (-e $linux_powerline) {
      print "Installing Powerline...\n";
      `sudo apt install powerline` 
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

  fill_template("${HOME}/.tmux.conf", "tmux.conf", \%tmux_placeholder_value);
}

sub install_fish {
  mkdir_unless_exists("${HOME}/.config/fish");
  `cp -r fish/* ${HOME}/.config/fish/`;
}

GetOptions(
  "ycm" => \$ENABLE_YCM,
  "all" => \$INSTALL_ALL
);
my @install_targets = @ARGV;

my %all_targets = (
  "vim" => \&install_vim,
  "neovim" => \&install_neovim,
  "tmux" => \&install_tmux,
  "fish" => \&install_fish,
);

if ($INSTALL_ALL) {
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

