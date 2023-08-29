# Configuration

These configurations are the ones I use daily. I keep them in this repo for
convenience.

## Usage

- **all**: `./install.pl --all`
- **tmux.conf**: `./install.pl tmux`
- **vimrc**: `./install.pl vim`
- **neovim**: `./install.pl neovim`
- **fish**: `./install.pl fish`

## Help

```
install.pl [options] <targets>
targets:
    fish
    neovim
    tmux
    vim
options:
    --ycm install ycm to neovim
    --dash install dash extension to vim and neovim
    --lsp enable LSP support for neovim
    --all install all targets
    --h show this help
```
