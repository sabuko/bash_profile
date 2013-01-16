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

# network-reporting
alias ntwk='cd ~/network-reporting;source venv/bin/activate'
alias shell='ntwk;python ~/network-reporting/manage.py shell_plus --settings=network_reporting.settings'
alias tests='ntwk;python manage.py test --settings=network_reporting.settings'
alias runserver='ntwk;sudo python manage.py runserver --settings=network_reporting.settings'

alias sql='ntwk;psql -d network_reporting'

alias push_requirements='ntwk;pip freeze > ~/network-reporting/requirements.txt'
alias pull_requirements='ntwk;pip install -r ~/network-reporting/requirements.txt'

function setup_ntwk_db {
    psql -d postgres -c 'CREATE DATABASE network_reporting'
    psql -d postgres -c 'GRANT ALL ON DATABASE network_reporting TO cornstalk'
    python manage.py syncdb
    python manage.py migrate
}

function reset_ntwk_db {
    ntwk
    psql -d postgres -c 'DROP DATABASE network_reporting'
    psql -d postgres -c 'CREATE DATABASE network_reporting'
    python ~/network-reporting/manage.py syncdb --noinput
    python ~/network-reporting/manage.py migrate
}

# basejump
alias srv='cd ~/mopub-frontend/server;source ~/mopub-frontend/venv/bin/activate'
alias deploy_fe='fab deploy_code --set role=frontend,names="frontend-staging-1;frontend-staging-2",hash=aslkdjfaq2542348'
alias clear_pyc='find . -name "*.pyc" -exec rm -rf {} \;'

function setup_fe_db {
    srv
    psql -d postgres -c 'CREATE DATABASE frontend'
    psql -d postgres -c 'GRANT ALL ON DATABASE frontend TO cornstalk'
    python ~/mopub-frontend/server/manage.py syncdb
    python ~/mopub-frontend/server/manage.py migrate
}

function reset_fe_db {
    srv
    psql -d postgres -c 'DROP DATABASE frontend'
    psql -d postgres -c 'CREATE DATABASE frontend'
    python ~/mopub-frontend/server/manage.py syncdb --noinput
    python ~/mopub-frontend/server/manage.py migrate
}

alias scss="while true; do sleep 2; sass --update ~/mopub-frontend/server/public/css/style.scss; done"

# EC2
alias ec2_old='ssh -i ~/.ec2/jpmopub-keypair ubuntu@ec2-184-72-183-185.compute-1.amazonaws.com'
alias ec2_ntwk='ssh -i ~/.ssh/pena.pem ubuntu@ec2-184-72-185-19.compute-1.amazonaws.com'
alias ec2_basejump='ssh -i ~/.ssh/pena.pem ubuntu@basejump.mopub.com'

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
alias sts='cd ~/mopub-stats-service/ && source venv/bin/activate'
alias pub='cd ~/mopub-frontend/server/public'
alias js='cd ~/mopub-frontend/server/public/js'
alias css='cd ~/mopub-frontend/server/public/css'

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
     PURPLE='\[\033[35m\]'
       CYAN='\[\033[36m\]'
        NIL='\[\033[00m\]'

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

# Hostname styles
FULL='\H'
SHORT='\h'

# System => color/hostname map:
# UC: username color
# LC: location/cwd color
# HD: hostname display (\h vs \H)
# Defaults:
UC=$GREEN
LC=$BLUE
HD=$FULL

# Prompt function because PROMPT_COMMAND is awesome
function set_prompt() {
    # show the host only and be done with it.
    host="${UC}${HD}${NIL}"

    # Special vim-tab-like shortpath (~/folder/directory/foo => ~/f/d/foo)
    _pwd=`pwd | sed "s#$HOME#~#"`
    if [[ $_pwd == "~" ]]; then
       _dirname=$_pwd
    else
       _dirname=`dirname "$_pwd" `
        if [[ $_dirname == "/" ]]; then
              _dirname=""
        fi
       _dirname="$_dirname/`basename "$_pwd"`"
    fi
    path="${LC}${_dirname}${NIL}"
    myuser="${UC}\u@${NIL}"

    # Dollar/pound sign
    end="${LC}\$${NIL} "

    # Virtual Env
    if [[ $VIRTUAL_ENV != "" ]]
       then
           venv=" ${RED}(${VIRTUAL_ENV##*/})"
    else
       venv=''
    fi

    export PS1="${myuser}${path}${venv}$(parse_git_branch) ${end}"
}

export PROMPT_COMMAND=set_prompt

# ===============
# = Python Path =
# ===============

GAE_PATH='/Applications/GoogleAppEngineLauncher.app/Contents/Resources/GoogleAppEngine-default.bundle/Contents/Resources/google_appengine/'
alias gae_path='export PYTHONPATH=$PYTHONPATH:$GAE_PATH:$GAE_PATH/lib/antlr3:$GAE_PATH/lib/django_1_2:$GAE_PATH/lib/fancy_urllib:$GAE_PATH/lib/ipaddr:$GAE_PATH/lib/webob:$GAE_PATH/lib/yaml/lib:$GAE_PATH/lib/webob_1_1_1/'

# ========
# = PATH =
# ========

# Use locally installed applications over OSX ones. ex: usr/local/bin/psql instead of usr/bin/psql
export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/Cellar/ruby/1.9.3-p194/bin:$PATH


# ========
# = CHEF =
# ========

export OPSCODE_USER=tiago
export ORGNAME=mopub
export AWS_ACCESS_KEY_ID=AKIAJKOJXDCZA3VYXP3Q
export AWS_SECRET_ACCESS_KEY=yjMKFo61W0mMYhMgphqa+Lc2WX74+g9fP+FVeyoH
export AWS_SSH_KEY_ID=chef

##
# Your previous /Users/tiagobandeira/.bash_profile file was backed up as /Users/tiagobandeira/.bash_profile.macports-saved_2012-11-15_at_16:08:20
##

# MacPorts Installer addition on 2012-11-15_at_16:08:20: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

