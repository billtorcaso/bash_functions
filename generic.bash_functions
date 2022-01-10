#!/usr/bin/env bash
#
# Bill Torcaso's generic bash settings
#
# This script is (supposed to be) idempotent
# And it is (supposed to be) fully generic,
# with no OS-specific or System-specific defintions.

#----------------------------------------------------------

function desk() { cd $HOME/Desktop/$1; }

#----------------------------------------------------------

# PATH settings:  Put both $HOME/bin and "." on my PATH, at the end, if not already there.
# Add varous other things to PATH

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

# Python-invocation services

function py() { python "$@"; }
function pyc() { cls; py "$@"; }

#----------------------------------------------------------
# I use colored prompts to indicate the type of machine this is.
#   green     ==  development server
#   magenta   ==  production server, and/or host of a Docker container
#   red       ==  production code running within a Docker container
#   blue      ==  ???
#   cyan      ==  ???
#   yellow    ==  Too hard on my eyes
#   black     ==  restore the default color (black)

function magenta_prompt()   { PS1="${1}"'\[\e[35m\][ $? ][\u][\h]\n[\w]\n\[\e[;30m\]'; }
function green_prompt()     { PS1='\[\e[32m\]'"${1:+[$1]}"'[ $? ][\u][\h]\n[\w]\n\[\e[;30m\]'; }
function red_prompt()       { PS1="${1}"'\[\e[31m\][ $? ][\u][\h]\n[\w]\n\[\e[;30m\]'; }
function cyan_prompt()      { PS1="${1}"'\[\e[36m\][ $? ][\u][\h]\n[\w]\n\[\e[;30m\]'; }
function black_prompt()     { PS1="${1}"'[ $? ][\u][\h]\n[\w]\n '; }

# This is my favorite for local use: The foreground of the prompt is white text on a teal background
function setPS1()  {
    PS1='\[\e[7;36m\]----------\[\e[27;30m\]\n[ $? ][\u][\h]\n[\w]\n'
}

#----------------------------------------------------------
# General Bash services, defined as bash functions

function blackdot() { black "${@:-.}"; }  # The semi-standard Python reformatting tool.
function cls()      { clear; }
function deact()    { deactivate; } # just laziness
function dfh()      { df -h "${@:-.}"; }
function dush()     { du -sh "${@:-.}"; }
function sudush()   { sudoo du -sh "${@:-.}"; }
function envg()     { env | grep "${@:-.}" | sort; }
function fndef()    { declare -f $@; }
function fneg ()    { declare -F | grep "$@"; }
function h20()      { history | tail -n ${@:-20}; }
function heg()      { history | grep $@; }
function ls1()      { ls -1 "$@"; }
function lstr()     { ls -tr1 "$@"; }
function nsl()      { nslookup "$@"; }
function scrls()    { screen -ls "$@"; }
function scrr()     { screen -r "$@"; }
function sql3()     { sqlite3 "$@"; }
function sudoo()    { ( set -x; /usr/bin/sudo -H -E "$@"; ) }
function tf()       { tail -f "$@"; }
function wcl()      { wc -l "$@"; }

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

function _drop_first_two_chars()    { sed 's/^..//' $@; }

#   find regular files
function ff() { local WHERE="${1:-.}"; shift; find "$WHERE" -type f "$@" | _code_excludes | sort; }
function ffs3path() { ff "$@" | _drop_first_two_chars; }

#   find directories
function fd() { local WHERE="${1:-.}"; shift; find "$WHERE" -type d "$@" | _code_excludes | sort; }

#   find all, regardless of type
function fall()     { find "${@:-.}" | sort; }

#   grep for certain targets, within a list of regular files or directories
function ffeg()     { ff | grep "$@"; }
function fdeg()     { fd | grep "$@"; }

#----------------------------------------------------------

# Services that use 'grep | find' 

#   'grep' within regular files, without excluding any files by name
#   Usually it is more useful to exclude the git repo files and some others.
function egffnx()   { find . -type f -print0 | xargs -0 grep "$@" ; }  # No exclusions

#   grep within regular files, and exclude some files by name
function egff()     { egffnx "$@" | _code_excludes; }

#   grep within python files, and exclude some files
function egffpy()   { find . -name '*.py' -print0 | xargs -0 grep "$@" | _code_excludes; }

#   Slow! grep for the given command-line arguments within regular files, but use 'find ... -exec grep ...' to do it.  
function findeg()   { time find . -type f -exec grep "$@" "{}" /dev/null ';' ; }

#----------------------------------------------------------

# Git stuff

# 'ginc', 'gco', 'glog', and 'gpo' get 90% of the use.

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
    echo "... If you really mean it, do this ..."
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
function runserve() { 
    pyman runserver \
          --settings="$(basename $(pwd)).settings.${1:-dev}" \
          "0.0.0.0:${2:-8000}" ; 
}
function runserver(){ pyman runserver "$@"; }
function runs()     { runserver "$@"; }
function shp()      { pyman shell_plus --ipython "$@"; }

