# GAE
alias runserver='python ~/mopub/server/manage.py runserver'
alias clear_local='rm ~/mopub_local_datastore.django'

alias staging='python ~/mopub/server/scripts/mpdeploy.py frontend-staging'
alias slam='python ~/mopub/server/scripts/mpdeploy.py slam'
alias boom='python ~/mopub/server/scripts/mpdeploy.py boom'
alias deploy='python ~/mopub/server/scripts/mpdeploy.py production'

# GIT
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gm='git commit -m'
alias gd='git diff'
alias go='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'

# Edit configs
alias profile='vim ~/bash_profile/.bash_profile'
alias vimrc='vim ~/vimrc/.vimrc'

# navigation
alias srv='cd ~/mopub/server'
alias js='cd ~/mopub/server/public/js'
alias css='cd ~/mopub/server/public/css'

# Color Constants

        RED="\[\033[0;31m\]"
     YELLOW="\[\033[0;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[0;34m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"

if [ -x /usr/libexec/path_helper ]; then
    eval `/usr/libexec/path_helper -s`
fi

if [ "${BASH-no}" != "no" ]; then
    [ -r /etc/bashrc ] && . /etc/bashrc
fi

# Functions to build prompt with git branch info
function parse_git_branch {

  git rev-parse --git-dir &> /dev/null
  git_status="$(git status 2> /dev/null)"
  branch_pattern="^# On branch ([^${IFS}]*)"
  remote_pattern="# Your branch is (.*) of"
  diverge_pattern="# Your branch and (.*) have diverged"
  if [[ ! ${git_status} =~ "working directory clean" ]]; then
    state="${RED}⚡"
  fi
  # add an else if or two here if you want to get more specific
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
      remote="${YELLOW}↑"
    else
      remote="${YELLOW}↓"
    fi
  fi
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="${YELLOW}↕"
  fi
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${BASH_REMATCH[1]}
    echo " (${branch})${remote}${state}"
  fi
}

function prompt_func() {
    previous_return_value=$?;
    # prompt="${TITLEBAR}$BLUE[$RED\w$GREEN$(__git_ps1)$YELLOW$(git_dirty_flag)$BLUE]$COLOR_NONE "
    prompt="\w${GREEN}$(parse_git_branch)${COLOR_NONE}"
    PS1="${prompt} $ "
}

PROMPT_COMMAND=prompt_func
