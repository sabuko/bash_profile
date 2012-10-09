# =======
# = EC2 =
# =======

# Setup Amazon EC2 Command-Line Tools
export EC2_HOME=~/.ec2
export PATH=$PATH:$EC2_HOME/bin
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home/

# =====================
# = Aliases/Shortcuts =
# =====================

export DJANGO_SETTINGS_MODULE=settings

# network-reporting
alias ntwk='cd ~/network-reporting;source venv/bin/activate'
alias shell='ntwk;python ~/network-reporting/manage.py shell_plus --settings=network_reporting.settings'
alias tests='ntwk;python manage.py test --settings=network_reporting.settings'
alias runserver='ntwk;sudo python manage.py runserver --settings=network_reporting.settings'

alias sql='psql -d network_reporting'

function reset_django_db {
    ntwk
    psql -d postgres -c 'DROP DATABASE network_reporting'
    psql -d postgres -c 'CREATE DATABASE network_reporting'
    python ~/network-reporting/manage.py syncdb --noinput --settings=network_reporting.settings
    python ~/network-reporting/manage.py migrate --settings=network_reporting.settings
}

# GAE
alias gae='python manage.py console mopub-inc'

alias runserver_gae='python ~/mopub/server/manage.py runserver'
alias clear_local='rm ~/mopub_local_datastore.django'

alias staging='python ~/mopub/server/scripts/mpdeploy.py frontend-staging'
alias slam='python ~/mopub/server/scripts/mpdeploy.py frontend-slam'
alias boom='python ~/mopub/server/scripts/mpdeploy.py frontend-boom'
alias beta='python ~/mopub/server/scripts/mpdeploy.py frontend-beta'
alias deploy='python ~/mopub/server/scripts/mpdeploy.py production'

alias roll_back_production="appcfg.py backends . rollback frontend-0; appcfg.py backends . rollback frontend-1"
alias roll_back_staging="appcfg.py backends . rollback frontend-staging"
alias roll_back_boom="appcfg.py backends . rollback frontend-boom"

alias scss="while true; do sleep 2; sass --update ~/mopub/server/public/css/style.scss; done"

# EC2
alias ec2='ssh -i ~/.ec2/jpmopub-keypair ubuntu@ec2-184-72-183-185.compute-1.amazonaws.com'

# GIT
alias ga='git add'
alias gp='git push'
alias gl='git log'
alias gs='git status'
alias gd='git diff'
alias gc='git commit'
alias gm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias go='git checkout'
alias gf='git fetch'
alias gra='git remote add'
alias grr='git remote rm'
alias gpu='git pull'
alias gcl='git clone'
alias gr='git reset'
alias gk='gitk --all&'
alias gx='gitx --all'

# One char shortcuts
alias w='which'
alias p='python'
alias n="nosetests --match='(?:^|[\b_\./-])mptest' --with-yanc"
alias g='git'
alias l='ls -l'

# Edit configs
alias profile='vim ~/bash_profile/.bash_profile'
alias vimrc='vim ~/vimrc/.vimrc'

# Navigating
alias wiki='cd ~/Dropbox/wiki'
alias srv='cd ~/mopub/server'
alias sts='cd ~/mopub-stats-service/ && source venv/bin/activate'
alias pub='cd ~/mopub/server/public'
alias js='cd ~/mopub/server/public/js'
alias css='cd ~/mopub/server/public/css'

# Shortcuts
alias django='django-admin.py'
alias py='ipython --no-confirm-exit'
alias getip="curl -s 'http://checkip.dyndns.org' | sed 's/.*Current IP Address: \([0-9\.]*\).*/\1/g'"
alias cloc='/Users/jcp/Dropbox/bin/perl/cloc.pl'
alias m='python2.5 ./manage.py'
alias dsh='python manage.py shell_plus'
alias computer,='sudo'
alias backup='sudo rsync -vaxAX --delete --ignore-errors'
alias e='emacs'
alias gimme='brew install' # 'sudo apt-get install'
alias cbr="git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'"
alias cpbr="echo `cbr` | pbcopy"

# Greps
alias pgrep='ps aux | grep'
alias hgrep='history | grep'

# List commands
alias ls='ls -hFG'         # add colors for filetype recognition
alias ll='ls -l'           # list vertically
alias la='ls -all'         # show hidden files
alias lk='ls -lSr'         # sort by size, biggest last
alias lc='ls -ltcr'        # sort by and show change time, most recent last
alias lu='ls -ltur'        # sort by and show access time, most recent last
alias lt='ls -ltr'         # sort by date, most recent last
alias lm='ls -al |less'    # pipe through 'more'
alias lr='ls -lR'          # recursive ls

# Typos
alias xs='cd'
alias vf='cd'
alias moer='more'
alias moew='more'
alias kk='ll'

# Navigation
alias ..='cd ..'
alias ...='cd .. ; cd ..'

# ===================
# = Decorate Prompt =
# ===================

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

# ===============
# = Python Path =
# ===============

GAE_PATH='/Applications/GoogleAppEngineLauncher.app/Contents/Resources/GoogleAppEngine-default.bundle/Contents/Resources/google_appengine/'
#export PYTHONPATH=$PYTHONPATH:$GAE_PATH:$GAE_PATH/lib/antlr3:$GAE_PATH/lib/django_1_2:$GAE_PATH/lib/fancy_urllib:$GAE_PATH/lib/ipaddr:$GAE_PATH/lib/webob:$GAE_PATH/lib/yaml/lib:$GAE_PATH/lib/webob_1_1_1/
