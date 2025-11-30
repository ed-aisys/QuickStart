#!/bin/bash

# Parse command line arguments
INSTALL_ALL=false
for arg in "$@"; do
	case $arg in
	--all)
		INSTALL_ALL=true
		shift
		;;
	-h | --help)
		echo "Usage: sudo $0 [OPTIONS]"
		echo ""
		echo "Options:"
		echo "  --all     Install all packages without prompting"
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
	echo "Package: $tool_name"
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

# Always update apt first
sudo apt update

# Basic shell and network tools
if ask_install "basic-tools" "zsh, wget, curl - Essential shell and network utilities"; then
	sudo apt install zsh wget curl -y
fi

# Build essentials
if ask_install "build-tools" "rsync, git, build-essential - Development build tools"; then
	sudo apt install rsync git build-essential -y
fi

# GUI/Display libraries (for Anaconda/Python GUI apps)
if ask_install "gui-libs" "OpenGL, X11 libraries - Required for Anaconda and GUI applications"; then
	sudo apt-get install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6 -y
fi

# Pyenv dependencies
if ask_install "pyenv-deps" "SSL, readline, sqlite, etc. - Required libraries for pyenv/Python compilation"; then
	sudo apt install libssl-dev libcurses-perl libbz2-dev libctypes-ocaml-dev libreadline-dev libsqlite3-dev liblzma-dev libffi-dev -y
fi

# GitHub CLI
if ask_install "gh" "GitHub CLI - Official GitHub command line tool"; then
	(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) &&
		sudo mkdir -p -m 755 /etc/apt/keyrings &&
		wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null &&
		sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg &&
		echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
		sudo apt update &&
		sudo apt install gh -y
fi

# CLI enhancement tools
if ask_install "cli-tools" "fd-find, silversearcher-ag, htop - Better find, grep, and process viewer"; then
	sudo apt install fd-find silversearcher-ag htop -y
fi

# bat (better cat)
if ask_install "bat" "bat - A cat clone with syntax highlighting"; then
	sudo apt install bat -y
fi

echo ""
echo "========================================"
echo "System package installation complete!"
echo "========================================"
