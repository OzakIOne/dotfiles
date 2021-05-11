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
alias wget="wget --hsts-file=\"$HOME/.cache/wget-hsts\""
alias v="nvim"
alias zrc="nvim ~/.zshrc"

source $HOME/.config/antigen/antigen.zsh

antigen use oh-my-zsh
antigen bundle git
#antigen bundle deno
antigen bundle denodev/oh-my-zsh-deno
antigen bundle gh
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
