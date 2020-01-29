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

#### My USB disk canonical copy of images to de-dup and recover
###
###[[ -d "/Volumes/2TBSeagBackupPlusUltraTouch/Photo-Recovery" ]] && function _vpr(){ cd /Volumes/2TBSeagBackupPlusUltraTouch/Photo-Recovery/$1 && pwd; }
###[[ -d "/Volumes/2TBSeagBackupPlusUltraTouch/Photos-Now-Recovered" ]] && echo yes && function _vpnr(){ cd /Volumes/2TBSeagBackupPlusUltraTouch/Photos-Now-Recovered/$1 && pwd; } && fndef _vpnr
####### Don't use this one; use the USB disk instead.
#######[[ -d "$HOME/Desktop/Photo-Recovery" ]] && function _pr(){ cd $HOME/Desktop/Photo-Recovery/$1 && pwd; }

#----------------------------

# Non-generic functions that happen to work on this machine.

function md5r()     { md5 -r $@ | sort; }

#----------------------------

# the learnwagtail.com tutorial on this local machine 

_BT_WAGTAIL_2_X_TUTORIAL="$HOME/Desktop/00-Bill-TECH/play/wagtail_2.x"
function wag2_root() { cd "$_BT_WAGTAIL_2_X_TUTORIAL/$1"; }
function wag2()      { wag2_root mysite/$1; }
function wag2_act()  { wag2 && pipenv shell "$@" ; }
function wag2_deact(){ exit; }  # presumably from a 'pipenv shell' context
function wag2_go()   { wag2 $1 && wag2_act; }

#----------------------------

# the Wagtail 2.x tutorial on this local machine 

_BT_WAGTAIL_2_X_TUTORIAL="$HOME/Desktop/00-Bill-TECH/play/wagtail_2.x"
function wag2_root() { cd "$_BT_WAGTAIL_2_X_TUTORIAL/$1"; }
function wag2()      { wag2_root mysite/$1; }
function wag2_act()  { wag2 && pipenv shell "$@" ; }
function wag2_deact(){ exit; }  # presumably from a 'pipenv shell' context
function wag2_go()   { wag2 $1 && wag2_act; }

#----------------------------

# billtorcaso.org on this local machine 

_BILLTORCASO_ORG_HERE="$HOME/billtorcaso.org-here"
function bto_root() { cd "$_BILLTORCASO_ORG_HERE/$1"; }
function bto()      { bto_root billtorcaso_org/billtorcaso_org/$1; }
function bto_act()  { source $_BILLTORCASO_ORG_HERE/venv_*/bin/activate; }
function bto_deact(){ deactivate; }
function bto_go()   { bto $1 && bto_act; }

#----------------------------

# billtorcaso.org on AWS + EC2
#   This is what we want to achieve:
#
#       ssh -i "billtorcasoorg.pem" ec2-user@ec2-3-14-194-51.us-east-2.compute.amazonaws.com
#
#--- "billtorcasoorg.pem" is (supposed to be) used on all AWS EC2 servers.
export _BTO_AWS_PEM="billtorcasoorg.pem"
#--- Settings for my AWS_LINUX2 host machine
export _BTO_AWS_LINUX2_USER="billtorcaso"
export _BTO_AWS_LINUX2_HOST="ec2-3-14-194-51.us-east-2.compute.amazonaws.com"
function aws_bto() { awsssh $_BTO_AWS_LINUX2_HOST $_BTO_AWS_PEM ${1:-$_BTO_AWS_LINUX2_USER}; }
function awsscp_bto()  { awsscp $1 ${2:-./tmp} $_BTO_AWS_LINUX2_HOST $_BTO_AWS_PEM $_BTO_AWS_LINUX2_USER; }

#--- Settings for my AWS UBUNTU host machine
export _BTO_AWS_UBUNTU_USER="ubuntu";  # Someday, convert to "billtorcaso"
export _BTO_AWS_UBUNTU_HOST="ec2-3-16-94-59.us-east-2.compute.amazonaws.com"
function ubuntu_bto() { awsssh $_BTO_AWS_UBUNTU_HOST $_BTO_AWS_PEM ${1:-$_BTO_AWS_UBUNTU_USER}; }
function ubuntuscp_bto()  { awsscp $1 ${2:-./tmp} $_BTO_AWS_UBUNTU_HOST $_BTO_AWS_PEM $_BTO_AWS_UBUNTU_USER; }

#----------------------------

# Function 'play' - go to the root directory of play projects

export _BT_PLAY_HERE="$HOME/Desktop/00-Bill-TECH/play"
function play() { cd "$_BT_PLAY_HERE/$1"; }

#----------------------------

# bt_wag_play

_BT_WAG_PLAY_HERE="$_BT_PLAY_HERE/bt_wag_play_here"
function bwp_root() { cd "$_BT_WAG_PLAY_HERE/$1"; }
function bwp()      { bwp_root bt_wag_play/$1; }
function bwp_act()  { source "$_BT_WAG_PLAY_HERE/venv_bt_wag_play/bin/activate"; }
function bwp_deact(){ deactivate; }
function bwp_go()   { bwp_act && bwp $1 && green_prompt "[$(basename $PWD)]"; }

#----------------------------

# This is the Peter & Ford Imaging project.  
# It builds a blog with text and images.

export _BT_PF_IMAGING_HERE="$_BT_PLAY_HERE/pfimaging-here"
function pfimaging_root()   { cd "$_BT_PF_IMAGING_HERE/$1"; }
function pfimaging()        { pfimaging_root pfimaging/pfimaging_com/$1; }
function pfi()              { pfimaging $1; }
function pfimaging_act()    { 
    source "$_BT_PF_IMAGING_HERE/venv_pf_imaging/bin/activate"; 
}
function pfimaging_deact()  { deactivate; }
function pfimaging_go()     { pfimaging_act && pfimaging $1 ; }

#----------------------------

# This is the Wagtail open-source photo gallery project.  
# see github 

export _BT_WAGTAIL_PHOTO_GALLERY_ROOT="$_BT_PLAY_HERE/wagtail-photo-gallery-here"
function wpg_root() { cd "$_BT_WAGTAIL_PHOTO_GALLERY_ROOT/$1"; }
function wpg()      { wpg_root "wagtail_photo_gallery/$1"; }
function wpgact()   { source "$_BT_WAGTAIL_PHOTO_GALLERY_ROOT/venv_wagtail_photo_gallery/bin/activate"; }
function wpgdeact() { deactivate; }
function wpg_go()   { wtact && wt $1; }

