#!/bin/bash

QINDIR=$(pwd)
# SSH prepare
# if [[ -e $HOME/.ssh/id_rsa && -e $HOME/.ssh/id_rsa.pub ]]; then
# 	echo "Copy public key"
# 	cat $HOME/.ssh/id_rsa.pub
# else
# 	echo "Generating public key"
# 	ssh-keygen
# 	echo "Copy public key"
# 	cat $HOME/.ssh/id_rsa.pub
# fi

if [[ ! -e $HOME/.local ]]; then
	mkdir -p $HOME/.local
fi

if [[ ! -e $HOME/.local/bin ]]; then
	mkdir -p $HOME/.local/bin
fi
if [[ ! -e $HOME/.local/lib ]]; then
	mkdir -p $HOME/.local/lib
fi
if [[ ! -e $HOME/.local/share ]]; then
	mkdir -p $HOME/.local/share
fi

# Pyenv
if [[ ! -e $HOME/.pyenv ]]; then
	curl https://pyenv.run | bash
fi

if [[ ! -e $HOME/opt ]]; then
	mkdir -p $HOME/opt
fi

# vimrc
if [[ ! -e $HOME/.vim_runtime ]]; then
	git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
	sh ~/.vim_runtime/install_basic_vimrc.sh
fi

# nvim
if [[ ! -e $HOME/.config/nvim ]]; then
	mv $HOME/.config/nvim $HOME/.config/nvim_backup
fi
cd $HOME/opt
wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
tar xf nvim-linux64.tar.gz
cd nvim-linux64
rsync -avhu bin/* $HOME/.local/bin/
rsync -avhu lib/* $HOME/.local/lib/
rsync -avhu share/* $HOME/.local/share/
git clone https://github.com/Chivier/ChivierLazyNvim.git ~/.config/nvim

# tmux
cd
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .

# zsh
cd $QINDIR

tar xzvf zsh.tar.gz

if [[ ! -e $HOME/.oh-my-zsh ]]; then
	mv .oh-my-zsh $HOME
fi

if [[ ! -e $HOME/.zinit ]]; then
	mv .zinit $HOME
fi

if [[ ! -e $HOME/.zshrc ]]; then
	cp zshrc $HOME/.zshrc
fi

cd
chown -R $USER .oh-my-zsh
chown -R $USER .zinit
chown -R $USER .zshrc

cd
cd .oh-my-zsh/custom/plugins
rm -rf zenplash
git clone https://github.com/Chivier/zenplash.git

# Projects
cd
mkdir Projects

# zellij
if [[ ! -e $HOME/.local/bin/zellij ]]; then
	wget https://github.com/zellij-org/zellij/releases/download/v0.40.1/zellij-x86_64-unknown-linux-musl.tar.gz
	tar xzvf zellij-x86_64-unknown-linux-musl.tar.gz
	chmod +x ./zellij
	mv zellij $HOME/.local/bin/zellij
	rm zellij-x86_64-unknown-linux-musl.tar.gz
fi

# lazygit
if [[ ! -e $HOME/.local/bin/lg ]]; then
	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
	tar xf lazygit.tar.gz lazygit
	mv lazygit $HOME/.local/bin/lg
fi

if [[ ! -e $HOME/.local/bin/fd ]]; then
	ln -s $(which fdfind) ~/.local/bin/fd
fi
if [[ ! -e $HOME/.local/bin/bat ]]; then
	ln -s /usr/bin/batcat ~/.local/bin/bat
fi
if [[ ! -e $HOME/.local/bin/lg ]]; then
	ln -s $(which lazygit) ~/.local/bin/lg
fi
