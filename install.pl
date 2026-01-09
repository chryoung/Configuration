#!/usr/bin/env perl
use strict;
use warnings;

use Env qw/HOME/;
use Getopt::Long qw(GetOptions);
use File::Path qw(make_path);
use File::Spec;
use File::Basename qw(dirname);
use File::Temp qw(tempfile);
use File::Copy qw(move);
use File::Glob qw(bsd_glob);
use FindBin qw($Bin);
use Cwd qw(abs_path);

# ----------------------------
# Global flags / options
# ----------------------------
my $ENABLE_YCM          = 0;
my $ENABLE_DASH         = 0;
my $ENABLE_LSP          = 0;
my $NVIM_DEFAULT_EDITOR = 0;

my $INSTALL_ALL         = 0;
my $SHOW_HELP           = 0;

my $DRY_RUN             = 0;
my $VERBOSE             = 0;
my $ASSUME_YES          = 0;   # non-interactive / CI friendly

# Repo root (script directory)
my $REPO = abs_path($Bin);

# ----------------------------
# Helpers
# ----------------------------

sub log_info  { print "[INFO]  @_\n"; }
sub log_warn  { print "[WARN]  @_\n"; }
sub log_error { print "[ERROR] @_\n"; }

sub run_cmd {
  my (@cmd) = @_;

  my $pretty = join(" ", map { _shell_escape($_) } @cmd);
  log_info($pretty) if $VERBOSE || $DRY_RUN;

  return 1 if $DRY_RUN;

  system(@cmd) == 0 or die "Command failed ($pretty), exit=$?\n";
  return 1;
}

sub _shell_escape {
  my ($s) = @_;
  return "''" if !defined $s || $s eq '';
  # Conservative quoting for display only (we don't execute through shell)
  $s =~ s/'/'\\''/g;
  return "'$s'";
}

sub ensure_dir {
  my ($dir) = @_;
  return if -d $dir;
  log_info("Creating directory: $dir") if $VERBOSE || $DRY_RUN;
  return if $DRY_RUN;
  make_path($dir, { mode => 0755 }) or die "Cannot create directory $dir: $!\n";
}

sub timestamp {
  my @t = localtime();
  return sprintf("%04d%02d%02d-%02d%02d%02d",
    $t[5] + 1900, $t[4] + 1, $t[3], $t[2], $t[1], $t[0]
  );
}

sub backup_if_exists {
  my ($path) = @_;
  return unless -e $path || -l $path;

  # If it's a symlink, we still back it up (safe default).
  my $bak = $path . ".bak." . timestamp();
  log_warn("Backing up existing '$path' -> '$bak'");
  return 1 if $DRY_RUN;

  move($path, $bak) or die "Failed to backup $path -> $bak: $!\n";
  return 1;
}

sub safe_write_file_atomic {
  my ($dest, $content_ref) = @_;

  my $dest_dir = dirname($dest);
  ensure_dir($dest_dir);

  backup_if_exists($dest);

  my ($fh, $tmp) = tempfile(".tmp-XXXXXX", DIR => $dest_dir, UNLINK => 0);
  print $fh $$content_ref;
  close $fh or die "Failed to close temp file $tmp: $!\n";

  log_info("Writing $dest (atomic)") if $VERBOSE || $DRY_RUN;
  return 1 if $DRY_RUN;

  move($tmp, $dest) or die "Failed to move $tmp -> $dest: $!\n";
  return 1;
}

sub read_file {
  my ($path) = @_;
  open my $fh, "<", $path or die "Cannot open $path: $!\n";
  local $/ = undef;
  my $content = <$fh>;
  close $fh;
  return $content;
}

sub append_line_if_missing {
  my ($file, $line) = @_;
  my $needle = $line;
  $needle =~ s/\R\z//; # strip trailing newline for matching

  my $existing = "";
  $existing = read_file($file) if -e $file;

  if (index($existing, $needle) >= 0) {
    log_info("Line already present in $file") if $VERBOSE;
    return 1;
  }

  log_info("Appending to $file: $needle") if $VERBOSE || $DRY_RUN;
  return 1 if $DRY_RUN;

  open my $fh, ">>", $file or die "Cannot open $file for append: $!\n";
  print $fh "\n$needle\n";
  close $fh;
  return 1;
}

