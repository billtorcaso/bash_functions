#!/usr/bin/env bash

#----------------------------

# This file is specific to DARWIN, aka MacOS

#----------------------------

# Experiments and temporary things go here ...

[[ -d "$HOME/bin/python38" ]] && \
    py38_act() { source "$HOME/bin/python38/bin/activate"; }

[[ -d "$HOME/DesktopBT/00-Bill-TECH/PHOTO_RECOVERY_INFO_HERE" ]] && {
    function _prih(){ 
      cd $HOME/DesktopBT/00-Bill-TECH/PHOTO_RECOVERY_INFO_HERE/$1 && pwd;
    }
    function _pr()  { _desk Photo-Recovery/$1; }
    function s3p()  { ( _prih && sql3 $@ ./sql-here/photo-recovery-info.db; ) }
    function ffgo() { _prih ff-here/$1; }
    function mdgo() { _prih md5hash-here/$1; }
}

#----------------------------

#### Setting PATH for Python 3.8
###PY38_ROOT="/Library/Frameworks/Python.framework/Versions/3.8"
###[[ -r "$PY38_ROOT" ]] && {
###export PATH="$PY38_ROOT/bin:$PATH"
###}

####----------------------------
###
#### the learnwagtail.com tutorial on this local machine 
###
###[[ -d "$_BT_BILLTORCASO_ORG_REPO/extras/bakerydemo" ]] && {
###    _BT_WAGTAIL_2_X_TUTORIAL="$HOME/DesktopBT/00-Bill-TECH/play/wagtail_2.x"
###}
###
#----------------------------

# This is the Wagtail open-source photo gallery project.  
# see github 

[[ -d "$_BT_PLAY_HERE/wagtail-photo-gallery-here" ]] && {
    export _BT_WAGTAIL_PHOTO_GALLERY_ROOT="$_BT_PLAY_HERE/wagtail-photo-gallery-here"
    function wpg_root() { cd "$_BT_WAGTAIL_PHOTO_GALLERY_ROOT/$1"; }
    function wpg()      { wpg_root "wagtail_photo_gallery/$1"; }
    function wpg_act()   { source "$_BT_WAGTAIL_PHOTO_GALLERY_ROOT/venv_wagtail_photo_gallery/bin/activate"; }
}

#----------------------------

# Non-generic functions that happen to work on this machine.

[[ "$(which -s md5; echo $?)" == 0 ]] && {
    function md5r()     { md5 -r $@ | sort; }
}

[[ "$(which -s md5sum; echo $?)" == 0 ]] && {
    function md5r()     { md5sum $@ | sort; }
}

true    # That's all, folks!
