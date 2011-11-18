# do nothing if not running interactively
[ -z "$PS1" ] && return

function da_ssh () {
  if [ -z "$DA_USERNAME" ]; then
    echo "ERROR: Environment variable DA_USERNAME not set (use ~/.bashrc_local for setting it)."
    return
  fi
  cmd="ssh $DA_USERNAME@$*"
  echo $cmd
  $cmd
}

which -s rbenv && eval "$(rbenv init -)"

# enable colored output from ls
export CLICOLOR=1

export HISTCONTROL="ignoredups"

alias ..="cd .."
alias ...="cd ..."
alias ll="ls -al"
alias be="bundle exec"
alias r="ruby"
alias da3="da_ssh da3.die-antwort.eu"
alias da4="da_ssh da4.die-antwort.eu"
alias dabuero="da_ssh buero.die-antwort.eu"

# system specific settings can be set in .bashrc_local
[ -e ~/.bashrc_local ] && source ~/.bashrc_local
