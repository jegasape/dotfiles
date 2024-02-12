#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias l='ls -al'
alias cat='bat'
alias open='xdg-open'
alias vim='.local/bin/lvim'
PS1='[\u@\h \W]\$ '
. "$HOME/.cargo/env"
