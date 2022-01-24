#!/usr/bin/env bash
set -euo pipefail

RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'

DENO_INSTALL=/usr/local

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

export ZSH="${XDG_CONFIG_HOME}/omzsh"
export NVM_DIR="${XDG_DATA_HOME}/nvm"
export ADOTDIR="${XDG_CONFIG_HOME}/antigen/"

chsh -s $(which zsh)

echo -e "\n${GREEN}Should github cli be installed (y/n) ?${NC}"
read ghcli
echo -e "\n${GREEN}Should deno be installed (y/n) ?${NC}"
read deno
echo -e "\n${GREEN}Should nvm be installed (y/n) ?${NC}"
read nvm

if [[ $ghcli == "y" ]]; then
    echo -e "\n${GREEN}Installing github cli...${NC}"
    apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
    apt-add-repository https://cli.github.com/packages
    apt update
    apt install gh
else
    echo -e "\n${RED}Skipping github cli...${NC}"
fi

if [[ $deno == "y" ]]; then
    echo -e "\n${GREEN}Installing deno...${NC}"
    curl -fsSL https://deno.land/x/install/install.sh | sh
else
    echo -e "\n${RED}Skipping deno...${NC}"
fi

if [[ $nvm == "y" ]]; then
    echo -e "\n${GREEN}Installing nvm...${NC}"
    git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR" && cd "$NVM_DIR" && git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)` && . "$NVM_DIR/nvm.sh"
else
    echo -e "\n${RED}Skipping nvm...${NC}"
fi

## Cleaning home before installing dotfiles
ls -1 $HOME/.bash* 2>/dev/null && rm $HOME/.bash*
rm $HOME/.profile

echo -e "\nInstalling dotfiles\n"
git clone https://github.com/ozakione/dotfiles .dotfiles && mkdir $XDG_CACHE_HOME ; cd $HOME/.dotfiles && stow neovim p10k profile

echo -e "\nInstalling antigen\n"
mkdir $ADOTDIR ; curl -fsSL git.io/antigen > ${ADOTDIR}antigen.zsh



## Always at the end
cd $HOME/.dotfiles && stow zsh
echo -e "\nNow type exit and open again wsl\n"
