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
  my $enabled_configs = shift // {};
  my $comment = shift // "#";

  open my $dest_fh, ">", $dest
    or return 0;
  open my $template_fh, "<", $template
    or return 0;

  my $current_config;
  my $will_print_current_config = 0;
  while (<$template_fh>) {
    # If the line indicates the start of the config <<<config_name>>>
    if (/^${comment}<<<([^>]+)>>>$/) {
      my $current_config = $1;
      if (exists $enabled_configs->{$current_config}) {
        $will_print_current_config = 1;
      }
    } elsif (($current_config and $will_print_current_config)
             or not $current_config) {
      print $dest_fh $_;
    # If the line indicates the end of the config <<</config_name>>>
    } elsif ($current_config and m!^${comment}<<</${current_config}>>>$!) {
      $current_config = "";
      $will_print_current_config = 0;
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
  my %enabled_configs;
  # Configure Dash
  $enabled_configs{"dash"} = 1 if $ENABLE_DASH;

  # Configure ycm plugin
  $enabled_configs{"ycm"} = 1 if $ENABLE_YCM;

  fill_template("$neovim_config_home/init.vim", "nvim/neovim/init.vim", \%enabled_configs, "\"");

  # Compose config.lua
  # Configure Dash plugin for telescope
  # Configure LSP
  if ($ENABLE_LSP) {
    print "Enable PLS LSP for Perl on neovim? [y/N]: \n";
    chomp(my $enable_pls = <STDIN>);
    if ($enable_pls eq "y") {
      $enabled_configs{"lsp_perl"} = 1;
      print "Enabled. Please remember to run `sudo cpan install -f PLS` after setup.\n";
    }

    print "Enable Pyright LSP for Python on neovim? [y/N]: \n";
    chomp(my $enable_pyright = <STDIN>);
    if ($enable_pyright eq "y") {
      $enabled_configs{"lsp_python"} = 1;
    }
  }

  fill_template("$neovim_config_home/lua/config.lua", "nvim/neovim/lua/config.lua", \%enabled_configs, "--");

  # Compose plugins.lua
  # Install impatient plugin if Dash is not installed
  # impatient plugin and Dash plugin have conflicts
  # Dash cannot require libdash_nvim if impatient is installed
  # and the require command is hooked
  $enabled_configs{"impatient"} = 1 unless $ENABLE_DASH;

  # Install LSP plugin
  $enabled_configs{"lsp"} = 1 if $ENABLE_LSP;

  # Install ycm plugin
  $enabled_configs{"ycm"} = 1 if $ENABLE_YCM;

  fill_template("$neovim_config_home/lua/plugins.lua", "nvim/neovim/lua/plugins.lua", \%enabled_configs, "--");

  # Install ftplugin
  mkdir_unless_exists("$neovim_config_home/ftplugin");
  `cp vim_common/ftplugin/*.vim $neovim_config_home/ftplugin`;

  print "Start nvim and run :PackerSync manually\n";
}

sub install_vim {
  # Install Vundle
  `git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim` unless -d "${HOME}/.vim/bundle/Vundle.vim";

  # Compose .vimrc
  my %enabled_configs;

  # Install Dash plugin
  $enabled_configs{"dash"} = 1 if $ENABLE_DASH;

  fill_template("${HOME}/.vimrc", "vim/vimrc", \%enabled_configs, "\"");

  # Install ftplugin
  mkdir_unless_exists("${HOME}/.vim/ftplugin");
  `cp vim_common/ftplugin/*.vim ${HOME}/.vim/ftplugin`;

  print "Start vim and run :PluginInstall manually\n";
}

sub install_tmux {
  my $linux_powerline = "/usr/share/powerline/bindings/tmux/powerline.conf";
  my %enabled_configs;

  if ($^O eq "linux" and -e "/usr/bin/apt-get") {
    unless (-e $linux_powerline) {
      print "Installing Powerline...\n";
      `sudo apt-get -y install powerline` 
    }

    print "Use Powerline for tmux theme\n";
    $enabled_configs{"powerline"} = 1;
  } else {
    print "Use customized tmux theme\n";
    $enabled_configs{"simpletheme"} = 1;
  }

  fill_template("${HOME}/.tmux.conf", "tmux/tmux.conf", \%enabled_configs);
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
  while (my ($target, $installer) = each %all_targets) {
    &{$installer};
    print "Finish installing $target\n";
  }

  print "Finish installing all\n";
} else {
  foreach my $target (@install_targets) {
    &{$all_targets{$target}} if exists $all_targets{$target};
    print "Finish installing $target\n";
  }
}

