# do nothing if not running interactively
[ -z "$PS1" ] && return

which -s rbenv && eval "$(rbenv init -)"

# enable colored output from ls
export CLICOLOR=1

export HISTCONTROL="ignoredups"

alias ..="cd .."
alias ...="cd ..."
alias ll="ls -al"
alias be="bundle exec"
alias r="ruby"

# system specific settings can be set in .bashrc_local
[ -e ~/.bashrc_local ] && source ~/.bashrc_local
