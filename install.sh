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

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export HISTFILE="${XDG_CONFIG_HOME}/zsh/history"
export ZSH="${XDG_CONFIG_HOME}/omzsh"
export ADOTDIR="${XDG_CONFIG_HOME}/antigen/"
export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc"
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export FFMPEG_DATADIR="${XDG_CONFIG_HOME}/ffmpeg"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export WGETRC="${XDG_CONFIG_HOME}/wgetrc"
export XAUTHORITY="${XDG_CONFIG_HOME}/Xauthority"
export GOPATH="${XDG_DATA_HOME}/go"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export MACHINE_STORAGE_PATH="${XDG_DATA_HOME}/docker-machine"
export GRADLE_USER_HOME="${XDG_DATA_HOME}/gradle"
export MYSQL_HISTFILE="${XDG_DATA_HOME}/mysql_history"
export NODE_REPL_HISTORY="${XDG_DATA_HOME}/node_repl_history"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export NVM_DIR="${XDG_DATA_HOME}/nvm"
export _Z_DATA="${XDG_DATA_HOME}/z"
export PKG_CACHE_PATH="${XDG_CACHE_HOME}/pkg-cache/"
git config --global core.editor "code -n -w"
touch $HOME/.config/wgetrc

function arch() {
    sudo sed -ie s/\#Color/Color/ /etc/pacman.conf
    sudo sed -ie s/\#ParallelDownloads\ \=\ 5/ParallelDownloads\ \=\ 40/ /etc/pacman.conf
    sudo localectl set-locale LANG=en_US.UTF-8
    sudo locale-gen
    echo_info "Installing yay"
    sudo pacman -S --needed git base-devel which wget
    git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
    echo_info "Installing required packages for arch"
    yay -Sy zsh bat ugrep fzf eza fd neovim stow starship tealdeer antigen-git atuin zoxide find-the-command docker docker-compose openssh reflector dum bunjs-bin btop parallel-disk-usage-bin yt-dlp ncdu fd
    sudo pacman -Fy
    sudo systemctl enable docker
    sudo systemctl enable reflector

}

function debian() {
    echo_info "Installing required packages for debian"
    sudo apt install -y zsh bat tldr git stow curl command-not-found fd-find ripgrep fzf exa neovim zoxide docker
    ln -s $(which fdfind) ~/.local/bin/fd
    curl -sS https://starship.rs/install.sh | sh
    bash <(curl https://raw.githubusercontent.com/ellie/atuin/main/install.sh)
    echo_info "Installing antigen for debian"
    mkdir -pv $ADOTDIR && curl -fsSL git.io/antigen > ${ADOTDIR}antigen.zsh
}

which pacman &> /dev/null && arch
which apt &> /dev/null && debian

chsh -s /usr/bin/zsh

echo_info "Installing dotfiles"
cd $HOME && git clone --recursive https://github.com/ozakione/dotfiles .dotfiles && mkdir -vp $XDG_CACHE_HOME && cd $HOME/.dotfiles && stow neovim p10k profile zsh fd neovim htop starship
mkdir $HOME/.config/zsh && touch $HOME/.config/zsh/history && touch $HOME/.config/wgetrc

echo_success "Finished installing everything"
