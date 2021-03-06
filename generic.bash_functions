#!/usr/bin/env bash
#
# Bill Torcaso's generic bash settings
#
# This script is (supposed to be) idempotent
# And it is (supposed to be) fully generic,
# with no OS-specific or System-specific defintions.

#----------------------------------------------------------
# This is an experiment
function ...() {
    cd $(find "${2:-$HOME}" -type d -name "${1}" 2>/dev/null);
    pwd;
}

#----------------------------------------------------------
# This is another experiment
function s3fetch() {
  local this_bucket="${THIS_BUCKET:-just-plain-file-storage}"
  local this_key="${1}"
  local this_log="${2:-s3fetch.log}"
  [[ "$this_bucket" == "" ]] && \
       { echo 2>&1 "Need '--bucket'; return 1; }
  [[ "$this_key" == "" ]] && \
       { echo 2>&1 "Need '--key'; return 2; }

  echo "$this_key" >> "$this_log" 
  aws s3api \
    get-object  \
    --bucket "$this_bucket" \
    --key "$this_key"  \
    "$this_key" >> "$this_log" 2>&1
   echo "$? : $this_key" > /dev/tty
}

#----------------------------------------------------------
# I use colored prompts to indicate the type of machine this is.
#   green     ==  development server
#   magenta   ==  production server, and/or host of a Docker container
#   red       ==  production code running within a Docker container
#   blue      ==  ???
#   cyan      ==  ???
#   yellow    ==  Too hard on my eyes
#   black     ==  restore the default color (black)

###function bt_prompt()     { PS1='\[\e[35m\]'"[${1:+$1}]"'[ $? ][\u][\h]\n[\w]\n\[\e[;30m\]' | sed 'd/^[+]/'; }
function magenta_prompt()   { PS1="${1}"'\[\e[35m\][ $? ][\u][\h]\n[\w]\n\[\e[;30m\]' | sed 'd/^[+]/'; }
function green_prompt()     { PS1='\[\e[32m\]'"${1:+[$1]}"'[ $? ][\u][\h]\n[\w]\n\[\e[;30m\]' | sed 'd/^[+]/'; }
function red_prompt()       { PS1="${1}"'\[\e[31m\][ $? ][\u][\h]\n[\w]\n\[\e[;30m\]' | sed 'd/^[+]/'; }
function cyan_prompt()      { PS1="${1}"'\[\e[36m\][ $? ][\u][\h]\n[\w]\n\[\e[;30m\]' | sed 'd/^[+]/'; }
function black_prompt()     { PS1="${1}"'[ $? ][\u][\h]\n[\w]\n ' | sed 'd/^[+]/'; }

# This is my favorite for local use: The foreground of the prompt is white text on a teal background
function setPS1()  {
    PS1='\[\e[7;36m\]----------\[\e[27;30m\]\n[ $? ][\u][\h]\n[\w]\n'
}
#   This is for use with a virtual environment.  It makes the delineator cover the 
#   whole top line
function colorPS1(){ PS1="\[\e[7;36m\]$PS1"; }

#----------------------------

# Navigation Function Definitions and things related to my various repos.  
#
# This is generic only because each stanza is guarded by a test for whether 
# the target directory exists or not.

[[ -d "$HOME/DesktopBT"   ]] && function bt_desk(){ cd $HOME/DesktopBT/$1 && pwd; }
[[ -d "$HOME/DocumentsBT"   ]] && function bt_doc(){ cd $HOME/DocumentsBT/$1 && pwd; }
[[ -d "$HOME/DesktopBT/00-Bill-TECH" ]] && function bt_tech(){ bt_desk 00-Bill-TECH/$1; }
[[ -d "$HOME/DesktopBT/00-Money-Mgmt-Here" ]] && function money(){ bt_desk 00-Money-Mgmt-Here/$1; }
[[ -d "$HOME/Downloads" ]] && function down(){ cd $HOME/Downloads/$1 && pwd; }
[[ -d "$HOME/Desktop" ]] && function desk(){ cd $HOME/Desktop/$1 && pwd; }

#----------------------------

# Function 'play' - go to the root directory of play projects

[[ -d "$CODE/play" ]] && {
    export _BT_PLAY_HERE="$CODE/play"
    function play() { cd "$_BT_PLAY_HERE/$1"; }
}
[[ -d "$HOME/DesktopBT/00-Bill-TECH/play/PracticalPythonProjects" ]] && {
    export _BT_PPP_HERE="$_BT_PLAY_HERE/PracticalPythonProjects/$1"; 
    function ppp()      { play "PracticalPythonProjects/$1"; }
    function ppp_act()  { source $_BT_PPP_HERE/venv_ppp/bin/activate; colorPS1; }
    function ppp_go()   { ppp && ppp_act ; }
}

[[ -d "$_BT_GIT_REPOS_HERE/www_billtorcaso_org" ]] && {
    export _BT_WWW_BILLTORCASO_ORG_REPO="$_BT_GIT_REPOS_HERE/www_billtorcaso_org";
    function btorepo()  { cd $_BT_WWW_BILLTORCASO_ORG_REPO/$1; }
    function bto()      { btorepo $1; } # This is where things run
    function btow()     { bto www_billtorcaso_org/$1; }
    function btoenv()   { btorepo venv_bto_rebuild/$1; }
    function bto_act()  { source $_BT_WWW_BILLTORCASO_ORG_REPO/venv_www_billtorcaso_org/bin/activate; colorPS1; }
    function bto_go()   { bto && bto_act && ginc; }
    # The above functions are standard.  Here are the special-purpose ones.
    function btp()      { bto BTOPage/$1; }
    function btpt()     { btp templates/BTOPage/$1; }

    # This is an experiment for use with visett
    function bt()       { btorepo "$@"; }
}

####    These are old-think

###[[ -d "$_BT_GIT_REPOS_HERE/bto_rebuild" ]] && {
###    export _BT_BT_REBUILD_REPO="$_BT_GIT_REPOS_HERE/bto_rebuild";
###    function btorrepo() { cd $_BT_BT_REBUILD_REPO/$1; }
###    function btor()     { btorrepo bto_rebuild/$1; } # This is where things run
###    function btorb()    { btor bto_rebuild/$1; }     # This is where coding happens
###    function btorenv()  { btorrepo venv_bto_rebuild/$1; }
###    function btor_act() { source $_BT_BT_REBUILD_REPO/venv_bto_rebuild/bin/activate; colorPS1; }
###    function btor_go()  { btor && btor_act; }
###}
###
###[[ -d "/Volumes/SSD-HP-P600/billtorcaso_org_bakery_codebase/bakerydemo"   ]] && { \
###    export _BT_SSD_HP_600="/Volumes/SSD-HP-P600/billtorcaso_org_bakery_codebase";
###    function ssdrepo()  { cd $_BT_SSD_HP_600/$1 && pwd; }
###    function ssd_btb()  { ssdrepo bakerydemo/$1; }  # This is where things happen
###    function ssdvenv()  { ssdrepo venv_bakerydemo/$1; }
###    function ssd_act()  { source $_BT_SSD_HP_600/venv_bakerydemo/bin/activate; }
###}
###
###[[ -d "$_BT_GIT_REPOS_HERE/billtorcaso_org_bakery_codebase" ]] && {
###    export _BT_BT_BAKERY_REPO="$_BT_GIT_REPOS_HERE/billtorcaso_org_bakery_codebase";
###    function btbrepo()  { cd $_BT_BT_BAKERY_REPO/$1; }
###    function btb()      { btbrepo bakerydemo/$1; }  # This is where things happen
###    function btbb()     { btb bakerydemo/$1; }  # This is where things happen
###    function btbenv()   { btbrepo venv_bakerydemo/$1; }
###    function btb_act()  { source $_BT_BT_BAKERY_REPO/venv_bakerydemo/bin/activate; }
###}
###
###[[ -d "$_BT_GIT_REPOS_HERE/extras/bakerydemo" ]] && {
###    export _BT_WAG_BAKERYDEMO_REPO="$_BT_GIT_REPOS_HERE/extras/bakerydemo";
###    function bakerepo() { cd $_BT_WAG_BAKERYDEMO_REPO/$1; }
###    function bake()     { bakerepo $1; }  # This is where things happen
###    function bakeenv()  { bakerepo venv_bakerydemo/$1; }
###    function bake_act()  { source $_BT_WAG_BAKERYDEMO_REPO/../venv_bakerydemo/bin/activate; cd - > /dev/null; }
###}
###

#----------------------------------------------------------
# General Bash services, defined as bash functions

function blackdot() { black "${@:-.}"; }  # The semi-standard Python reformatting tool.
function cls()      { clear; }
function deact()    { deactivate; } # just laziness
function dfh()      { df -h "${@:-.}"; }
function dush()     { sudoo du -sh "${@:-.}"; }
function envg()     { env | grep "${@:-.}" | sort; }
function fndef()    { declare -f $@; }
function fneg ()    { declare -F | grep "$@"; }
function h20()      { history | tail -n ${@:-20}; }
function heg()      { history | grep $@; }
function logs()     { tmp logs/$1; }
function ls1()      { ls -1 "$@"; }
function lstr()     { ls -tr1 "$@"; }
function nsl()      { nslookup "$@"; }
function scriptlog(){ script ${1:-$HOME/Tmp/scriptlogs/scriptlog-$(date +%F-%R).txt}; }
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
function ffpy()     { ff "$@" | grep "[.]py$" ; } #   find python files
#   find my own CSS files
function ffcss()    { ffeg '[.]css$' | grep -v -e '^[.]/static/admin' -e '^[.]/static/wagtail'; }

#   These are lazyness - apply 'vi' to selected files
function viff()     { vi $(ff); }
function viffeg()   { vi $(ffeg "$@"); }
function vipy()     { vi $(ffpy); }
function viginc()   { vi $(ginc | awk '$1 !~ "##" { print $2; }'); }

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
    echo "... If you really mean it, do this ..."
    echo "git push origin --delete '$1' && git branch -d '$1'"
}

#----------------------------------------------------------

# For a Wagtail-based Django project (only)

function visett()   { ( bt && vi */settings/[a-z]*.py; ) }  #function 'bt' is always my active project.
function vimod()    { vi ${1:-*}/models.py; }
function vireq()    { vi requirements.txt requirements/*; }
# This needs work.
function vihtml()   { vi "$@" $(ffeg html | grep -v -e [45]0[40] -e search -e welcome_page); }
function vihome()   { vi "$@" \
                         ./home/templates/home/home_page.html \
                         ./www_billtorcaso_org/static/css/www_billtorcaso_org.css \
                         ./www_billtorcaso_org/templates/base.html; 
                    }
function vicss()    { vi "$@" \
                         ./www_billtorcaso_org/static/css/www_billtorcaso_org.css \
                         ;
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
#----------------------------

# billtorcaso.org on AWS + EC2
#   This is what we want to achieve( different user and different host):
#
#       AWS:    ssh -i "billtorcasoorg.pem" ec2-user@ec2-3-14-194-51.us-east-2.compute.amazonaws.com
#       UBUNTU: ssh -i "billtorcasoorg.pem" ubuntu@ec2-3-16-94-59.us-east-2.compute.amazonaws.com
#

#--- "billtorcasoorg.pem" is (supposed to be) used on all AWS EC2 servers.
export _BTO_AWS_PEM="billtorcasoorg.pem"

#--- Settings for my AWS UBUNTU host machine

export _BTO_AWS_UBUNTU_USER="ubuntu";  # Someday, convert to "billtorcaso"
export _BTO_AWS_UBUNTU_HOST="ec2-3-16-94-59.us-east-2.compute.amazonaws.com"

function ubuntu_bto()   { awsssh $_BTO_AWS_UBUNTU_HOST $_BTO_AWS_PEM ${1:-$_BTO_AWS_UBUNTU_USER}; }
function ub_bto()       { ubuntu_bto "$@"; }  # Just convenience
function ub_pull()      { awsscp pull $1 ${2:-.} $_BTO_AWS_UBUNTU_HOST $_BTO_AWS_PEM $_BTO_AWS_UBUNTU_USER; }
function ub_push()      { awsscp push $1 ${2:-.} $_BTO_AWS_UBUNTU_HOST $_BTO_AWS_PEM $_BTO_AWS_UBUNTU_USER; }

#--- Settings for my AWS_LINUX2 host machine (now defunct)

export _BTO_AWS_LINUX2_USER="billtorcaso"
export _BTO_AWS_LINUX2_HOST="ec2-3-14-194-51.us-east-2.compute.amazonaws.com"
function aws_bto()      { awsssh $_BTO_AWS_LINUX2_HOST $_BTO_AWS_PEM ${1:-$_BTO_AWS_LINUX2_USER}; }
function awslin_pull()  { awsscp pull "$1" "${2:-.}" $_BTO_AWS_LINUX2_HOST $_BTO_AWS_PEM $_BTO_AWS_LINUX2_USER; }
function awslin_push()  { awsscp push "$1" "${2:-.}" $_BTO_AWS_LINUX2_HOST $_BTO_AWS_PEM $_BTO_AWS_LINUX2_USER; }

####----------------------------------------------------------
###
####   OBSOLETE:   Generic SCP shortcut functions WITHOUT a key-pair file
###
####   The pull operations are "person, servername, thing, destination"
####   The push operations are "thing, person, servername, destination"
###
###function scppull()  { (set -x;  scp -o PubkeyAuthentication=no  "${1}@${2}:${3}" "${4:-.}"; ) }
###function scppush()  { (set -x;  scp -o PubkeyAuthentication=no  "${1}" "${2}@${3}:${4:-.}"; ) }
###
#----------------------------------------------------------

# Navigation within my $HOME directory tree

[[ -d "$HOME/Bin"       ]] && function Bin() { cd $HOME/Bin/$1 && pwd; }
[[ -d "$HOME/Code"      ]] && function Code() { cd $HOME/Code/$1 && pwd; } && \
                              function code() { Code "$@"; }
[[ -d "$HOME/Tmp"       ]] && function Tmp() { cd $HOME/Tmp/$1 && pwd; } && \
                              function tmp() { Tmp "$@"; }
[[ -d "$HOME/.ssh"      ]] && function _ssh(){ cd $HOME/.ssh/$1 && pwd; }

#----------------------------------------------------------

#   Vagrant commands (if vagrant is installed locally)

[[ "$(which vagrant> /dev/null 2>&1; echo $?)" == 0 ]] && {
    function vg()       { vagrant $@; }
    function vggst()    {  vg global-status "$@" | grep '^[0-9a-fA-F]' | sort -r -k 4,4 -k 5,5r | awk '{ print $1, $4, $5}'; }
    function vssh()     { ( set -x;  vg ssh "$@"; ) }
    function upshell()  {  vg up && vssh "$@"; }
}

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
path_set $HOME/tmp/s3api

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
