# minpac package manager

Installation
------------

Minpac should be installed under `pack/minpac/opt/` in the first directory
in the `'packpath'` option.
Plugins installed under `pack/*/start/` are automatically added to the `'runtimepath'` after `.vimrc` is sourced. However, minpac needs to be loaded before that. Therefore, minpac should be installed under "opt" directory, and should be loaded using `packadd minpac`.

### Windows

Vim:

```cmd
git clone https://github.com/k-takata/minpac.git %USERPROFILE%\vimfiles\pack\minpac\opt\minpac
```

Neovim:

```cmd
git clone https://github.com/k-takata/minpac.git %LOCALAPPDATA%\nvim\pack\minpac\opt\minpac
```

### Linux, macOS

Vim:

```sh
git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac
```

Neovim (use `$XDG_CONFIG_HOME` in place of `~/.config` if set on your system):

```sh
git clone https://github.com/k-takata/minpac.git ~/.config/nvim/pack/minpac/opt/minpac
```

# vim-plug package manager

Installation

[Download plug.vim](https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim)
and put it in the "autoload" directory.

## Vim

### Unix

```sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

You can automate the process by putting the command in your Vim configuration
file as suggested [here][auto].

[auto]: https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation

### Windows (PowerShell)

```powershell
iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni $HOME/vimfiles/autoload/plug.vim -Force
```

## Neovim

### Unix, Linux

```sh
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

### Linux (Flatpak)

```sh
curl -fLo ~/.var/app/io.neovim.nvim/data/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### Windows (PowerShell)

```powershell
iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force
```

# Vundle package manager

```sh
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```