#--------------------------------------

# AWS ssh and scp utility functions
#    (It is a lot of effort to keep these up to date; I've mostly stopped trying)

function aws_login() { 
    ssh -i ~/.ssh/keypair-2021-12-05.pem  -l ubuntu  3.134.0.116; 
}

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
    #       if push:    the local source
    #       elif pull:  the remote source
    #       else error
    #
    # $3 == the destination file
    #       if push:    the remote destination.  Default is "."
    #       elif pull:  the local  destination.  Default is "."
    #       Caveat User: Using the default destination can overwrite 
    #       something valuable in the current directory.  
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
####----------------------------
###
#### billtorcaso.org on AWS + EC2
####   This is what we want to achieve( different user and different host):
####
####       AWS:    ssh -i "billtorcasoorg.pem" ec2-user@EC2-3-14-194-51.us-east-2.compute.amazonaws.com
####       UBUNTU: ssh -i "billtorcasoorg.pem" ubuntu@ec2-3-16-94-59.us-east-2.compute.amazonaws.com
####
###
####--- "billtorcasoorg.pem" is (supposed to be) used on all AWS EC2 servers.
###export _BTO_AWS_PEM="billtorcasoorg.pem"
###
####--- Settings for my AWS UBUNTU host machine
###
###export _BTO_AWS_UBUNTU_USER="ubuntu";  # Someday, convert to "billtorcaso"
###export _BTO_AWS_UBUNTU_HOST="ec2-3-16-94-59.us-east-2.compute.amazonaws.com"
###
###function ubuntu_bto()   { awsssh $_BTO_AWS_UBUNTU_HOST $_BTO_AWS_PEM ${1:-$_BTO_AWS_UBUNTU_USER}; }
###function ub_bto()       { ubuntu_bto "$@"; }  # Just convenience
###function ub_pull()      { awsscp pull $1 ${2:-.} $_BTO_AWS_UBUNTU_HOST $_BTO_AWS_PEM $_BTO_AWS_UBUNTU_USER; }
###function ub_push()      { awsscp push $1 ${2:-.} $_BTO_AWS_UBUNTU_HOST $_BTO_AWS_PEM $_BTO_AWS_UBUNTU_USER; }
###
####--- Settings for my AWS_LINUX2 host machine (now defunct)
###
###export _BTO_AWS_LINUX2_USER="billtorcaso"
###export _BTO_AWS_LINUX2_HOST="ec2-3-14-194-51.us-east-2.compute.amazonaws.com"
###function aws_bto()      { awsssh $_BTO_AWS_LINUX2_HOST $_BTO_AWS_PEM ${1:-$_BTO_AWS_LINUX2_USER}; }
###function awslin_pull()  { awsscp pull "$1" "${2:-.}" $_BTO_AWS_LINUX2_HOST $_BTO_AWS_PEM $_BTO_AWS_LINUX2_USER; }
###function awslin_push()  { awsscp push "$1" "${2:-.}" $_BTO_AWS_LINUX2_HOST $_BTO_AWS_PEM $_BTO_AWS_LINUX2_USER; }

#--------------------------------------

# Navigation within my $HOME directory tree

[[ -d "$HOME/Bin"       ]] && function Bin() { cd $HOME/Bin/$1 && pwd; }
[[ -d "$HOME/Code"      ]] && function Code() { cd $HOME/Code/$1 && pwd; } && \
                              function code() { Code "$@"; }
[[ -d "$HOME/Tmp"       ]] && function Tmp() { cd $HOME/Tmp/$1 && pwd; } && \
                              function tmp() { Tmp "$@"; }
[[ -d "$HOME/.ssh"      ]] && function _ssh(){ cd $HOME/.ssh/$1 && pwd; }

# -- These are my play projects ...

function brew_here() { Code "Brew-here/$1"; }
function cfpb_here() { Code "CFPB-here/$1"; }
function divio_here() { Code "Divio-here/$1"; }
function dj_tutor_here() { Code "Django-Tutorial-here/$1"; }
function docker_here() { Code "Docker-here/$1"; }
function ifp_here() { Code "Innovators-For-Purpose-here/$1"; }
function bee_here() { Code "NYT-Spelling-Bee-here/$1"; }
function son_of_ninjas_here() { Code "Son-of-Chia-Ninjas-here/$1"; }
function py_stopwatch_here() { Code "Stopwatch_Python_V2/$1"; }
function TSD_here() { Code "TwoScoopsOfDjango-3.x/$1"; }
function chialisp_here() { Code "chialisp-here/$1"; }
function github_here() { Code "github/$1"; }
function pegasys_here() { Code "pegasys-detection-tool-here/$1"; }
function py395_docs_here() { Code "python-3.9.5-docs-html/$1"; }

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

true    # That's all, folks!
