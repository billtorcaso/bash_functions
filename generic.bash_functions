#!/usr/bin/env bash
#
# Bill Torcaso's generic bash settings
#
# This script is (supposed to be) idempotent
# And it is (supposed to be) fully generic,
# with no OS-specific or System-specific defintions.

#----------------------------------------------------------
# I use colored prompts to indicate the type of machine this is.
#   green     ==  development server
#   magenta   ==  production server, and/or host of a Docker container
#   red       ==  production code running within a Docker container
#   blue      ==  ???
#   cyan      ==  ???
#   yellow    ==  Too hard on my eyes
#   black     ==  restore the default color (black)

###function bt_prompt()     { PS1='\[\e[35m\]'"[${1:+$1}]"'[ $? ][\u][\h]\n[\w]\n\[\e[30m\]'; }
function magenta_prompt()   { PS1="${1}"'\[\e[35m\][ $? ][\u][\h]\n[\w]\n\[\e[30m\]'; }
function green_prompt()     { PS1='\[\e[32m\]'"${1:+[$1]}"'[ $? ][\u][\h]\n[\w]\n\[\e[30m\]'; }
function red_prompt()       { PS1="${1}"'\[\e[31m\][ $? ][\u][\h]\n[\w]\n\[\e[30m\]'; }
function cyan_prompt()      { PS1="${1}"'\[\e[36m\][ $? ][\u][\h]\n[\w]\n\[\e[30m\]'; }
function black_prompt()     { PS1="${1}"'[ $? ][\u][\h]\n[\w]\n '; }

#   This is my favorite for local use: The foreground of the prompt is white text on a teal background
function setPS1()  {
    PS1='\[\e[7;36m\]----------\[\e[27;30m\]\n[ $? ][\u][\h]\n[\w]\n'
}
#   This is for use with a virtual environment.  It makes the delineator cover the 
#   whole top line
function colorPS1(){ PS1="\[\e[7;36m\]$PS1"; }

#----------------------------------------------------------
# General Bash services, defined as bash functions

function cls()      { clear; }
function deact()    { deactivate; } # just laziness
function dfh()      { df -h "${@:-.}"; }
function dush()     { du -sh "${@:-.}"; }
function envg()     { env | grep "${@:-.}" | sort; }
function fndef()    { declare -f $@; }
function fndeF()    { declare -F $@; }
function fndeFg()   { declare -F | grep $@; }
function h20()      { history | tail -n ${@:-20}; }
function heg()      { history | grep $@; }
function logs()     { tmp logs/$1; }
function ls1()      { ls -1 "$@"; }
function lstr()     { ls -tr1 "$@"; }
function nsl()      { nslookup "$@"; }
function scriptlog(){ script ${1:-$HOME/tmp/scriptlogs/scriptlog-$(date +%F-%R).txt}; }
function scrls()    { screen -ls "$@"; }
function scrr()     { screen -r "$@"; }
function sql3()     { sqlite3 "$@"; }
function sudoo()    { ( set -x; /usr/bin/sudo -H -E "$@"; ) }
function pyclean () {
    # remove all pyc files that are compiled or cached
    find . -type f -name "*.py[co]" -delete
    find . -type d -name "__pycache__" -delete
}
function tf()       { tail -f "$@"; }
function wcl()      { wc -l "$@"; }

#----------------------------------------------------------

# Services that use 'find' and 'find | grep'

#   These functions traverse the directory tree, 
#   to find regular files, or directories, or everything, 
#   AND they exclude '.git/*' and similar junk

#   exclude bothersome files from the list of files coming in on stdin
function _grep_excludes() { grep -v -e /.sass-cache/ -e ^Binary -e '/venv_' -e /[.]git/ ; }

function _drop_first_two_chars()    { sed 's/^..//' $@; }

#   find regular files
function ff() { local WHERE="${1:-.}"; shift; find "$WHERE" -type f "$@" | _grep_excludes | sort; }
function ffs3path() { ff "$@" | _drop_first_two_chars; }

#   find directories
function fd() { local WHERE="${1:-.}"; shift; find "$WHERE" -type d "$@" | _grep_excludes | sort; }

