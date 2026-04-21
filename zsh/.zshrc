export PATH="$HOME/.bun/bin:/usr/local/go/bin:$HOME/go/bin:$HOME/.local/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
export NVM_DIR="$HOME/.nvm"
export SHELL=zsh
export EDITOR=vim

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS SHARE_HISTORY

autoload -Uz compinit
if [[ -n ${ZDOTDIR:-~}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zcompcache
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word

alias cat='batcat --paging=never'
alias vim='~/.local/bin/lvim'
alias docker-compose='docker compose'

open() { xdg-open "$@" > /dev/null 2>&1 & disown }

alias l='ls -larth --color=always \
  | grep -Ev "\.(zsh|zcomp|zprofile|bash|profile|python_history|sudo_as_admin_successful|shell\.pre)"'

alias {celar,cler,cear,clea,lcear}='clear'
alias {xit,x}='exit'
alias {vm, vvi, vi}='vim'

git() {
  if [[ "$1" == "commit" ]]; then
    command git commit --signoff "${@:2}"
  else
    command git "$@"
  fi
}

history() {
  if [[ "$1" == "-c" ]]; then
    echo -n > "$HISTFILE"
    fc -p "$HISTFILE"
    print "History cleared."
  else
    builtin history 1
  fi
}

_nvm_load() {
  unfunction nvm node npm npx 2>/dev/null
  [[ -s "$NVM_DIR/nvm.sh" ]]          && source "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
}
nvm()  { _nvm_load; nvm  "$@" }
node() { _nvm_load; node "$@" }
npm()  { _nvm_load; npm  "$@" }
npx()  { _nvm_load; npx  "$@" }

bun() {
  unfunction bun 2>/dev/null
  [[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
  bun "$@"
}

fpath+=${ZDOTDIR:-~}/.zsh_functions

source ~/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

() {
  local cache=~/.starship_init.zsh
  if [[ ! -f $cache || ~/.config/starship.toml -nt $cache ]]; then
    starship init zsh > $cache
  fi
  source $cache
}
