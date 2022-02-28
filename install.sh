#!/usr/bin/env bash
set -euo pipefail

NC='\033[0m'

function echo_bold() {      echo -ne "\033[0;1;34m${*}${NC}\n"; }
function echo_danger() {    echo -ne "\033[1;31m${*}${NC}\n"; }
function echo_success() {   echo -ne "\033[1;32m${*}${NC}\n"; }
function echo_warning() {   echo -ne "\033[1;33m${*}${NC}\n"; }
function echo_secondary() { echo -ne "\033[0;34m${*}${NC}\n"; }
function echo_info() {      echo -ne "\033[0;35m${*}${NC}\n"; }
function echo_primary() {   echo -ne "\033[0;36m${*}${NC}\n"; }
function echo_error() {     echo -ne "\033[0;1;31merror:\033[0;31m\t${*}${NC}\n"; }
function echo_label() {     echo -ne "\033[0;1;32m${*}:${NC}\t"; }
function echo_prompt() {    echo -ne "\033[0;36m${*}${NC} "; }

export DENO_INSTALL=/usr/local

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

export ZSH="${XDG_CONFIG_HOME}/omzsh"
export NVM_DIR="${XDG_DATA_HOME}/nvm"
export ADOTDIR="${XDG_CONFIG_HOME}/antigen/"

chsh -s $(which zsh)

echo_prompt "Should github cli be installed (y/n) ?"
read ghcli
echo_prompt "Should deno be installed (y/n) ?"
read deno
echo_prompt "Should nvm be installed (y/n) ?"
read nvm

if [[ $ghcli == "y" ]]; then
    echo_info "Installing github cli..."
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    apt update
    apt install gh
else
    echo_warning "Skipping github cli..."
fi

if [[ $deno == "y" ]]; then
    echo_info "Installing deno..."
    curl -fsSL https://deno.land/x/install/install.sh | sh
else
    echo_warning "Skipping deno..."
fi

if [[ $nvm == "y" ]]; then
    echo_info "Installing nvm..."
    git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR" && cd "$NVM_DIR" && git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)` && . "$NVM_DIR/nvm.sh"
else
    echo_warning "Skipping nvm..."
fi

## Cleaning home before installing dotfiles
## Fix rm error causing script to end because of line 2
ls -1 $HOME/.bash* 2>/dev/null && rm $HOME/.bash*
rm $HOME/.profile

echo_info "Installing dotfiles"
git clone https://github.com/ozakione/dotfiles .dotfiles && mkdir $XDG_CACHE_HOME ; cd $HOME/.dotfiles && stow neovim p10k profile

echo_info "Installing omzsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
rm $HOME/.zshrc ; rm $HOME/.zshrc.pre-oh-my-zsh

echo_info "Installing antigen"
mkdir $ADOTDIR ; curl -fsSL git.io/antigen > ${ADOTDIR}antigen.zsh

git config --global core.editor "code -n -w"

## Always at the end
cd $HOME/.dotfiles && stow zsh
echo_success "Now type exit and open again wsl or restart your computer"
