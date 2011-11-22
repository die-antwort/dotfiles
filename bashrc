# do nothing if not running interactively
[ -z "$PS1" ] && return

function color () {
  case "$1" in
    "light-red")  echo -e "\033[1;31m";;
    "yellow")     echo -e "\033[1;33m";;
    "magenta")    echo -e "\033[1;35m";;
    "light-cyan") echo -e "\033[1;36m";;
    "none")       echo -e "\033[0m";;
  esac
}

function p () {
  cd "$HOME/Projekte/P$*"
}

function _p () {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local save_ifs=$IFS
  IFS=$'\n'
  local projects=$(ls ~/Projekte | sed -e 's/^[pP]//')
  COMPREPLY=( $( compgen -W '$projects' -- $cur ) )
  IFS=$save_ifs
  return 0
}

complete -F _p p

function da_ssh () {
  if [ -z "$DA_USERNAME" ]; then
    echo "ERROR: Environment variable DA_USERNAME not set (use ~/.bashrc_local for setting it)."
    return
  fi
  cmd="ssh $DA_USERNAME@$*"
  echo $cmd
  $cmd
}

source ~/dotfiles/bash/prompt.sh

which rbenv >/dev/null && eval "$(rbenv init -)"

# enable colored output from ls
export CLICOLOR=1

# enable ansi colors in less
export LESS=-R 

export HISTCONTROL="ignoredups"

export EDITOR=vim
which mate >/dev/null && export EDITOR=mate

alias ..="cd .."
alias ...="cd ..."
alias ll="ls -al"
alias be="bundle exec"
alias r="ruby"
alias da3="da_ssh da3.die-antwort.eu"
alias da4="da_ssh da4.die-antwort.eu"
alias dabuero="da_ssh buero.die-antwort.eu"
alias reload="source ~/.bashrc"

# system specific settings can be set in .bashrc_local
[ -e ~/.bashrc_local ] && source ~/.bashrc_local
