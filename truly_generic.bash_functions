#!/usr/bin/env bash
#
# Bill Torcaso's generic bash settings
#
# This script is (supposed to be) idempotent
# And it is (supposed to be) fully generic 
# across POSIX systems, with no OS-specific 
# or Platform-specific defintions.

###--------------------------------------------
 
#   Decide what platform we are on right now ...
 
 case "$(uname -a)" in 
     *Ubuntu*) export _BT_PLATFORM_NAME="ubuntu";; 
     *Linux*)  export _BT_PLATFORM_NAME="awslinux";;
     *amzn2*)  export _BT_PLATFORM_NAME="awslinux";;
     *arm64*)  export _BT_PLATFORM_NAME="m1-darwin";;
     *Darwin*) export _BT_PLATFORM_NAME="darwin";;
     *)
         echo 1>&2 "PANIC: cannot decide what platform this is! Get help."
         return 1
     ;;
 esac

###-------------------------------------------- 

#   Define these generic things related 
#   to intrinsic BASH function services

    function fndef()    { declare -f "$@"; }
    function fned()     { cls; echo NOT DEFINED YET; }
    function fns()      { cls; echo NOT DEFINED YET; }

#----------------------------------------------------------
# General Bash services, defined as bash functions

function cls()      { clear; }
function deact()    { deactivate; } # just laziness
function dfh()      { df -h "${@:-.}"; }
function dush()     { du -sh "${@:-.}"; }
function envg()     { env | grep "${@:-.}" | sort; }
function h20()      { history | tail -n ${@:-20}; }
function heg()      { history | grep $@; }
function ls1()      { ls -1 "$@"; }
function lstr()     { ls -tr1 "$@"; }
function nsl()      { nslookup "$@"; }
function sudoo()    { ( set -x; /usr/bin/sudo -H -E "$@"; ) }
function tf()       { tail -f "$@"; }
function wcl()      { wc -l "$@"; }

#	These are not POSIX standard and must be guarded by 'which'.

[[ $(which black) ]] && { 
    # The semi-standard Python reformatting tool.
    function blackdot() { black "${@:-.}"; }  
}
[[ $(which sqlite3) ]] && { 
    function sql3()     { sqlite3 "$@"; }
}
[[ $(which screen) ]] && { 
    function scrls()    { screen -ls "$@"; }
    function scrr()     { screen -r "$@"; }
}

#----------------------------------------------------------

# Services that use 'find' and 'find | grep'

#   These functions traverse the directory tree, 
#   to find regular files, or directories, or everything, 
#   AND they exclude '.git/*' and similar junk

#   exclude bothersome files from the list of files coming in on stdin
function _code_excludes() { 
    grep -v -e '[.]pyc$' \
            -e /.sass-cache/ \
            -e ^Binary \
            -e '/venv_' \
            -e '/[.]git/' \
            -e '^[.]/media/' \
            -e '/img/' \
            ;
}

#   find regular files
function ff() { local WHERE="${1:-.}"; shift; find "$WHERE" -type f "$@" | _code_excludes | sort; }

#   grep for certain targets, within a list of regular files or directories
function ffeg()     { ff | grep "$@"; }

#----------------------------------------------------------

# Services that use 'grep | find' 

#   'grep' within regular files, without excluding any files by name
#   Usually it is more useful to exclude the git repo files and some others.
function egffnx()   { find . -type f -print0 | xargs -0 grep "$@" ; }  # No exclusions

#   grep within regular files, and exclude some files by name
function egff()     { egffnx "$@" | _code_excludes; }

#----------------------------------------------------------

# Git stuff

# 'ginc', 'gco', 'glog', and 'gpo' get 90% of the use.

function gadd ()    { ( pyclean; git add ${@:-$(gmod)} ) }

# 'gsb' is not functional on older versions of GIT
function gsb()      { git status -s -b "$@"; }

function gin_big_() { git remote -v && git branch -l "$@" && git status ; }
function gin()      { gsb "$@"; }  # On some systems, make 'gin' the same as 'ginfo'.
function ginc()     { cls; gin "$@"; }
function gina()     { ginfo -a "$@"; }
function gd()       { git diff "$@"; }
function gdc()      { gd --cached "$@"; }
function gco()      { git checkout "$@"; }
function glog()     { git log --name-only "$@" | head -n 20; }
function gmod()     { gsb | awk '$1 == "M" || $1 == "MM" || $1 == "??" { print $2; }'; }

# Be sure you want to 'push origin' before you run this.
function gpo()      { ( local target="${@:-main}"; set -x; git push origin "$target" ) }

gbr_obliterate () {
    # How to completely annihilate a branch, locally and in the repo.
    [[ -n "$1" ]] || { echo "Need something in \$1. Try again."; return 1; }
    echo "... If you really mean to destroy all traces of a branch, do this ..."
    echo "git push origin --delete '$1' && git branch -d '$1'"
}

#----------------------------------------------------------

# Django stuff

function mm()       { pymanc makemigrations "${@:--v 3}"; }
function mmm()      { mm && pyman migrate "${@:--v 3}" ; }
function mmmr()     { mmm && runserve "$@"; }
function pyman()    { ( set -x; python ./manage.py "$@"; ) }
function pymanc()   { clear; pyman "$@"; }
function run8000()  { cls; runserve ${1-dev} 8000; }
function run9000()  { cls; runserve ${1-dev} 9000; }
function runserver(){ pyman runserver "$@"; }
function runserve() { 
    pyman runserver \
          --settings="$(basename $(pwd)).settings.${1:-dev}" \
          "0.0.0.0:${2:-8000}" ; 
}
function runs()     { runserver "$@"; }
function shp()      { pyman shell_plus --ipython "$@"; }