#   find all, regardless of type
function fall()     { find "${@:-.}" | sort; }

#   grep for certain targets, within a list of regular files or directories
function ffeg()     { ff | grep "$@"; }
function fdeg()     { fd | grep "$@"; }


#   find python files
function ffpy()     { ff "$@" | grep "[.]py$" ; }
#   These three are lazyness - apply 'vi' to selected files
function viff()     { vi $(ff); }
function viffeg()   { vi $(ffeg "$@"); }
function vipy()     { vi $(ffpy); }

#----------------------------------------------------------

# Services that use 'grep | find' 

#   'grep' within regular files, without excluding any files by name
#   Usually it is more useful to exclude the git repo files and some others.
function egffnx()   { find . -type f -print0 | xargs -0 grep "$@" ; }  # No exclusions

#   grep within regular files, and exclude some files by name
function egff()     { egffnx "$@" | _grep_excludes; }

#   grep within python files, and exclude some files
function egffpy()   { find . -name '*.py' -print0 | xargs -0 grep "$@" | _grep_excludes; }

#   Slow! grep for the given command-line arguments within regular files, but use 'find ... -exec grep ...' to do it.  
function findeg()   { time find . -type f -exec grep "$@" "{}" /dev/null ';' ; }

#----------------------------------------------------------

# Git stuff

# 'gin', 'gco', 'glog', and 'gpo' get 90% of the use.

function gadd ()    { ( pyclean; git add ${@:-$(gmod)} ) }
function gbron()    { ginfo | awk '$1 == "*" { print $2; }'; }

# 'gsb' is not functional on older versions of GIT
function gsb()      { git status -s -b "$@"; }

function ginfo()    { git remote -v && git branch -l "$@" && git status ; }
function gin()      { gsb "$@"; }  # On some systems, make 'gin' the same as 'ginfo'.
function ginc()     { cls; gin "$@"; }
function gina()     { ginfo -a "$@"; }
function gd()       { git diff "$@"; }
function gdc()      { gd --cached "$@"; }
function gco()      { git checkout "$@"; }
function glog()     { git log --name-only "$@" | head -n 20; }
function gmod()     { git status -s -b | awk '$1 == "M" || $1 == "MM" || $1 == "??" { print $2; }'; }

function gpo()      { ( local target="${@:-$(gbron)}"; set -x; git push origin "$target" ) }

gbr_obliterate () {
    # How to completely annihilate a branch, locally and in the repo.
    [[ -n "$1" ]] || { echo "Need something in \$1. Try again."; return 1; }
    echo "... If you really mean it, do this:"
    echo "git push origin --delete '$1' && git branch -d '$1'"
}

#----------------------------------------------------------

# For a Wagtail-based Django project (only)

function visett()   { vi */settings/[a-z]*.py; }
function vimod()    { vi ${1:-*}/models.py; }

#----------------------------------------------------------

# Django stuff

function pyman()    { ( set -x; python ./manage.py "$@"; ) }
function pymanc()   { clear; pyman "$@"; }
function run8000()  { cls; runserve ${1-dev} 8000; }
function run9000()  { cls; runserve ${1-dev} 9000; }
function runserve() { 
    pyman runserver \
          --settings="$(basename $(pwd)).settings.${1:-dev}" \
          "0.0.0.0:${2:-8000}" ; 
}
function runserver(){ pyman runserver "$@"; }
function mmm()      { pymanc makemigrations && pyman migrate; }
function mmmr()     { mmm && runserve "$@"; }
function shp()      { pyman shell_plus --ipython "$@"; }

#--------------------------------------

# AWS ssh and scp utility functions

function awsssh()    { 
    # $1 == the target machine
    # $2 == the name of a key-pair file in ${_BT_KEYPAIR_FILES_HERE:-$HOME/.ssh}
    # $3 == the login user on $1.  Default is "ubuntu".
    # SSH_VERBOSE == env. variable intended to carry "-v", or nothing

    (   tmp;    # always execute from a known and harmless directory

        # Check the args.
        [[ -n "$1" ]] && THIS_HOST="$1" || \
            { echo "Need a host name in \$1"; exit 1; }

        [[ -n "$2" ]] && THIS_KEYPAIR="$2" || \
            { echo "Need a private key file name in \$2"; exit 1; }

        [[ -n "$3" ]] && THIS_USER="$3" || \
            THIS_USER="ubuntu"  # default username

        # Do it.
        set -x;
        ssh ${SSH_VERBOSE} \
            -i ${_BT_KEYPAIR_FILES_HERE:-$HOME/.ssh}/${THIS_KEYPAIR} \
            ${THIS_USER}@${THIS_HOST};
    )
}

