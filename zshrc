# Stop auto update
DISABLE_AUTO_UPDATE="true"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/usr/local/bin:$HOME/.local/bin:$PATH
export LD_LIBRARY_PATH=$HOME/.local/lib:/usr/local/lib:$LD_LIBRARY_PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export LANG="en_US.utf8"
export LC_CTYPE="zh_CN.utf8"
export LC_ALL="en_US.utf8"

# local env variables
# THEME
ZSH_THEME="chivier"
plugins=(git colored-man-pages vi-mode zshmarks zenplash docker docker-compose)
source $ZSH/oh-my-zsh.sh

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-bin-gem-node

zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/fast-syntax-highlighting

# Plugin history-search-multi-word loaded with investigating.
zinit load zdharma/history-search-multi-word
zinit load zsh-users/zsh-history-substring-search

# A glance at the new for-syntax – load all of the above
# plugins with a single command. For more information see:
# https://zdharma.org/zinit/wiki/For-Syntax/
zinit for \
    light-mode  zsh-users/zsh-autosuggestions \
    light-mode  zdharma/fast-syntax-highlighting \
                zdharma/history-search-multi-word 
### End of Zinit's installer chunk

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

# My aliases

#Frequently used files or folders
alias lll="cd ~/Projects"

# Vim mode
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^[OQ" edit-command-line
export EDITOR=/usr/bin/vim

# Pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH=$PYENV_ROOT/shims:$PATH
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/chivier/.pyenv/versions/anaconda3-2024.02-1/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
    conda config --set auto_activate_base False
else
    if [ -f "/home/chivier/.pyenv/versions/anaconda3-2024.02-1/etc/profile.d/conda.sh" ]; then
        . "/home/chivier/.pyenv/versions/anaconda3-2024.02-1/etc/profile.d/conda.sh"
        conda config --set auto_activate_base False
    else
        export PATH="/home/chivier/.pyenv/versions/anaconda3-2024.02-1/bin:$PATH"
        conda config --set auto_activate_base False
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
#
