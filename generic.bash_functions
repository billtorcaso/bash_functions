#!/usr/bin/env bash
#
# The Web Team's own bash settings, for generic LINUX systems

# This script is (supposed to be) idempotent.
# Refer to system-specific bash_functions files for more.

#----------------------------------------------------------

function fned()      { vi "$GENERIC_BASH_FUNCTIONS" $LOCAL_BASH_FUNCTIONS "$@" && fns; }
function fns()       { source  "${LOCAL_BASH_FUNCTIONS:-$GENERIC_BASH_FUNCTIONS}"; }

#----------------------------------------------------------

# Useful repository operations

function repos_set() {
    [[ -z "$1" ]] && { echo 1>&2 "'repos_set' needs an argument.  Try again."; return 1; }
    export REPOS_HERE="$1";
}
function repos()     { [[ -n "$REPOS_HERE" ]] && cd $REPOS_HERE/$1 || echo "Must 'repos_set someplace' first"; }
function repos_show(){ echo "REPOS_HERE == '$REPOS_HERE'"; }

function repostat() {
    (
        repos && \
        for i in *
        do
            echo "----- '$i'"
            [[ -d "$i" ]] && ( cd $i && gsb; )
        done
    )
}

function repofetch() {
    (
        repos && \
        for i in * 
        do
            echo "----- '$i'"
            [[ -d "$i" ]] && ( cd $i && git fetch -v; )
        done
    )
}


#----------------------------------------------------------

function color_envs_set() {
#
# This function defines everything having to do with green/blue/whatever development environments.
#
# We start with 'nocolor', which is just an image of github repos.
# 'green' and 'blue' are for alternating development work.
#

    [[ -z "$1" ]] && [[ -z "$COLORS_ROOT" ]] && \
        { echo 1>&2 "Need either \$1 or \$COLORS_ROOT to be set.  Try again."; return 1; }

    [[ -n "$1" ]] && \
        {
            mkdir -pv "$1" && \
            cd "$1" && \
            export COLORS_ROOT="$(pwd)" && \
            cd - >/dev/null || \
            {
                echo 1>&2 "color_envs_setup: failure using '$1'"; return 1;
            }
        }

    function colors() { cd $COLORS_ROOT/$1; }

    export NOCOLOR_ROOT="$COLORS_ROOT/nocolor-here"
    export GREEN_ROOT="$COLORS_ROOT/green-here"
    export BLUE_ROOT="$COLORS_ROOT/blue-here"

    [[ -d "$NOCOLOR_ROOT" ]] || mkdir -pv "$NOCOLOR_ROOT";
    [[ -d "$GREEN_ROOT" ]]   || mkdir -pv "$GREEN_ROOT";
    [[ -d "$BLUE_ROOT" ]]    || mkdir -pv "$BLUE_ROOT";

    function nocolorset() { repos_set "$NOCOLOR_ROOT" && repos; }
    function greenset()   { repos_set "$GREEN_ROOT" && repos; }
    function blueset()    { repos_set "$BLUE_ROOT" && repos; }
    
    # this is old-think
    #####
    ##### If REPOS_HERE is not set (i.e. login),
    ##### set the 'nocolor' environment.
    #####
    ####nocolorset;
}

#----------------------------------------------------------

# Repository Navigation shortcuts

# TBD

#----------------------------------------------------------

# Django stuff

function pyman()    {
    [[ -e ./manage.py ]] || { echo 1>&2 "No such file: './manage.py'; try again."; return 1; }
    ( set -x; python -R ./manage.py "$@" ; )
}

function pywall()    {
    [[ -e ./manage.py ]] || { echo 1>&2 "No such file: './manage.py'; try again."; return 1; }
    ( set -x; python -Wall -R ./manage.py "$@" ; )
}

function shp()      { pyman shell_plus "$@"; }

function runserve() {
    (   local SETTINGS="${1:-<need a settings module name in \$1>}"
        local VM_SERVER_IP_ADDR="0.0.0.0"
        local RUNSERVE_PORT="${2:-8000}"
        clear;
        pyman runserver --settings="${1}" \
                        "${VM_SERVER_IP_ADDR}:${RUNSERVE_PORT}" )
}