sub ask_for {
  my ($question, $confirm, $dict, $key, $confirm_message) = @_;
  $confirm_message //= "";

  if ($ASSUME_YES) {
    $dict->{$key} = 1;
    print $confirm_message if $confirm_message;
    return 1;
  }

  # If not interactive, default to "no" (safe) unless --yes was passed.
  if (!-t *STDIN) {
    log_warn("Non-interactive STDIN; skipping prompt '$question' (default: No). Use --yes to auto-enable.");
    return 0;
  }

  print $question;
  chomp(my $user_input = <STDIN> // "");
  if ($user_input eq $confirm) {
    $dict->{$key} = 1;
    print $confirm_message if $confirm_message;
    return 1;
  }
  return 0;
}

sub fill_template_to_string {
  my ($template_path, $enabled_configs, $comment) = @_;
  $enabled_configs //= {};
  $comment         //= "#";

  open my $template_fh, "<", $template_path
    or die "Cannot open template $template_path: $!\n";

  my $current_config = "";
  my $will_print_current_config = 0;
  my $out = "";

  while (my $line = <$template_fh>) {
    if ($line =~ m!^\Q$comment\E<<<([^/>]+)>>>$!) {
      $current_config = $1;
      $will_print_current_config = exists $enabled_configs->{$current_config} ? 1 : 0;
      next;
    }

    if ($current_config && $line =~ m!^\Q$comment\E<<</\Q$current_config\E>>>$!) {
      $current_config = "";
      $will_print_current_config = 0;
      next;
    }

    if (($current_config && $will_print_current_config) || !$current_config) {
      $out .= $line;
    }
  }

  close $template_fh;
  return $out;
}

sub copy_files_by_glob {
  my ($pattern, $dest_dir) = @_;
  ensure_dir($dest_dir);

  my @files = bsd_glob($pattern, GLOB_NOCHECK);
  # If no match, bsd_glob returns the pattern itself when GLOB_NOCHECK is set.
  if (@files == 1 && $files[0] eq $pattern) {
    log_warn("No files matched pattern: $pattern");
    return 1;
  }

  for my $src (@files) {
    next unless -f $src;
    my $base = File::Basename::basename($src);
    my $dest = File::Spec->catfile($dest_dir, $base);

    backup_if_exists($dest);
    run_cmd("cp", $src, $dest);
  }
  return 1;
}

sub os_flavor {
  # returns: macos | ubuntu | linux | other
  if ($^O eq "darwin") {
    return "macos";
  }
  if ($^O eq "linux") {
    # Ubuntu / Debian check: /etc/os-release contains ID=ubuntu
    if (-e "/etc/os-release") {
      my $osr = eval { read_file("/etc/os-release") } // "";
      return "ubuntu" if $osr =~ /^ID=ubuntu$/m;
      return "linux";
    }
    return "linux";
  }
  return "other";
}

# ----------------------------
# Installers
# ----------------------------

sub install_neovim {
  my $neovim_config_home = File::Spec->catdir($HOME, ".config", "nvim");
  ensure_dir(File::Spec->catdir($neovim_config_home, "lua"));

  # Install packer if missing (legacy but still works)
  my $packer_vim = File::Spec->catfile($HOME, ".local", "share", "nvim", "site", "pack", "packer", "start", "packer.nvim");
  unless (-e $packer_vim) {
    ensure_dir(dirname($packer_vim));
    run_cmd("git", "clone", "--depth=1", "https://github.com/wbthomason/packer.nvim", $packer_vim);
  }

  my %enabled_configs;
  $enabled_configs{"dash"} = 1 if $ENABLE_DASH;
  $enabled_configs{"ycm"}  = 1 if $ENABLE_YCM;

  if ($ENABLE_LSP) {
    $enabled_configs{"lsp"} = 1;

    my %lsp_config = (
      "lsp_perl" => {
        lsp => "PLS",
        language => "Perl",
        message => "Enabled. Remember: `sudo cpan install -f PLS`\n",
      },
      "lsp_python" => {
        lsp => "pyright",
        language => "Python",
        message => "Enabled. Remember: `pip install pyright`\n",
      },
      "lsp_rust" => {
        lsp => "rust-analyzer",
        language => "Rust",
        message => "",
      },
      "lsp_clangd" => {
        lsp => "clangd",
        language => "C/C++",
        message => "",
      },
    );

    while (my ($k, $v) = each %lsp_config) {
      ask_for(
        sprintf("Enable %s LSP for %s in Neovim? [y/N]: ", $v->{lsp}, $v->{language}),
        "y",
        \%enabled_configs,
        $k,
        $v->{message}
      );
    }

    # Copy LSP configuration file
    my $src = File::Spec->catfile($REPO, "nvim", "neovim", "plugin", "lsp.lua");
    my $dst_dir = File::Spec->catdir($neovim_config_home, "plugin");
    ensure_dir($dst_dir);
    my $dst = File::Spec->catfile($dst_dir, "lsp.lua");

    backup_if_exists($dst);
    run_cmd("cp", $src, $dst);
  }

  # impatient plugin conflicts with Dash, so enable it only when Dash is not enabled
  $enabled_configs{"impatient"} = 1 unless $ENABLE_DASH;

  # Compose init.vim / lua files from templates (atomic + backup)
  my $init_template = File::Spec->catfile($REPO, "nvim", "neovim", "init.vim");
  my $config_template = File::Spec->catfile($REPO, "nvim", "neovim", "lua", "config.lua");
  my $plugins_template = File::Spec->catfile($REPO, "nvim", "neovim", "lua", "plugins.lua");

  my $init_out    = fill_template_to_string($init_template,    \%enabled_configs, "\"");
  my $config_out  = fill_template_to_string($config_template,  \%enabled_configs, "--");
  my $plugins_out = fill_template_to_string($plugins_template, \%enabled_configs, "--");

  safe_write_file_atomic(File::Spec->catfile($neovim_config_home, "init.vim"), \$init_out);
  safe_write_file_atomic(File::Spec->catfile($neovim_config_home, "lua", "config.lua"), \$config_out);
  safe_write_file_atomic(File::Spec->catfile($neovim_config_home, "lua", "plugins.lua"), \$plugins_out);

  # Install ftplugin files (copy; backup if overwriting)
  copy_files_by_glob(File::Spec->catfile($REPO, "vim_common", "ftplugin", "*.vim"),
                     File::Spec->catdir($neovim_config_home, "ftplugin"));

  log_info("Neovim installed. Start nvim and run :PackerSync manually.");
}

sub install_vim {
  # Vundle
  my $vundle_dir = File::Spec->catdir($HOME, ".vim", "bundle", "Vundle.vim");
  unless (-d $vundle_dir) {
    ensure_dir(dirname($vundle_dir));
    run_cmd("git", "clone", "--depth=1", "https://github.com/VundleVim/Vundle.vim.git", $vundle_dir);
  }

  my %enabled_configs;
  $enabled_configs{"dash"} = 1 if $ENABLE_DASH;

  my $vimrc_template = File::Spec->catfile($REPO, "vim", "vimrc");
  my $vimrc_out      = fill_template_to_string($vimrc_template, \%enabled_configs, "\"");

  safe_write_file_atomic(File::Spec->catfile($HOME, ".vimrc"), \$vimrc_out);

  copy_files_by_glob(File::Spec->catfile($REPO, "vim_common", "ftplugin", "*.vim"),
                     File::Spec->catdir($HOME, ".vim", "ftplugin"));

  log_info("Vim installed. Start vim and run :PluginInstall manually.");
}

sub install_tmux {
  my $flavor = os_flavor();
  my %enabled_configs;

  if ($flavor eq "ubuntu" && -e "/usr/bin/apt-get") {
    my $linux_powerline = "/usr/share/powerline/bindings/tmux/powerline.conf";
    unless (-e $linux_powerline) {
      log_info("Installing Powerline (apt)...");
      run_cmd("sudo", "apt-get", "update");
      run_cmd("sudo", "apt-get", "-y", "install", "powerline");
    }
    log_info("Using Powerline theme for tmux.");
    $enabled_configs{"powerline"} = 1;
  } else {
    # macOS or non-Ubuntu Linux: don't auto-install; just use the simple theme.
    log_info("Using customized tmux theme (non-apt platform or powerline not managed here).");
    $enabled_configs{"simpletheme"} = 1;
  }

  my $tmux_template = File::Spec->catfile($REPO, "tmux", "tmux.conf");
  my $tmux_out      = fill_template_to_string($tmux_template, \%enabled_configs, "#");

  safe_write_file_atomic(File::Spec->catfile($HOME, ".tmux.conf"), \$tmux_out);
}

sub install_fish {
  my $fish_dir = File::Spec->catdir($HOME, ".config", "fish");
  ensure_dir($fish_dir);

  # Copy fish config directory contents (keeps your old behavior but with better logging + no shell interpolation)
  my $src = File::Spec->catfile($REPO, "fish");
  run_cmd("cp", "-R", File::Spec->catfile($src, "."), $fish_dir);

  unless ($NVIM_DEFAULT_EDITOR) {
    my $editor_conf = File::Spec->catfile($fish_dir, "conf.d", "editor.fish");
    my $vim_func    = File::Spec->catfile($fish_dir, "functions", "vim.fish");

    if (-e $editor_conf || -l $editor_conf) {
      backup_if_exists($editor_conf);
      run_cmd("rm", "-f", $editor_conf);
    }
    if (-e $vim_func || -l $vim_func) {
      backup_if_exists($vim_func);
      run_cmd("rm", "-f", $vim_func);
    }
  }

  log_info("Fish installed.");
}

sub install_asdf {
  log_info("Installing asdf-vm...");
  my $asdf_dir = File::Spec->catdir($HOME, ".asdf");
  unless (-d $asdf_dir) {
    run_cmd("git", "clone", "https://github.com/asdf-vm/asdf.git", $asdf_dir, "--branch", "v0.14.0");
  } else {
    log_info("asdf already exists at $asdf_dir");
  }

  my $fish_config = File::Spec->catfile($HOME, ".config", "fish", "config.fish");
  ensure_dir(dirname($fish_config));
  # Ensure file exists (don't destroy content)
  if (!-e $fish_config) {
    my $empty = "";
    safe_write_file_atomic($fish_config, \$empty);
  }

  append_line_if_missing($fish_config, "source ~/.asdf/asdf.fish");

  my $comp_dir = File::Spec->catdir($HOME, ".config", "fish", "completions");
  ensure_dir($comp_dir);

  my $src = File::Spec->catfile($asdf_dir, "completions", "asdf.fish");
  my $dst = File::Spec->catfile($comp_dir, "asdf.fish");

  if (-l $dst) {
    log_info("asdf completion symlink already exists: $dst") if $VERBOSE;
  } elsif (-e $dst) {
    backup_if_exists($dst);
    run_cmd("ln", "-s", $src, $dst);
  } else {
    run_cmd("ln", "-s", $src, $dst);
  }

  log_info("asdf installed (fish integration done).");
}

# ----------------------------
# CLI parsing and dispatch
# ----------------------------

GetOptions(
  "ycm"     => \$ENABLE_YCM,
  "dash"    => \$ENABLE_DASH,
  "lsp"     => \$ENABLE_LSP,
  "nvim"    => \$NVIM_DEFAULT_EDITOR,
  "all"     => \$INSTALL_ALL,
  "h|help"  => \$SHOW_HELP,

  "dry-run" => \$DRY_RUN,
  "v|verbose" => \$VERBOSE,
  "yes"     => \$ASSUME_YES,
) or die "Invalid options. Use --help\n";

my @install_targets = @ARGV;

my %all_targets = (
  "vim"    => \&install_vim,
  "neovim" => \&install_neovim,
  "tmux"   => \&install_tmux,
  "fish"   => \&install_fish,
  "asdf"   => \&install_asdf,
);

sub print_help {
  print <<"EOF";
install.pl [options] <targets>

Targets:
EOF
  foreach my $target (sort keys %all_targets) {
    print "  $target\n";
  }

  print <<"EOF";

Options:
  --ycm         Enable YCM config (Neovim)
  --dash        Enable Dash config (Vim/Neovim)
  --lsp         Enable LSP support (Neovim) and prompt per language
  --nvim        Use nvim as default editor in fish config (keeps editor.fish/vim.fish)

  --all         Install all targets
  -h, --help    Show this help

  --dry-run     Print actions, do not modify system
  -v, --verbose Show commands being executed
  --yes         Auto-answer "yes" to prompts (useful for CI)

Examples:
  ./install.pl --all
  ./install.pl --dash --lsp neovim tmux fish
  ./install.pl --dry-run --verbose --all
EOF
}

if ($SHOW_HELP) {
  print_help();
  exit 0;
}

if ($INSTALL_ALL) {
  for my $target (sort keys %all_targets) {
    log_info("== Installing $target ==");
    $all_targets{$target}->();
    log_info("Finish installing $target");
  }
  log_info("Finish installing all.");
  exit 0;
}

if (!@install_targets) {
  log_error("No targets provided. Use --help.");
  exit 1;
}

for my $target (@install_targets) {
  if (!exists $all_targets{$target}) {
    log_warn("Unknown target '$target' (skipped).");
    next;
  }
  log_info("== Installing $target ==");
  $all_targets{$target}->();
  log_info("Finish installing $target");
}

exit 0;
