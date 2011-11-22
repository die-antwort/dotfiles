function _set_project_and_dir_in_project () {
  local dir=$(pwd)
  if [[ $dir == ~/Projekte/* ]]; then
    Project=$( echo ${dir#$HOME/Projekte/} | cut -f 1 -d "/" )
    DirInProject=${dir#$HOME/Projekte/$Project}
    [[ -z "$DirInProject" ]] && DirInProject="/"
    DirInProject=" $DirInProject"
  else
    Project=""
    DirInProject=${dir/#$HOME/\~}
  fi
}

PROMPT_COMMAND=_set_project_and_dir_in_project

if [[ -z "$SSH_CONNECTION" ]]; then
  PS1="\[${LightCyan}\]\$Project\[${LightYellow}\]\$DirInProject"
else
  PS1="\[$LightRed\]\\u\[$LightYellow\]@\[$LightCyan\]\\h \[$LightYellow\]\\w"
fi

PS1="${PS1}\[$LightMagenta\] $ \[$NoColor\]"
