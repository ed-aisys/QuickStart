#!/bin/bash

QINDIR=$(pwd)

# Parse command line arguments
INSTALL_ALL=false
for arg in "$@"; do
	case $arg in
	--all)
		INSTALL_ALL=true
		shift
		;;
	-h | --help)
		echo "Usage: $0 [OPTIONS]"
		echo ""
		echo "Options:"
		echo "  --all     Install all tools without prompting"
		echo "  -h, --help    Show this help message"
		exit 0
		;;
	esac
done

# Function to ask user for confirmation
ask_install() {
	local tool_name="$1"
	local tool_desc="$2"

	if [[ "$INSTALL_ALL" == "true" ]]; then
		return 0
	fi

	echo ""
	echo "----------------------------------------"
	echo "Tool: $tool_name"
	echo "Description: $tool_desc"
	echo "----------------------------------------"
	while true; do
		read -p "Install $tool_name? [y/n]: " yn
		case $yn in
		[Yy]*)
			return 0
			;;
		[Nn]*)
			return 1
			;;
		*)
			echo "Please answer y or n."
			;;
		esac
	done
}

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

# Create necessary directories (always)
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

if [[ ! -e $HOME/opt ]]; then
	mkdir -p $HOME/opt
fi

# Pyenv
if ask_install "pyenv" "Python version management tool"; then
	if [[ ! -e $HOME/.pyenv ]]; then
		curl https://pyenv.run | bash
	else
		echo "pyenv already installed, skipping..."
	fi
fi

# vimrc
if ask_install "vimrc" "Ultimate Vim configuration from amix/vimrc"; then
	if [[ ! -e $HOME/.vim_runtime ]]; then
		git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
		sh ~/.vim_runtime/install_basic_vimrc.sh
	else
		echo "vimrc already installed, skipping..."
	fi
fi

# nvim
if ask_install "nvim" "Neovim editor with ChivierLazyNvim configuration"; then
	if [[ -e $HOME/.config/nvim ]]; then
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
fi

# tmux
if ask_install "tmux" "Terminal multiplexer with gpakosz/.tmux configuration"; then
	cd
	if [[ ! -e $HOME/.tmux ]]; then
		git clone https://github.com/gpakosz/.tmux.git
	fi
	ln -s -f .tmux/.tmux.conf
	cp .tmux/.tmux.conf.local .
fi

# zsh
if ask_install "zsh-config" "Zsh configuration with oh-my-zsh and zinit"; then
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
fi

# Projects directory
if ask_install "Projects-dir" "Create ~/Projects directory"; then
	cd
	mkdir -p Projects
fi

# zellij
if ask_install "zellij" "Terminal workspace manager (alternative to tmux)"; then
	if [[ ! -e $HOME/.local/bin/zellij ]]; then
		cd $HOME/opt
		wget https://github.com/zellij-org/zellij/releases/download/v0.40.1/zellij-x86_64-unknown-linux-musl.tar.gz
		tar xzvf zellij-x86_64-unknown-linux-musl.tar.gz
		chmod +x ./zellij
		mv zellij $HOME/.local/bin/zellij
		rm zellij-x86_64-unknown-linux-musl.tar.gz
	else
		echo "zellij already installed, skipping..."
	fi
fi

# lazygit
if ask_install "lazygit" "Simple terminal UI for git commands"; then
	if [[ ! -e $HOME/.local/bin/lg ]]; then
		cd $HOME/opt
		LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
		curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
		tar xf lazygit.tar.gz lazygit
		mv lazygit $HOME/.local/bin/lg
	else
		echo "lazygit already installed, skipping..."
	fi
fi

# Symlinks for CLI tools
if ask_install "cli-symlinks" "Create symlinks for fd, bat, lg in ~/.local/bin"; then
	if [[ ! -e $HOME/.local/bin/fd ]]; then
		ln -s $(which fdfind) ~/.local/bin/fd 2>/dev/null || echo "fdfind not found, skipping fd symlink"
	fi
	if [[ ! -e $HOME/.local/bin/bat ]]; then
		ln -s /usr/bin/batcat ~/.local/bin/bat 2>/dev/null || echo "batcat not found, skipping bat symlink"
	fi
	if [[ ! -e $HOME/.local/bin/lg ]]; then
		ln -s $(which lazygit) ~/.local/bin/lg 2>/dev/null || echo "lazygit not found, skipping lg symlink"
	fi
fi

echo ""
echo "========================================"
echo "Installation complete!"
echo "========================================"