# This is laziness ...
function mm()   { pyman makemigrations && pyman migrate; }

#----------------------------------------------------------

# Creation/navigation in ~/tmp and ~/logs

[[ "$USER" != "root" ]] && { 
    mkdir -pv $HOME/tmp;    # Ensure it exists
    function tmp()   { cd $HOME/tmp/$1; } 
    mkdir -pv $HOME/logs;    # Ensure it exists
    function logs()   { cd $HOME/logs/$1; } 
}

#----------------------------------------------------------

# NGINX: Navigation

# Shortcut for moving to the directory for Nginx configuration files.
function encd() { cd /etc/nginx/conf.d; }

#----------------------------------------------------------

# Vi editor stuff

export EDITOR="vim"
function vimrc_new() {
[[ -r $HOME/.vimrc ]] || \
cat <<EOF > $HOME/.vimrc;
:set ai
:set nows
:set number
:set ruler
:set expandtab
:set tabstop=4
:set shiftwidth=4
EOF
}

#----------------------------------------------------------

# GIT stuff

# 'gsb' is not functional on older versions of GIT
function gsb()      { git status -s -b "$@"; }

function gin()      { gsb; }    # This is an experiment
function ginfo()    { git remote -v && git branch -l "$@" && git status ; }
function gina()     { ginfo -a "$@"; }
function gd()       { git diff "$@"; }
function gdc()      { gd --cached "$@"; }
function gco()      { git checkout "$@"; }
function glog()     { git log --name-only --since=${GIT_LOG_EPOCH:-2016-12-19} "$@"; }

function gbron()    { gin | awk '$1 == "*" { print $2; }'; }
function gadd ()    { ( pyclean; set -x; git add ${@:-$(gmod)} ) }
function gmod()     {
    gin | awk '$1 == "#" && $2 == "modified:" { print $3; }
               $1 == "modified:"              { print $2; }';
}

# Convenience functions for 'git push origin <some-branch>',
# and 'git push origin master' and 'git push dokku master'
function gpo()      { ( set -x; git push origin ${@:-$(gbron)} ) }
function gpom()     { ( set -x; gpo master) }

# We only ever want to push 'master' to dokku.
function gpdm()     { ( set -x; git push dokku master) }

# Push to both origin and dokku, to ensure they are in sync.
function gpod()     { gpom "$@" && gpdm "$@"; }

