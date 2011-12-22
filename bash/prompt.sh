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

PROMPT_COMMAND="_set_project_and_dir_in_project; $PROMPT_COMMAND"

# We use the prompt to also set the terminal window's title. Mac OS Terminal
# shows pwd in titlebar, but this is meaningless for ssh connections. So, if 
# we are on a ssh connection, we show user@host instead. But we also make 
# sure to reset this, if we are local again.

if [[ -z "$SSH_CONNECTION" ]]; then
  WINDOW_TITLE=$(printf '\e]0;\a')
  PS1="\[${LightCyan}\]\$Project\[${LightYellow}\]\$DirInProject"
else
  WINDOW_TITLE=$(printf '\e]7;\a\e]0;%s\a' "SSH: \\u@\\h")
  PS1="\[$LightRed\]\\u\[$LightYellow\]@\[$LightCyan\]\\h \[$LightYellow\]\\w"
fi

PS1="\[$WINDOW_TITLE\]$PS1\[$LightMagenta\] $ \[$NoColor\]"
unset WINDOW_TITLE
