export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

export EDITOR="code"
export BROWSER="brave"
export TERMINAL="kitty"
export TERM="xterm-256color"
export LESSHISTFILE="-"
export GITNAME="ozakione"
export GITEMAIL="29860391+OzakIOne@users.noreply.github.com"
export PATH=$PATH:$HOME/.local/bin
## config
export HISTFILE="${XDG_CONFIG_HOME}/zsh/history"
export ZSH="${XDG_CONFIG_HOME}/omzsh"
export ADOTDIR="${XDG_CONFIG_HOME}/antigen/"
# export KDEHOME="${XDG_CONFIG_HOME}/kdehome"
export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc"
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export FFMPEG_DATADIR="${XDG_CONFIG_HOME}/ffmpeg"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export WGETRC="${XDG_CONFIG_HOME}/wgetrc"
# export XINITRC="${XDG_CONFIG_HOME}/X11/xinitrc"
# export XSERVERRC="${XDG_CONFIG_HOME}/X11/xserverrc"
export XAUTHORITY="${XDG_CONFIG_HOME}/Xauthority"
## data
export GOPATH="${XDG_DATA_HOME}/go"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export MACHINE_STORAGE_PATH="${XDG_DATA_HOME}/docker-machine"
export GRADLE_USER_HOME="${XDG_DATA_HOME}/gradle"
export MYSQL_HISTFILE="${XDG_DATA_HOME}/mysql_history"
export NODE_REPL_HISTORY="${XDG_DATA_HOME}/node_repl_history"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export NVM_DIR="${XDG_DATA_HOME}/nvm"
export _Z_DATA="${XDG_DATA_HOME}/z"
## cache
export PKG_CACHE_PATH="${XDG_CACHE_HOME}/pkg-cache/"
## OPTS
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
export FZF_DEFAULT_COMMAND='fd --hidden ""'

function setozakigit() {
  git config user.name "$GITNAME"
  git config user.email "$GITEMAIL"
}

function https2ssh() {
  if git config --get remote.origin.url | /usr/bin/grep -P '\.git$' >/dev/null; then
    newURL=$(git config --get remote.origin.url | sed -r 's#(http.*://)([^/]+)/(.+)$#git@\2:\3#g')
  else
    newURL=$(git config --get remote.origin.url | sed -r 's#(http.*://)([^/]+)/(.+)$#git@\2:\3.git#g')
  fi;
  echo "Does this new url look fine? (y/m/n) : $newURL"
  read response
  if [[ "$response" == "y" ]]; then
    git remote set-url origin "$newURL";
    echo "Git remote updated.";
  elif [[ "$response" == "m" ]]; then
    read modifiedURL
    git remote set-url origin "$modifiedURL";
  else
    echo "Git remote unchanged.";
  fi;
}

function mountwindows() {
  partitionPath=$(sudo fdisk -l | /usr/bin/grep "Microsoft basic data" | awk '{print $1}')
  partitionName=$(basename $partitionPath)
  partitionType=$(lsblk -l -o name,fstype | /usr/bin/grep $partitionName | awk '{print $2}')
  if [[ "$partitionType" == "ntfs" ]]; then
    sudo mkdir /mnt/windows && sudo mount -t ntfs $partitionPath /mnt/windows
  fi
}

function v() {
  if [[ -z $1 ]]; then
    fzf | xargs -r nvim
  else
    nvim $1
  fi
}

function chs() {
  curl cheat.sh/$1
}

source /usr/share/zsh/share/antigen.zsh
which pacman &> /dev/null && source /usr/share/doc/find-the-command/ftc.zsh noprompt

antigen use oh-my-zsh
antigen bundle git
antigen bundle command-not-found
#antigen bundle history
antigen bundle z
antigen bundle sudo
antigen bundle debian
antigen bundle colored-man-pages
# antigen bundle ddnexus/fm
# antigen bundle heroku
antigen bundle lukechilds/zsh-nvm
# antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply

eval "$(starship init zsh)"
eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"

## Alias depending on linux version
/usr/bin/grep -qPi "(Microsoft|WSL)" /proc/version &> /dev/null && alias eee="explorer.exe ."

alias wget="/usr/bin/wget --hsts-file=\"$XDG_CACHE_HOME/wget-hsts\""
alias zrc="nvim ${HOME}/.zshrc"
alias myip="ip a | /usr/bin/grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | /usr/bin/grep -Eo '([0-9]*\.){3}[0-9]*' | /usr/bin/grep -v '127.0.0.1'"
alias yarn="yarn --use-yarnrc \"${XDG_CONFIG_HOME}/yarn/config\""
alias ls="exa"
alias l="exa -lah"
alias ll="exa -lh"
alias tree="exa --tree"
alias cat="bat"
alias grep="rg"
alias ixio="curl -F 'f:1=<-' ix.io"