function git_whoami() {
    [[ $# == 2 ]] || fail "Usage: git_whoami 'Your Name' your@email.com";
    git config --global user.name "$1"
    git config --global user.email "$2"
}

#----------------------------------------------------------

# Mysql Convenience stuff  

function murp()     { clear; ( set -x; mysql -u root -p "$@"; ) }

#----------------------------------------------------------

# General services

function cls()      { clear; }
function cpv()      { cp -v "$@"; }
function fndef()    { declare -f $@; }
function fndeF()    { declare -F $@; }
function envg()     { env | grep -i "${@:-.}" | sort; }
function h20()      { history | tail -n ${@:-20}; }
function heg()      { history | grep $@; }
function lstr()     { ls -tr1 "$@"; }
function md5r()     { md5sum "$@" | sort; }
function md5tree()  { find ${@:-.} -type f | sed 's/.*/"&"/' | xargs md5sum | sort; }
function mkdirs()   { mkdir -pv $(dirname ${1:-.}); }
function netstats() { sudo netstat -lnutp "$@"; }
function py()       { python -R "$@"; }
function pyclean () {
    # remove all pyc files that are cached
    find . -type f -name "*.py[co]" -delete && find . -type d -name "__pycache__" -delete
}
function scriptlog(){ script ${1:-$HOME/tmp/scriptlog-$(date +%F-%R).txt}; }
function scrls()    { screen -ls "$@"; }
function scrr()     { screen -r "$@"; }
function sudoo()    { ( set -x; /usr/bin/sudo -H -E "$@"; ) }
function sctl()     { sudoo supervisorctl "$@"; }
function tf()       { tail -f "$@"; }
function wcl()      { wc -l "$@"; }

#----------------------------------------------------------

# Services that use 'find' and 'grep' together

# find regular files, directories, or everything, AND exclude '.git/*' and similar junk

# find regular files
function ff() { local WHERE="${1:-.}"; shift; find "$WHERE" -type f "$@" | grep_excludes | sort; }

# find directories
function fd() { local WHERE="${1:-.}"; shift; find "$WHERE" -type d "$@" | grep_excludes | sort; }

# find all, regardless of type
function fall()     { find "${@}" | sort; }

# find python files
function ffpy()     { ff "$@" | grep "[.]py$" ; }

# grep within a list of regular files or directories
function ffeg()     { ff | grep "$@"; }
function fdeg()     { fd | grep "$@"; }

# exclude bothersome files from the list on stdin
function grep_excludes() { grep -v -e /.sass-cache/ -e ^Binary -e '/venv*' -e /[.]git/ ; }

# grep within regular files, without excluding anything
function egff()   { egffx "$@"; }

# grep within regular files, without excluding anything
function egffnx()   { find . -type f -print0 | xargs -0 grep "$@" ; }  # No exclusions

# grep within regular files, and exclude some files
function egffx()     { egffnx "$@" | grep_excludes; }

# grep within python files, and exclude some files
function egffpy()   { find . -name '*.py' -print0 | xargs -0 grep "$@" | grep_excludes; }

# Slow! grep for the given command-line arguments within regular files, but use 'find ... -exec grep ...' to do it.  
function findeg()   { time find . -type f -exec grep "$@" "{}" /dev/null ';' ; }

#----------------------------------------------------------

# Bash script programming convenience functions:
#   print a message on stderr
#   fail gracefully and exit

function msg()      { echo 1>&2 "$@"; log "$@"; }
function log()       { echo "[$(date +%F_%R:%S)]: $@" >>"./log-$(basename -- $0 .sh).txt"; }
function fail()     { msg "$1"; return "${2:-1}"; }

function msg_start() { msg "command '$0 $@' started"; }
function msg_end()   { msg "command '$0 $@' ended."; }

#----------------------------------------------------------

# PATH stuff

# Put both $HOME/bin and "." on my PATH, at the end, if they are not already in PATH.

fgrep --quiet $HOME/bin <<<"$PATH" || export PATH="$PATH:$HOME/bin"
fgrep --quiet ":." <<<"$PATH" || export PATH="$PATH:."

#----------------------------------------------------------
#
# We use colored prompts to indicate the type of machine this is.
# magenta   ==  production server
# green     ==  development server
# red       ==  AWS server
# cyan      ==  Vagrant server
# black     ==  set the default color (black)

function magenta_prompt()   { PS1="${1}"'\[[35m\][ $? ][\u][\h]\n[\w]\n$ \[[30m\]'; }
function green_prompt()     { PS1="${1}"'\[[32m\][ $? ][\u][\h]\n[\w]\n$ \[[30m\]'; }
function red_prompt()       { PS1="${1}"'\[[31m\][ $? ][\u][\h]\n[\w]\n$ \[[30m\]'; }
function cyan_prompt()      { PS1="${1}"'\[[36m\][ $? ][\u][\h]\n[\w]\n$ \[[30m\]'; }
function black_prompt()     { PS1="${1}"'[ $? ][\u][\h]\n[\w]\n$ '; }

function magenta_prompt_set(){ function setPS1() { magenta_prompt "$@"; } ; setPS1; }
function green_prompt_set()  { function setPS1() { green_prompt "$@"; } ; setPS1; }
function red_prompt_set()    { function setPS1() { red_prompt "$@"; } ; setPS1; }
function cyan_prompt_set()   { function setPS1() { cyan_prompt "$@"; } ; setPS1; }
function black_prompt_set()  { function setPS1() { black_prompt "$@"; } ; setPS1; }

function venv_prompt () 
{ 
    [[ -n "$VIRTUAL_ENV" ]] && setPS1 "($(basename ${VIRTUAL_ENV}))" || setPS1
}
