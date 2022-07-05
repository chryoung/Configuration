#!/usr/bin/perl

use warnings;
use strict;

use Env qw/HOME/;
use Getopt::Long;
use File::Temp qw/tempfile/;
use Fcntl qw/SEEK_SET/;

my $ENABLE_YCM;

sub write_from_template {
  my $dest = shift;
  my $template = shift;
  my $placeholder_value = shift // {};

  open my $dest_fh, ">", $dest
    or return 0;
  open my $template_fh, "<", $template
    or return 0;

  while (<$template_fh>) {
    if (/^<<<([^>]+)>>>$/)
      my $placeholder = $1;
      if (exists $placeholder_value->{$placeholder}) {
        printf $dest_fh "%s\n", $placeholder_value->{$placeholder};
      }
    } else {
      print $dest_fh $_;
    }
  }

  close $template_fh;
  close $dest_fh;

  return 1;
}

sub install_dash_plugin_for_vim {
  replace_placeholder("${HOME}/.vimrc", "dash_plugin", "Plugin 'rizzatti/dash.vim'");
  replace_placeholder("${HOME}/.vimrc", "dash_config", "\"Dash\nnnoremap <silent> <Leader>dw :Dash<CR>");
}

sub install_neovim {
  `mkdir -p ${HOME}/.config/nvim/lua` unless -d "${HOME}/.config/nvim/lua";

  `git clone --depth=1 https://github.com/wbthomason/packer.nvim ${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim` unless -e "${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim";

  # Composite config
  my %init_placeholder_value;
  $init_placeholder_value{"dash_config"} = <<DASH_CONFIG if $^O eq "darwin";

" Dash
nnoremap <Leader>dq :Dash<CR>
nnoremap <Leader>dw :DashWord<CR>
DASH_CONFIG

  $init_placeholder_value{"ycm_config"} = <<YCM_CONFIG if $ENABLE_YCM;
" YouCompleteMe
let g:ycm_key_invoke_completion = '<C-x>'
YCM_CONFIG

	write_from_template("${HOME}/.config/nvim/", "neovim/init.vim", \%init_placeholder_value);

	`cp neovim/lua/config.lua ${HOME}/.config/nvim/lua/`;

  # Composite plugins
  my %plugin_placeholder_value;
  $plugin_placeholder_value{"dash_plugin"} = <<DASH_PLUGIN if $^O eq "darwin";

  use {
    'mrjones2014/dash.nvim',
    run = 'make install',
    Event = 'VimEnter'
  }
DASH_PLUGIN

  $plugin_placeholder_value{"ycm_plugin"} = <<YCM_PLUGIN if $ENABLE_YCM;

  use {
    'ycm-core/YouCompleteMe',
    ft = { 'python', 'c', 'cpp', 'rust' }
  }
YCM_PLUGIN

  write_from_template("${HOME}/.config/nvim/lua/plugins.lua", "neovim/lua/plugins.lua", \%plugin_placeholder_value);

	print "Start nvim and run :PackerSync manually\n";
}

sub install_vim {
	`git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim` unless -d "${HOME}/.vim/bundle/Vundle.vim";
	`cp vimrc ${HOME}/.vimrc`;
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

GetOptions("ycm" => \$ENABLE_YCM);
my @install_targets = @ARGV;

my %all_targets = (
  "vim" => \&install_vim,
  "neovim" => \&install_neovim,
  "tmux" => \&install_tmux,
  "simple_tmux" => \&install_simple_tmux,
);

if ($install_targets[0] eq "all") {
  install_neovim;
  install_vim;
  install_tmux;
} else {
  foreach my $target (@install_targets) {
    &{$all_targets{$target}} if exists $all_targets{$target};
  }
}

