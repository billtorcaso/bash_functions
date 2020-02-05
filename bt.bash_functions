#!/usr/bin/env bash

#----------------------------

# Experiments and temporary things go here ...

[[ -d "$HOME/Desktop/00-Bill-TECH/PHOTO_RECOVERY_INFO_HERE" ]] && \
    function _prih(){ cd $HOME/Desktop/00-Bill-TECH/PHOTO_RECOVERY_INFO_HERE/$1 && pwd; }
function s3p()  { ( _prih && sql3 $@ ./sql-here/photo-recovery-info.db; ) }
function ffgo() { _prih ff-here/$1; }
function mdgo() { _prih md5hash-here/$1; }
function tmpgo(){ _prih tmp/$1; }

#----------------------------

# Setting PATH for Python 3.8
PATH="/Library/Frameworks/Python.framework/Versions/3.8/bin:${PATH}"
export PATH

#----------------------------

# Navigation Function Definitions
# TODO:  (should pull much of this out into a Darwin-specfic file)

[[ -d "$HOME/Desktop/00-Bill-TECH" ]] && function _tech(){ cd $HOME/Desktop/00-Bill-TECH/$1 && pwd; }

#   Things related to my billtorcaso.org repo
[[ -d "$_BT_GIT_REPOS_HERE/billtorcaso-repos-here" ]] && {
    export _BT_BILLTORCASO_ORG_REPO="$_BT_GIT_REPOS_HERE/billtorcaso_org"
}

[[ -d "$_BT_BILLTORCASO_ORG_REPO" ]] && {
    function btorepo()  { cd $_BT_BILLTORCASO_ORG_REPO/$1; }
    function bto()      { btorepo billtorcaso_org/$1; }  # This is where things happen
    function bto_venv() { btorepo venv_billtorcaso_org/$1; }
    function bto_act()  { source $_BT_BILLTORCASO_ORG_REPO/venv_billtorcaso_org/bin/activate; }
}

[[ -d "$_BT_BILLTORCASO_ORG_REPO/extras/bakerydemo" ]] && {
    export _BT_WAG_BAKERYDEMO_REPO="$_BT_BILLTORCASO_ORG_REPO/extras/bakerydemo";
    function bakerepo() { cd $_BT_WAG_BAKERYDEMO_REPO/$1; }
    function bake()     { bakerepo $1; }  # This is where things happen
    function bake_env() { bakerepo venv_billtorcaso_org/$1; }
    function bake_act()  { source $_BT_WAG_BAKERYDEMO_REPO/../venv_bakerydemo/bin/activate; cd - > /dev/null; }
}

#----------------------------

# Non-generic functions that happen to work on this machine.

function md5r()     { md5 -r $@ | sort; }

#----------------------------

# the learnwagtail.com tutorial on this local machine 

_BT_WAGTAIL_2_X_TUTORIAL="$HOME/Desktop/00-Bill-TECH/play/wagtail_2.x"

#----------------------------

# billtorcaso.org on AWS + EC2
#   This is what we want to achieve( different user and different host):
#
#       AWS:    ssh -i "billtorcasoorg.pem" ec2-user@ec2-3-14-194-51.us-east-2.compute.amazonaws.com
#       UBUNTU: ssh -i "billtorcasoorg.pem" ubuntu@ec2-3-16-94-59.us-east-2.compute.amazonaws.com
#

#--- "billtorcasoorg.pem" is (supposed to be) used on all AWS EC2 servers.
export _BTO_AWS_PEM="billtorcasoorg.pem"

#--- Settings for my AWS_LINUX2 host machine

export _BTO_AWS_LINUX2_USER="billtorcaso"
export _BTO_AWS_LINUX2_HOST="ec2-3-14-194-51.us-east-2.compute.amazonaws.com"
function aws_bto()      { awsssh $_BTO_AWS_LINUX2_HOST $_BTO_AWS_PEM ${1:-$_BTO_AWS_LINUX2_USER}; }
function awslin_pull(){ awsscp pull "$1" "${2:-.}" $_BTO_AWS_LINUX2_HOST $_BTO_AWS_PEM $_BTO_AWS_LINUX2_USER; }
function awslin_push(){ awsscp push "$1" "${2:-.}" $_BTO_AWS_LINUX2_HOST $_BTO_AWS_PEM $_BTO_AWS_LINUX2_USER; }

#--- Settings for my AWS UBUNTU host machine

export _BTO_AWS_UBUNTU_USER="ubuntu";  # Someday, convert to "billtorcaso"
export _BTO_AWS_UBUNTU_HOST="ec2-3-16-94-59.us-east-2.compute.amazonaws.com"

function ubuntu_bto()   { awsssh $_BTO_AWS_UBUNTU_HOST $_BTO_AWS_PEM ${1:-$_BTO_AWS_UBUNTU_USER}; }
function ubun_pull()    { awsscp pull $1 ${2:-.} $_BTO_AWS_UBUNTU_HOST $_BTO_AWS_PEM $_BTO_AWS_UBUNTU_USER; }
function ubun_push()    { awsscp push $1 ${2:-.} $_BTO_AWS_UBUNTU_HOST $_BTO_AWS_PEM $_BTO_AWS_UBUNTU_USER; }

#----------------------------

# Function 'play' - go to the root directory of play projects

export _BT_PLAY_HERE="$HOME/Desktop/00-Bill-TECH/play"
function play() { cd "$_BT_PLAY_HERE/$1"; }

#----------------------------

# This is the Wagtail open-source photo gallery project.  
# see github 

export _BT_WAGTAIL_PHOTO_GALLERY_ROOT="$_BT_PLAY_HERE/wagtail-photo-gallery-here"
function wpg_root() { cd "$_BT_WAGTAIL_PHOTO_GALLERY_ROOT/$1"; }
function wpg()      { wpg_root "wagtail_photo_gallery/$1"; }
function wpgact()   { source "$_BT_WAGTAIL_PHOTO_GALLERY_ROOT/venv_wagtail_photo_gallery/bin/activate"; }
function wpgdeact() { deactivate; }
function wpg_go()   { wtact && wt $1; }

