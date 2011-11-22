function project_directory () {
  local dir=$(pwd)
  if [[ $dir == ~/Projekte/* ]]; then
    local project=$( echo ${dir#$HOME/Projekte/} | cut -f 1 -d "/" )
    dir=${dir#$HOME/Projekte/$project}
    [[ -z "$dir" ]] && dir="/"
    echo "$(color light-cyan)${project}$(color yellow) ${dir}$(color none)"
  else
    dir=${dir/#$HOME/\~}
    echo "$(color yellow)${dir}$(color none)"
  fi
}

function prompt () {
  if [[ -z "$SSH_CONNECTION" ]]; then
    echo "\$(project_directory)"
  else
    echo "$(color light-red)\\u$(color yellow)@$(color light-cyan)\\h$(color none) $(color yellow)\\w$(color none)"
  fi
}

export PS1="$(prompt)$(color magenta) $ $(color none)"
