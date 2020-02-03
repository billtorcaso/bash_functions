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

[[ -d "$HOME/Downloads" ]] && function _down(){ cd $HOME/Downloads/$1 && pwd; }
[[ -d "$HOME/Desktop" ]] && function _desk(){ cd $HOME/Desktop/$1 && pwd; }
[[ -d "$HOME/Desktop/00-Bill-TECH" ]] && function _tech(){ cd $HOME/Desktop/00-Bill-TECH/$1 && pwd; }

#----------------------------

# Non-generic functions that happen to work on this machine.

function md5r()     { md5 -r $@ | sort; }

#----------------------------

# the learnwagtail.com tutorial on this local machine 

_BT_WAGTAIL_2_X_TUTORIAL="$HOME/Desktop/00-Bill-TECH/play/wagtail_2.x"

#----------------------------

# billtorcaso.org on MAC + AWS + EC2
#   This is what we want to achieve:
#
#       ssh -i "billtorcasoorg.pem" ec2-user@ec2-3-14-194-51.us-east-2.compute.amazonaws.com
#
#--- Local execution on this MAC


#--- "billtorcasoorg.pem" is (supposed to be) used on all AWS EC2 servers.
export _BTO_AWS_PEM="billtorcasoorg.pem"
#--- Settings for my AWS_LINUX2 host machine
export _BTO_AWS_LINUX2_USER="billtorcaso"
export _BTO_AWS_LINUX2_HOST="ec2-3-14-194-51.us-east-2.compute.amazonaws.com"
function aws_bto()      { awsssh $_BTO_AWS_LINUX2_HOST $_BTO_AWS_PEM ${1:-$_BTO_AWS_LINUX2_USER}; }
function awsscp_bto()   { awsscp $1 ${2:-./tmp} $_BTO_AWS_LINUX2_HOST $_BTO_AWS_PEM $_BTO_AWS_LINUX2_USER; }

#--- Settings for my AWS UBUNTU host machine
export _BTO_AWS_UBUNTU_USER="ubuntu";  # Someday, convert to "billtorcaso"
export _BTO_AWS_UBUNTU_HOST="ec2-3-16-94-59.us-east-2.compute.amazonaws.com"
function ubuntu_bto()   { awsssh $_BTO_AWS_UBUNTU_HOST $_BTO_AWS_PEM ${1:-$_BTO_AWS_UBUNTU_USER}; }
function ubuntuscp_bto(){ awsscp $1 ${2:-./tmp} $_BTO_AWS_UBUNTU_HOST $_BTO_AWS_PEM $_BTO_AWS_UBUNTU_USER; }
function ubto()         { ubuntu_bto "$@"; }

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

