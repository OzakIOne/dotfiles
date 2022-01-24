export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

## Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
## Initialization code that may require console input (password prompts, [y/n]
## confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export EDITOR="code"
export BROWSER="brave"
export TERMINAL="kitty"
export LESSHISTFILE="-"
export GITNAME="ozakione"
export GITEMAIL="29860391+OzakIOne@users.noreply.github.com"
export HISTFILE="${XDG_CONFIG_HOME}/zsh/history"
export ZSH="${XDG_CONFIG_HOME}/omzsh"
export ADOTDIR="${XDG_CONFIG_HOME}/antigen/"
export NVM_DIR="${XDG_DATA_HOME}/nvm"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/config"
export PKG_CACHE_PATH="${XDG_CACHE_HOME}/pkg-cache/"
export KDEHOME="${XDG_CONFIG_HOME}/kdehome"
export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc"
export GOPATH="${XDG_DATA_HOME}/go"
export _Z_DATA="${XDG_DATA_HOME}/z"
# export XINITRC="${HOME}/.config/X11/xinitrc"
# export XSERVERRC="${HOME}/.config/X11/xserverrc"
export XAUTHORITY="${XDG_CONFIG_HOME}/Xauthority"

alias wget="wget --hsts-file=\"$XDG_CACHE_HOME/wget-hsts\""
alias v="nvim"
alias zrc="nvim ${XDG_CONFIG_HOME}/zsh/.zshrc"
alias myip="ip a | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"
alias yarn="yarn --use-yarnrc \"${XDG_CONFIG_HOME}/yarn/config\""
source ${ADOTDIR}antigen.zsh
## Alias depending on linux version
grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null && alias eee="explorer.exe ."

function setozakigit() {
  git config user.name "$GITNAME"
  git config user.email "$GITEMAIL"
}

function https2ssh() {
  if git config --get remote.origin.url | grep -P '\.git$' >/dev/null; then
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

antigen use oh-my-zsh
antigen bundle git
which deno > /dev/null && antigen bundle deno && antigen bundle denodev/oh-my-zsh-deno
which gh > /dev/null && antigen bundle gh
antigen bundle command-not-found
antigen bundle history
antigen bundle z
antigen bundle sudo
antigen bundle debian
antigen bundle colored-man-pages
# antigen bundle heroku
# antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen theme romkatv/powerlevel10k
antigen apply

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
## To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $HOME/.config/p10k.zsh ]] || source $HOME/.config/p10k.zsh
