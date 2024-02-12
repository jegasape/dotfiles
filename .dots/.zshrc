if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

export SHELL=zsh

autoload -Uz promptinit

promptinit

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
	zsh-autosuggestions 
	git 
	history-substring-search
)

source $ZSH/oh-my-zsh.sh

alias cat='bat'
alias open='xdg-open'
alias vim='~/.local/bin/lvim'

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source /home/jegasape/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