function awsscp()    { 
    # This will work for any key-pair based remote system.
    # At the moment, that includes AWS and any other cloud vendor is unknown.
    #
    # $1 == "push" or "pull".  Anything else is an error.
    #
    # $2 == the source file
    #       if push:  the local source
    #       else:     the remote source
    #       There is no default
    #
    # $3 == the destination file
    #       if push:  the remote destination.  Default is "."
    #       else:     the local  destination.  Default is "."
    #       Using the default destination can overwrite something
    #       valuable in the current directory.  Caveat user.
    #
    # $4 == a hostname
    # $5 == a key-pair file name
    # $6 == a username if other than the default 'ubuntu'
    #
    # SCP_VERBOSE == env. variable intended to carry "-v", or nothing
    #    use like this:  SCP_VERBOSE=-v awsscp pull foobar.txt

    case "$1" in
        push)
            (   set -x;
                scp ${SCP_VERBOSE} \
                    -i ~/.ssh/"$5" \
                    "$2" \
                    "${6:-ubuntu}@$4:${3:-.}";
            );;
        pull)
            (   set -x;
                scp ${SCP_VERBOSE} \
                    -i ~/.ssh/"$5" \
                    "${6:-ubuntu}@$4:$2" "${3:-.}"
            );;
        *)
            echo 1>&2 "ERROR: expected 'push' or 'pull', not '$1'";
            return 1;
    esac
}

#----------------------------------------------------------

#   Generic SCP shortcut functions WITHOUT a key-pair file

#   The pull operations are "person, servername, thing, destination"
#   The push operations are "thing, person, servername, destination"

function scppull()  { (set -x;  scp -o PubkeyAuthentication=no  "${1}@${2}:${3}" "${4:-.}"; ) }
function scppush()  { (set -x;  scp -o PubkeyAuthentication=no  "${1}" "${2}@${3}:${4:-.}"; ) }

#----------------------------------------------------------

# Navigation within my $HOME directory tree

[[ -d "$HOME/bin"       ]] && function bin() { cd $HOME/bin/$1 && pwd; }
[[ -d "$HOME/tmp"       ]] && function tmp() { cd $HOME/tmp/$1 && pwd; }
[[ -d "$HOME/Desktop"   ]] && function _desk(){ cd $HOME/Desktop/$1 && pwd; }
[[ -d "$HOME/Downloads" ]] && function _down(){ cd $HOME/Downloads/$1 && pwd; }
[[ -d "$HOME/.ssh"      ]] && function _ssh(){ cd $HOME/.ssh/$1 && pwd; }

#----------------------------------------------------------

# Vagrant commands

function vg()       { vagrant $@; }
function vggst()    {  vg global-status "$@" | grep '^[0-9a-fA-F]' | sort -r -k 4,4 -k 5,5r | awk '{ print $1, $4, $5}'; }
function vssh()     { ( set -x;  vg ssh "$@"; ) }
function upshell()  {  vg up && vssh "$@"; }

#----------------------------------------------------------

# PATH settings:  Put both $HOME/bin and "." on my PATH, at the end, if not already there.

function path_has() { fgrep --quiet ":${1}" <<<"$PATH" || fgrep --quiet "${1}:" <<<"$PATH"; }
function path_set() { 
    while [[ -n "$1" ]];
    do
        path_has "$1" || export PATH="$PATH:$1"
        shift
    done
}

path_set $HOME/bin
path_set .

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

# Bash script programming logger functions.

function msg()      { echo 1>&2 "$@"; }
function fail()     { msg "FAIL: " "$@"; exit 1; }

#----------------------------------------------------------

# The end.

true
