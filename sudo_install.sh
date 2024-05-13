sudo apt update
sudo apt install zsh wget curl -y
sudo apt install rsync git build-essential -y

sudo apt-get install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6 -y
sudo apt install libssl-dev libcurses-perl libbz2-dev libctypes-ocaml-dev libreadline-dev libsqlite3-dev liblzma-dev libffi-dev -y

(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) &&
	sudo mkdir -p -m 755 /etc/apt/keyrings &&
	wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null &&
	sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg &&
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
	sudo apt update &&
	sudo apt install gh -y

sudo apt install fd-find silversearcher-ag htop -y
sudo apt install bat -y
