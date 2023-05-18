export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export GDK_BACKEND="wayland,x11"
export WAYLAND_DISPLAY="wayland-0"
export QT_QPA_PLATFORM="wayland;xcb"
export ANDROID_HOME="$HOME/Android/Sdk"

export EDITOR="code -n -w"
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
export PNPM_HOME="${XDG_DATA_HOME}/pnpm"
export PATH="$PNPM_HOME:$PATH"
# export KDEHOME="${XDG_CONFIG_HOME}/kdehome"
export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc"
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export FFMPEG_DATADIR="${XDG_CONFIG_HOME}/ffmpeg"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export WGETRC="${XDG_CONFIG_HOME}/wgetrc"
export ZSH_CUSTOM="${XDG_CONFIG_HOME}/zshcodex"
# export XINITRC="${XDG_CONFIG_HOME}/X11/xinitrc"
# export XSERVERRC="${XDG_CONFIG_HOME}/X11/xserverrc"
export XAUTHORITY="${XDG_CONFIG_HOME}/Xauthority"
export BUN_INSTALL="${XDG_DATA_HOME}/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
## data
export GOPATH="${XDG_DATA_HOME}/go"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export PATH="$CARGO_HOME/bin:$PATH"
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

function updatepnpm() {
  corepack prepare pnpm@`pnpm info pnpm --json | jq -r '.version'`
}

function https2ssh() {
  # check if current directory is a git repo
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "Not a git repository."
    return 1
  fi;

  # check if remote origin exists
  if ! git remote | /usr/bin/grep -P '^origin$' >/dev/null; then
    echo "No remote origin found."
    return 1
  fi;

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
    echo "Enter new url: "
    read modifiedURL
    git remote set-url origin "$modifiedURL";
    echo "Git remote updated.";
  else
    echo "Git remote unchanged.";
  fi;
}

function mountwindows() {
  partitionPath=$(sudo fdisk -l | /usr/bin/grep "Microsoft basic data" | awk '{print $1}')
  partitionName=$(basename "$partitionPath")
  partitionType=$(lsblk -l -o name,fstype | /usr/bin/grep "$partitionName" | awk '{print $2}')
  if [[ "$partitionType" == "ntfs" ]]; then
    sudo mkdir /mnt/windows && sudo mount -t ntfs "$partitionPath" /mnt/windows
  fi
}

function v() {
  if [[ -z $1 ]]; then
    fzf | xargs -r nvim
  else
    nvim "$1"
  fi
}

function chs() {
  curl cheat.sh/$1
}

tre() { command tre "$@" -e && source "/tmp/tre_aliases_$USER" 2>/dev/null; }

source /usr/share/zsh/share/antigen.zsh
which pacman &> /dev/null && source /usr/share/doc/find-the-command/ftc.zsh noprompt noupdate

antigen use oh-my-zsh
antigen bundle git
antigen bundle command-not-found
#antigen bundle history
antigen bundle z
antigen bundle sudo
antigen bundle colored-man-pages
antigen bundle ddnexus/fm
antigen bundle lukechilds/zsh-nvm
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
#antigen bundle thefuck
antigen apply

eval "$(github-copilot-cli alias -- "$0")"
eval "$(starship init zsh)"
_ZO_ECHO=1
_ZO_RESOLVE_SYMLINKS=1
eval "$(zoxide init zsh)"
#eval "$(thefuck --alias)"
export ATUIN_NOBIND=1
eval "$(atuin init zsh)"
bindkey '^r' _atuin_search_widget

source "$ZSH_CUSTOM/plugins/zsh_codex/zsh_codex.plugin.zsh"
bindkey '^X' create_completion

## Alias depending on linux version
/usr/bin/grep -qPi "(Microsoft|WSL)" /proc/version &> /dev/null && function eee() { if [ -d "$1" ]; then explorer.exe "$1"; else explorer.exe .; fi;}

alias wget="/usr/bin/wget --hsts-file=\"$XDG_CACHE_HOME/wget-hsts\""
alias zrc="nvim ${HOME}/.zshrc"
alias myip="ip a | /usr/bin/grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | /usr/bin/grep -Eo '([0-9]*\.){3}[0-9]*' | /usr/bin/grep -v '127.0.0.1'"
alias yarn="yarn --use-yarnrc \"${XDG_CONFIG_HOME}/yarn/config\""
alias ls="exa"
alias l="exa -lah --icons --group-directories-first"
alias ll="exa -lh --icons --group-directories-first"
alias tree="exa --tree"
# alias cat="bat"
# alias grep="rg"
alias ixio="curl -F 'f:1=<-' ix.io"
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
alias code='code --enable-features=UseOzonePlatform --ozone-platform=wayland'

# ZSH CONFIG
setopt autocd               # change directory just by typing its name
setopt correct              # auto correct mistakes
setopt interactivecomments  # allow comments in interactive mode
setopt magicequalsubst      # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch            # hide error message if there is no match for the pattern
setopt notify               # report the status of background jobs immediately
setopt numericglobsort      # sort filenames numerically when it makes sense
setopt promptsubst          # enable command substitution in prompt
autoload -U edit-command-line           ###################
zle -N edit-command-line                # Enables Vi mode #
bindkey -M vicmd v edit-command-line    ###################
WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

bindkey '^[[1;5C' forward-word          # ctrl + ->             # moves pointer forward a word
bindkey '^[[1;5D' backward-word         # ctrl + <-             # moves pointer backward a word
bindkey '^[[1;3D' beginning-of-line     # alt  + ->             # moves pointer to start of the line
bindkey '^[[1;3C' end-of-line           # alt  + <-             # moves pointer to end of the line
bindkey '^[[1;5B' backward-kill-word    # ctrl + arrow down	 # deletes a word backwards
#bindkey '^[[3~'   kill-whole-line       # delete                # deletes whole line
bindkey '^[[1;5A' undo                  # ctrl + arrow up       # undo
bindkey '^x'	    edit-command-line	    # ctrl + x              # edit line in Vi
bindkey '^x^e'	  edit-command-line	    # ctrl + x + e          # same but more common keybind
bindkey "^[q"     push-line             # alt  + q              # stashing command while execute other command 

setopt hist_ignore_dups            # ignore duplicated commands history list
setopt hist_ignore_space           # ignore commands that start with space
setopt hist_expire_dups_first      # delete duplicates first when HISTFILE size exceeds HISTSIZE
# setopt hist_verify                 # show command with history expansion to user before running it
# setopt share_history               # share command history data


ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[global-alias]=fg=magenta
ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[path]=underline
ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[command-substitution]=none
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta
ZSH_HIGHLIGHT_STYLES[process-substitution]=none
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=magenta
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=magenta
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta
ZSH_HIGHLIGHT_STYLES[assign]=none
ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
ZSH_HIGHLIGHT_STYLES[named-fd]=none
ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
ZSH_HIGHLIGHT_STYLES[arg0]=fg=green
ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

alias k='kubectl'
alias klog='kubectl get events --sort-by=.metadata.creationTimestam'
alias kap='kubectl apply -f'
alias kdes='kubectl describe'
alias klogs='kubectl logs'
alias kgp='kubectl get pod'
alias kdel='kubectl delete'
alias kcns='kubectl config set-context --current'
alias kdk='kubectl delete -k .'
alias kak='kubectl apply -k .'
alias mk='minikube'
export VAULT_ADDR='http://127.0.0.1:8200'

bindkey '²' forward-char

eval "$(github-copilot-cli alias -- "$0")"
