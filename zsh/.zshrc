# trap 'yes | history -c' EXIT
# GIT_AUTHOR_DATE="2023-05-20 14:30:00 +0200" GIT_COMMITTER_DATE="$GIT_AUTHOR_DATE" git commit --amend --reset-author --no-edit
# 30fa7518126b6c081b12afb20ea3eabb@proton.me

# ─────────────────────────────────────────────
#  PATH & ENV
# ─────────────────────────────────────────────
export PATH="$HOME/.bun/bin:/usr/local/go/bin:$HOME/go/bin:$HOME/.local/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
export NVM_DIR="$HOME/.nvm"
export SHELL=zsh
export EDITOR=vim

# ─────────────────────────────────────────────
#  HISTORY
# ─────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS SHARE_HISTORY

# ─────────────────────────────────────────────
#  COMPLETION
# ─────────────────────────────────────────────
autoload -Uz compinit
# Regenera el dump solo si tiene más de 24h
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

# ─────────────────────────────────────────────
#  KEYBINDINGS
# ─────────────────────────────────────────────
bindkey '^[[1;3C' forward-word   # Alt + →
bindkey '^[[1;3D' backward-word  # Alt + ←

# ─────────────────────────────────────────────
#  ALIASES 
# ─────────────────────────────────────────────
alias cat='batcat --paging=never'
alias vim='~/.local/bin/lvim'
alias docker-compose='docker compose'
alias proton='echo "30fa7518126b6c081b12afb20ea3eabb@proton.me" | xclip -sel clip'

open() { xdg-open "$@" > /dev/null 2>&1 & disown }


alias l='ls -larth --color=always \
  | grep -Ev "(\.zsh_history|\.zcompdump|\.lesshst|\.viminfo|\.wget-hsts|\.zprofile|\.bash.*|\.profile|\.python_history|\.starship_init\.zsh|sudo_as_admin_successful|shell\.pre)"'

alias {celar,cler,cear,clea,lcear}='clear'
alias {exi,xit,x}='exit'
alias {vm, vvi, vi}='vim' 

# ─────────────────────────────────────────────
#  GIT — signoff 
# ─────────────────────────────────────────────
git() {
  if [[ "$1" == "commit" ]]; then
    command git commit --signoff "${@:2}"
  else
    command git "$@"
  fi
}

# ─────────────────────────────────────────────
#  RDP — Login 
# ─────────────────────────────────────────────
comet() {
    read -rs "COMET_PASS?Password: "
    echo
    xfreerdp /v:192.168.0.102 /u:jegasape2@outlook.com /p:"$COMET_PASS" /cert:ignore /dynamic-resolution /scale:140 /scale-desktop:140 2>/dev/null & disown
    unset COMET_PASS
}

# ─────────────────────────────────────────────
#  HISTORY -c
# ─────────────────────────────────────────────
history() {
  if [[ "$1" == "-c" ]]; then
    echo -n > "$HISTFILE"
    fc -p "$HISTFILE"
    print "Historial borrado."
  else
    builtin history 1
  fi
}

# ─────────────────────────────────────────────
#  LAZY LOAD — NVM 
# ─────────────────────────────────────────────
_nvm_load() {
  unfunction nvm node npm npx 2>/dev/null
  [[ -s "$NVM_DIR/nvm.sh" ]]          && source "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
}
nvm()  { _nvm_load; nvm  "$@" }
node() { _nvm_load; node "$@" }
npm()  { _nvm_load; npm  "$@" }
npx()  { _nvm_load; npx  "$@" }

# ─────────────────────────────────────────────
#  LAZY LOAD — Bun completions
# ─────────────────────────────────────────────
bun() {
  unfunction bun 2>/dev/null
  [[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
  bun "$@"
}

# ─────────────────────────────────────────────
#  ZSH 
# ─────────────────────────────────────────────
fpath+=${ZDOTDIR:-~}/.zsh_functions

# ─────────────────────────────────────────────
#  PLUGINS
# ─────────────────────────────────────────────
source ~/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# ─────────────────────────────────────────────
#  STARSHIP 
# ─────────────────────────────────────────────
() {
  local cache=~/.starship_init.zsh
  if [[ ! -f $cache || ~/.config/starship.toml -nt $cache ]]; then
    starship init zsh > $cache
  fi
  source $cache
}

# rsync3 - rsync wrapper with remote-to-remote support
source "/home/jegasape/.local/share/rsync3/rsync3.sh"  # rsync3
