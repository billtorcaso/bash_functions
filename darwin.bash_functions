#!/usr/bin/env bash

#----------------------------

# Experiments and temporary things go here ...

[[ -d "$HOME/Desktop/00-Bill-TECH/PHOTO_RECOVERY_INFO_HERE" ]] && \
    function _prih(){ cd $HOME/Desktop/00-Bill-TECH/PHOTO_RECOVERY_INFO_HERE/$1 && pwd; }
function s3p()  { ( _prih && sql3 $@ ./sql-here/photo-recovery-info.db; ) }
function ffgo() { _prih ff-here/$1; }
function mdgo() { _prih md5hash-here/$1; }

#----------------------------

# Setting PATH for Python 3.8
PATH="/Library/Frameworks/Python.framework/Versions/3.8/bin:${PATH}"
export PATH

####----------------------------
###
#### the learnwagtail.com tutorial on this local machine 
###
###[[ -d "$_BT_BILLTORCASO_ORG_REPO/extras/bakerydemo" ]] && {
###    _BT_WAGTAIL_2_X_TUTORIAL="$HOME/Desktop/00-Bill-TECH/play/wagtail_2.x"
###}
###
#----------------------------

# Function 'play' - go to the root directory of play projects

[[ -d "$_BT_BILLTORCASO_ORG_REPO/extras/bakerydemo" ]] && {
    export _BT_PLAY_HERE="$HOME/Desktop/00-Bill-TECH/play"
    function play() { cd "$_BT_PLAY_HERE/$1"; }
}

#----------------------------

# This is the Wagtail open-source photo gallery project.  
# see github 

[[ -d "$_BT_BILLTORCASO_ORG_REPO/extras/bakerydemo" ]] && {
    export _BT_WAGTAIL_PHOTO_GALLERY_ROOT="$_BT_PLAY_HERE/wagtail-photo-gallery-here"
    function wpg_root() { cd "$_BT_WAGTAIL_PHOTO_GALLERY_ROOT/$1"; }
    function wpg()      { wpg_root "wagtail_photo_gallery/$1"; }
    function wpgact()   { source "$_BT_WAGTAIL_PHOTO_GALLERY_ROOT/venv_wagtail_photo_gallery/bin/activate"; }
    function wpgdeact() { deactivate; }
    function wpg_go()   { wtact && wt $1; }
}

#----------------------------

# Non-generic functions that happen to work on this machine.

function md5r()     { md5 -r $@ | sort; }

