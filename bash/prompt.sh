function _set_project_and_dir_in_project () {
  local use_multiline_prompt=$1
  local dir=$(pwd)
  local basename=$(basename "$dir")
  if [[ $dir == ~/Projekte/* ]]; then
    Project=$( echo ${dir#$HOME/Projekte/} | cut -f 1 -d "/" )
    if [[ $Project == "DA" && $basename != "DA" ]]; then
      Project=$Project/$( echo ${dir#$HOME/Projekte/DA/} | cut -f 1 -d "/" )
    fi
    DirInProject=${dir#$HOME/Projekte/$Project}
    Project="$Project "
    if [[ -z "$DirInProject" ]]; then
      DirInProject="/"
    else
      DirInProject=$basename
    fi
  else
    Project=""
    if [[ -z "$1" ]]; then
      DirInProject=${dir/#$HOME/\~}
    else
      DirInProject=$basename
    fi
  fi
}

function _rbenv_version_for_prompt () {
  if [[ "$RBENV_VERSION" ]]; then
    echo " (Ruby!$RBENV_VERSION)"
  else
    local local_version
    local_version=$(rbenv local 2>/dev/null)
    if [[ $? == 0 ]]; then
      echo " (Ruby $local_version)"
    fi
  fi
}

PROMPT_COMMAND="_set_project_and_dir_in_project $USE_MULTILINE_PROMPT; $PROMPT_COMMAND"

# We use the prompt to also set the terminal window's title. Mac OS Terminal
# shows pwd in titlebar, but this is meaningless for ssh connections. So, if 
# we are on a ssh connection, we show user@host instead. But we also make 
# sure to reset this, if we are local again.

if [[ -z "$SSH_CONNECTION" ]]; then
  WINDOW_TITLE=$(printf '\e]0;\a')
  PROMPT="\[$LightCyan\]\$Project\[$LightYellow\]\$DirInProject"
else
  WINDOW_TITLE=$(printf '\e]7;\a\e]0;%s\a' "SSH: \\u@\\h")
  if [[ "$USE_MULTILINE_PROMPT" ]]; then
    PROMPT="\[$LightRed\]\\h\[$LightYellow\]:\\W"
  else
    PROMPT="\[$LightRed\]\\u\[$LightYellow\]@\[$LightCyan\]\\h \[$LightYellow\]\\w"
  fi
fi

if declare -F rbenv &>/dev/null; then
  RBENV_PROMPT="\$(_rbenv_version_for_prompt)"
fi

if [[ "$USE_MULTILINE_PROMPT" ]]; then
  export GIT_PS1_SHOWDIRTYSTATE=1
  export GIT_PS1_SHOWSTASHSTATE=1
  export GIT_PS1_SHOWUNTRACKEDFILES=1
  export GIT_PS1_SHOWUPSTREAM="auto git"
  PS1="\[$WINDOW_TITLE\]\[$DarkGray\]– \u \[$LightGray\]\w\[$DarkGray\]\$(__git_ps1 \" (%s)\")$RBENV_PROMPT\n$PROMPT\[$LightMagenta\] \$ \[$NoColor\]"
else
  PS1="\[$WINDOW_TITLE\]$PROMPT\[$LightMagenta\] $ \[$NoColor\]"
fi
unset PROMPT WINDOW_TITLE USE_MULTILINE_PROMPT
