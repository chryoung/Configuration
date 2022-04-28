.PHONY: all neovim tmux vim
all: neovim tmux vim

neovim:
	if [ ! -d ${HOME}/.config/nvim/lua ]; then mkdir -p ${HOME}/.config/nvim/lua; fi
	if [ ! -e ${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim ]; then git clone --depth=1 https://github.com/wbthomason/packer.nvim ${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim; fi
	install neovim/init.vim ${HOME}/.config/nvim/
	install neovim/lua/plugins.lua ${HOME}/.config/nvim/lua/
	install neovim/lua/config.lua ${HOME}/.config/nvim/lua/
	@echo Start nvim and run :PackerSync manually

vim: vimrc
	if [ ! -d ${HOME}/.vim/bundle/Vundle.vim ]; then git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim; fi
	install vimrc ${HOME}/.vimrc
	@echo Start vim and run :PluginInstall manually

tmux: tmux.conf
	if [ ! -e /usr/share/powerline/bindings/tmux/powerline.conf ]; then sudo apt install powerline; fi
	install tmux.conf ${HOME}/.tmux.conf

simple_tmux: tmux.conf simple_tmux_theme.conf
	install tmux.conf ${HOME}/.tmux.conf
	sed -i -e '1,10d' ${HOME}/.tmux.conf
	cat simple_tmux_theme.conf >> ${HOME}/.tmux.conf
