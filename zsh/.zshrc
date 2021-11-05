# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export EDITOR="code"
export LESSHISTFILE="-"
export ZSH="$HOME/.config/omzsh"
export ADOTDIR="${HOME}/.config/antigen/"
export NVM_DIR="${HOME}/.config/nvm"
export NPM_CONFIG_USERCONFIG="${HOME}/.config/npm/config"
export PKG_CACHE_PATH="${HOME}/.cache/pkg-cache/"
export GITUSERNAME="ozakione"
export GITUSEREMAIL="29860391+OzakIOne@users.noreply.github.com"
alias wget="wget --hsts-file=\"$HOME/.cache/wget-hsts\""
alias v="nvim"
alias zrc="nvim ~/.zshrc"
alias eee="explorer.exe ."
alias myip="ip a | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"
source $HOME/.config/antigen/antigen.zsh

function https2ssh() {
  if git config --get remote.origin.url | grep -P '\.git$' >/dev/null; then 
    newURL=`git config --get remote.origin.url | sed -r 's#(http.*://)([^/]+)/(.+)$#git@\2:\3#g'`
  else
    newURL=`git config --get remote.origin.url | sed -r 's#(http.*://)([^/]+)/(.+)$#git@\2:\3.git#g'`
  fi;
  echo "Does this new url look fine? (y/n) : " $newURL
  read response
  if [[ "$response" == "y" ]]; then 
    git remote set-url origin $newURL; 
    echo "Git remote updated."; 
  else 
    echo "Git remote unchanged."; 
  fi;
}

antigen use oh-my-zsh
antigen bundle git
#antigen bundle deno
antigen bundle denodev/oh-my-zsh-deno
#antigen bundle gh
antigen bundle command-not-found
antigen bundle history
antigen bundle z
antigen bundle sudo
antigen bundle debian
antigen bundle heroku
#antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen theme romkatv/powerlevel10k
antigen apply

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $HOME/.config/p10k.zsh ]] || source $HOME/.config/p10k.zsh
