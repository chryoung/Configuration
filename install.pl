#!/usr/bin/perl

use warnings;
use strict;

use Env qw/HOME/;
use File::Temp qw/tempfile/;
use Fcntl qw/SEEK_SET/;
use Getopt::Long;

my $ENABLE_YCM;

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

sub install_neovim {
  my $neovim_config_home = "${HOME}/.config/nvim/";

  # Make configuration directory
  `mkdir -p $neovim_config_home/lua` unless -d "$neovim_config_home/lua";

  # Install Packer
  `git clone --depth=1 https://github.com/wbthomason/packer.nvim ${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim` unless -e "${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim";

  # Composite config
  my %init_placeholder_value;
  # Config Dash if running on macOS
  $init_placeholder_value{"dash_config"} = <<DASH_CONFIG if $^O eq "darwin";

" Dash
nnoremap <Leader>dq :Dash<CR>
nnoremap <Leader>dw :DashWord<CR>
DASH_CONFIG

  # Config ycm plugin
  $init_placeholder_value{"ycm_config"} = <<YCM_CONFIG if $ENABLE_YCM;
" YouCompleteMe
let g:ycm_key_invoke_completion = '<C-x>'
YCM_CONFIG

	fill_template("$neovim_config_home/init.vim", "neovim/init.vim", \%init_placeholder_value);

  # Copy lua config
	`cp neovim/lua/config.lua $neovim_config_home/lua`;

  # Composite plugins
  my %plugin_placeholder_value;
  # Enable Dash if running on macOS
  $plugin_placeholder_value{"dash_plugin"} = <<DASH_PLUGIN if $^O eq "darwin";

  use {
    'mrjones2014/dash.nvim',
    run = 'make install',
    Event = 'VimEnter'
  }
DASH_PLUGIN

  # Enable ycm plugin
  $plugin_placeholder_value{"ycm_plugin"} = <<YCM_PLUGIN if $ENABLE_YCM;

  use {
    'ycm-core/YouCompleteMe',
    ft = { 'python', 'python3', 'c', 'cpp', 'rust' },
    cmd = 'python3 install.py --clangd-completer --rust-completer'
  }
YCM_PLUGIN

  fill_template("$neovim_config_home/lua/plugins.lua", "neovim/lua/plugins.lua", \%plugin_placeholder_value);

  # Install ftplugin
  `mkdir $neovim_config_home/ftplugin` unless -d "$neovim_config_home/ftplugin";
  `cp ftplugin/*.vim $neovim_config_home/ftplugin`;

	print "Start nvim and run :PackerSync manually\n";
}

sub install_vim {
  # Install Vundle
	`git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim` unless -d "${HOME}/.vim/bundle/Vundle.vim";

  # Make vim config
  my %vimrc_placeholder_value;
  $vimrc_placeholder_value{"dash_plugin"} = <<VIMRC_DASH_PLUGIN;

Plugin 'rizzatti/dash.vim'
VIMRC_DASH_PLUGIN

  $vimrc_placeholder_value{"dash_config"} = <<VIMRC_DASH_CONFIG;

" Dash
nnoremap <silent> <Leader>dw :Dash<CR>
VIMRC_DASH_CONFIG

  fill_template("${HOME}/.vimrc", "vimrc", \%vimrc_placeholder_value);

  # Install ftplugin
  `mkdir ${HOME}/.vim/ftplugin` unless -d "${HOME}/.vim/ftplugin";
  `cp ftplugin/*.vim ${HOME}/.vim/ftplugin`;

	print "Start vim and run :PluginInstall manually\n";
}

sub install_tmux {
	`sudo apt install powerline` unless -e "/usr/share/powerline/bindings/tmux/powerline.conf";
	`cp tmux.conf ${HOME}/.tmux.conf`;
}

sub install_simple_tmux {
	`cp tmux.conf ${HOME}/.tmux.conf`;
	`sed -i -e '1,10d' ${HOME}/.tmux.conf`;
	`cat simple_tmux_theme.conf >> ${HOME}/.tmux.conf`;
}

sub install_fish {
  `mkdir -p ${HOME}/.config/fish` unless -d "${HOME}/.config/fish";
  `cp -r fish/* ${HOME}/.config/fish`;
}

GetOptions("ycm" => \$ENABLE_YCM);
my @install_targets = @ARGV;

my %all_targets = (
  "vim" => \&install_vim,
  "neovim" => \&install_neovim,
  "tmux" => \&install_tmux,
  "simple_tmux" => \&install_simple_tmux,
  "fish" => \&install_fish,
);

if ($install_targets[0] eq "all") {
  install_neovim;
  install_vim;
  install_tmux;
  install_fish;
  print "Finish installing all\n";
} else {
  foreach my $target (@install_targets) {
    &{$all_targets{$target}} if exists $all_targets{$target};
    print "Finish installing $target\n";
  }
}