#--------------------------------------

# Navigation within my $HOME directory tree

[[ -d "$HOME/Bin"       ]] && function Bin() { cd $HOME/Bin/$1 && pwd; }
[[ -d "$HOME/Code"      ]] && function Code() { cd $HOME/Code/$1 && pwd; } && \
                              function code() { Code "$@"; }
[[ -d "$HOME/Tmp"       ]] && function Tmp() { cd $HOME/Tmp/$1 && pwd; } && \
                              function tmp() { Tmp "$@"; }
[[ -d "$HOME/.ssh"      ]] && function _ssh(){ cd $HOME/.ssh/$1 && pwd; }

# -- These are my play projects ...


#----------------------------------------------------------

# Vi editor: my preferred settings

export EDITOR="vim"
function vimrc_new() {
[[ -r $HOME/.vimrc ]] || \
cat <<EOF > $HOME/.vimrc;
:set ai
:set nows
:set number
:set mouse-=a
:set ruler
:set expandtab
:set tabstop=4
:set shiftwidth=4
EOF
}

#----------------------------------------------------------

# I use colored prompts to indicate the type of machine this is.
#   green     ==  development server
#   magenta   ==  production server, and/or host of a Docker container
#   red       ==  production code running within a Docker container
#   blue      ==  ???
#   cyan      ==  AWSLINUX  aka billtorcaso.org
#   yellow    ==  Too hard on my eyes
#   black     ==  restore the default color (black)

###function bt_prompt()     { PS1='\[\e[35m\]'"[${1:+$1}]"'[ $? ][\u][\h]\n[\w]\n\[\e[30m\]'; }
function magenta_prompt()   { PS1="${1}"'\[\e[35m\][ $? ][\u][\h]\n[\w]\n\[\e[30m\]'; }
function green_prompt()     { PS1="${1}"'\[\e[32m\][ $? ][\u][\h]\n[\w]\n\[\e[30m\]'; }
function red_prompt()       { PS1="${1}"'\[\e[31m\][ $? ][\u][\h]\n[\w]\n\[\e[30m\]'; }
function cyan_prompt()      { PS1="${1}"'\[\e[36m\][ $? ][\u][\h]\n[\w]\n\[\e[30m\]'; }
function black_prompt()     { PS1="${1}"'[ $? ][\u][\h]\n[\w]\n '; }

#   This is my favorite for local use: The delineator is white text on a teal background
function PS1set()  {
    PS1='\[\e[7;36m\]----------\[\e[27;30m\]\n[ $? ][\u][\h]\n[\w]\n'
}

###--------------------------------------------

#   This is fundamental to all other "_BT_GIT_*" env variables.

[[ -d "$HOME/Code/github-here" ]] && \
{
    export _BT_GIT_REPOS_HERE="$HOME/Code/github-here"
    function repos()    { cd $_BT_GIT_REPOS_HERE/$1; }
} || \
{
    echo 1>&2 "PANIC: cannot find Bill Torcaso repository root.  Get help."
    return 1;
}

###-------------------------------------------- 

#   Things related to my bash_functions repo

[[ -d "$_BT_GIT_REPOS_HERE/bash_functions" ]] && \
{
    export _BT_BASH_REPO="$_BT_GIT_REPOS_HERE/bash_functions"
    function fnsrepo()  { cd $_BT_BASH_REPO/$1; }
} || \
{
    echo 1>&2 "PANIC: cannot find bash functions repo directory!  Get help."
    return 1;
}

#----------------------------------------------------------

# 'md5r' is too useful to leave out.
# So we do a little work to define it ...

which_md5="$(which md5)"
which_md5sum="$(which md5sum)"

if [[ "$which_md5" != "" ]];
then
    eval "function md5r() { $which_md5 -r "$@"; } ;"
elif [[ "$which_md5sum" != "" ]];
then
    eval "function md5r() { $which_md5sum \"\$@\"; } ;"
else
    # Failure ...
    echo 1>&2 "Function 'md5r' is not defined";
fi

#----------------------------------------------------------

# PATH settings:  Put both $HOME/bin and "." on my PATH, at the end, if not already there.
# Adding "." to PATH is deprecated for ROOT, but I am a harmless little rabbit
# and never do anything wrung.

function path_has() { fgrep --quiet ":${1}" <<<"$PATH" || fgrep --quiet "${1}:" <<<"$PATH"; }
function path_set() { 
    while [[ -n "$1" ]];
    do
        path_has "$1" || export PATH="$PATH:$1"
        shift
    done
}

[[ -d "$HOME/bin" ]] && path_set $HOME/bin
path_set .


#----------------------------------------------------------

# My favorite PS1 prompt
# This is my favorite for local use: The foreground of the prompt is white text on a teal background

###--------------------------------------------

#   Set the Bash prompt based on which platform this is.
#   Must wait until after the  colored_prompt functions are defined.

case "$_BT_PLATFORM_NAME" in 
    ubuntu)     cyan_prompt;;
    awslinux)   magenta_prompt;;
    *darwin)    PS1set; update_terminal_cwd() { true; };;
esac

