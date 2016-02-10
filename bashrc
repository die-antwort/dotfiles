# system specific settings can be set in .bashrc_local
[ -e ~/.bashrc_local ] && source ~/.bashrc_local

function add_to_path_if_exist () {
  # loop over arguments in reverse order to make sure $PATH contains the arguments in the 
  # same order as given to the function
  for ((i=$#; i>0; i--)); do 
    local dir=${!i}
    if [[ -e $dir && ! (":$PATH:" == *":$dir:"*) ]]; then
      export PATH="$dir:$PATH"
    fi
  done
}

add_to_path_if_exist /usr/local/share/npm/bin /usr/local/heroku/bin
unset add_to_path_if_exist

# Make sure these are always at the beginning of PATH (on Mac OS X, /usr/local/bin may 
# already be part of $PATH, but shadowed by /usr/bin).
PATH="$HOME/dotfiles/bin:/usr/local/sbin:/usr/local/bin:$PATH"

which rbenv >/dev/null && eval "$(rbenv init -)"

# setup prompt, aliases etc only if run in interactive mode
if [[ -n "$PS1" ]]; then

  # Colors
  NoColor='\033[0m'
  Black='\033[0;30m'
  Red='\033[0;31m'
  Green='\033[0;32m'
  Yellow='\033[0;33m'
  Blue='\033[0;34m'
  Magenta='\033[0;35m'
  Cyan='\033[0;36m'
  LightGray='\033[0;37m'
  DarkGray='\033[1;30m'
  LightRed='\033[1;31m'
  LightGreen='\033[1;32m'
  LightYellow='\033[1;33m'
  LightBlue='\033[1;34m'
  LightMagenta='\033[1;35m'
  LightCyan='\033[1;36m'
  White='\033[1;37m'

  function p () {
    if [[ -d "$HOME/Projekte/P$*" ]]; then
      cd "$HOME/Projekte/P$*"
    else
      cd "$HOME/Projekte/$*"
    fi
  }

  function _p () {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local save_ifs=$IFS
    IFS=$'\n'
    local projects=$(ls ~/Projekte | sed -e 's/^[pP]//' -e 's/&/\\&/')
    COMPREPLY=( $( compgen -W '$projects' -- $cur ) )
    IFS=$save_ifs
    return 0
  }

  complete -F _p p

  function da_ssh () {
    local args
    if [ -z "$DA_USERNAME" ]; then
      echo "ERROR: Environment variable DA_USERNAME not set (use ~/.bashrc_local for setting it)."
      return
    fi
    if [[ "$RMATE_REMOTE_PORT" != "" ]]; then
      # set up port forwarding for rmate (TextMate 2)
      args="-R $RMATE_REMOTE_PORT:localhost:52698 -o SendEnv=RMATE_REMOTE_PORT"
    fi
    ssh $args $DA_USERNAME@$*
  }

  set +o histexpand
  source ~/dotfiles/bash/git-completion.sh
  source ~/dotfiles/bash/prompt.sh

  # enable colored output from ls on Mac OS (CLICOLOR) and Linux (alias)
  if [[ $(uname) == "Darwin" ]]; then
    export CLICOLOR=1
  else
    alias ls="ls --color=auto"
  fi
  
  # Fix "perl: warning: Setting locale failed." errors when ssh'ing into some servers.
  # (Seems that Mac OS sets LC_CTYPE to "UTF-8" when the system language is english, 
  # and Ubuntu doesn't recognize this as a valid locale.)
  if [[ $LC_CTYPE == "UTF-8" ]]; then
    export LC_CTYPE="en_US.UTF-8"
  fi
    
  # enable ansi colors in less
  export LESS=-R 

  export HISTCONTROL="ignoredups"

  export EDITOR=vim
  which mate >/dev/null && export EDITOR="mate -w"

  # make it possible to use aliases with sudo (see https://wiki.archlinux.org/index.php/Sudo#Passing_aliases)
  alias sudo="sudo "

  alias ..="cd .."
  alias ...="cd ../.."
  alias ....="cd ../../.."
  alias ll="ls -al"
  alias be="bundle exec"
  alias brails="bin/rails"
  alias brake="bin/rake"
  alias brspec="bin/rspec"
  alias ttr="touch tmp/restart.txt"
  which apachectl >/dev/null && alias agr="apachectl graceful"
  which apache2ctl >/dev/null && alias agr="apache2ctl graceful"
  alias r="ruby"
  alias da3="da_ssh da3.die-antwort.eu"
  alias da4="da_ssh da4.die-antwort.eu"
  alias da5="da_ssh da5.die-antwort.eu"
  alias buero="da_ssh buero.die-antwort.eu"
  alias dabuero="da_ssh buero.die-antwort.eu"
  alias reload="source ~/.bashrc"
  alias cdtmbundles="cd ~/Library/Application\ Support/Avian/Bundles"

  if [[ -n "$RMATE_REMOTE_PORT" && -n "$SSH_CONNECTION" ]]; then
    export RMATE_PORT=$RMATE_REMOTE_PORT
  fi

fi
  
