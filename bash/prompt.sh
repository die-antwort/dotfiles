function _project_directory () {
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

if [[ -z "$SSH_CONNECTION" ]]; then
  PS1="\$(_project_directory)"
else
  PS1="$(color light-red)\\u$(color yellow)@$(color light-cyan)\\h$(color none) $(color yellow)\\w$(color none)"
fi

export PS1="${PS1}$(color magenta) $ $(color none)"
