shopt -s histappend

golink() {
  open "http://go/${1}"
}

function _workspace_root_dir() {
  echo "${HOME}/workspace"
}

function _project_dir() {
  local dir="$(_workspace_root_dir)/$1"
  local cur="${dir}/current"

  if [ -d "$cur" ]; then
    echo "$cur"
  elif [ -d "$dir" ]; then
    echo "$dir"
  else
    echo ""
  fi
}

function _workspace_root_dir_complete() {
  local root_dir=$(_workspace_root_dir)
  local word=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=($(compgen -W "$(ls $root_dir)" -- "${word}"))
}

function cdw() {
  local project_name=$1
  shift

  if [ -z "$project_name" ]; then
    cd $(_workspace_root_dir)
    return $?
  fi

  local dir=$(_project_dir "$project_name")

  if [ -n "$dir" ]; then
    cd $dir
  else
    echo "can not find project $project_name"
    return 1
  fi
}

complete -F _workspace_root_dir_complete cdw


alias go=golink
alias ll='ls -la'
alias gs='git status'
# alias cdw="cd ${HOME}/workspace"
alias cds='cdw && cd source/'
alias board='go dhis'
alias cdf='cdw && cd gnip-fanout'
alias be='bundle exec'

## modified from http://stackoverflow.com/questions/16715103/bash-prompt-with-last-exit-code
export PROMPT_COMMAND=__prompt_command

function __prompt_command() {
  ## This needs to be first
  local EXIT="$?"

  ## workaround to let multiple open bash shells share the same history
  history -a; history -c; history -r

  local RCol='\[\e[0m\]'
  local Red='\[\e[0;31m\]'
  local Gre='\[\e[0;32m\]'
  local BGre='\[\e[1;32m\]'
  local BYel='\[\e[1;33m\]'
  local BBlu='\[\e[1;34m\]'
  local LBlu='\[\e[0;36m\]'
  local Pur='\[\e[0;35m\]'

  local XCol=${RCol}
  if [ $EXIT != 0 ]; then
    XCol=${Red}
  local PS1_EXIT=" ${XCol}${EXIT}${RCol}"
  fi

  local PS1_BEGIN="${XCol}[${RCol}"
  local PS1_END="${XCol}]\$ ${RCol}"

  if [ -e "/opt/twitter/opt/git/etc/bash_completion.d/git-completion.bash" ]; then
    if [ -e "/opt/twitter/opt/git/etc/bash_completion.d/git-prompt.sh" ]; then
      local PS1_GIT=${BGre}' $(__git_ps1 "(%s) ")'${RCol}
    fi
  fi

  if [ -e "${HOME}/.git-completion.bash" ]; then
    source "${HOME}/.git-completion.bash"
  fi

  local PS1_HOST="${XCol}\h${RCol}"
  local PS1_WORKDIR="${LBlu}\W${RCol}"

  PS1="${PS1_BEGIN}${PS1_HOST}${PS1_GIT}${PS1_WORKDIR}${PS1_EXIT}${PS1_END}"
}

merge_and_post(){
  local current_branch=`git rev-parse --abbrev-ref HEAD`
  git checkout master && git pull && git checkout "${current_branch}" && git merge master && git review post
}

alias mp=merge_and_post

# export MACOSX_DEPLOYMENT_TARGET=10.5