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

#----------------------------

# Navigation Function Definitions and things related to my various non-generic repos

[[ -d "$HOME/Desktop"   ]] && function _desk(){ cd $HOME/Desktop/$1 && pwd; }
[[ -d "$HOME/Downloads" ]] && function _down(){ cd $HOME/Downloads/$1 && pwd; }
[[ -d "$HOME/Desktop/00-Bill-TECH" ]] && function _tech(){ cd $HOME/Desktop/00-Bill-TECH/$1 && pwd; }

[[ -d "/Volumes/SSD-HP-P600/billtorcaso_org_bakery_codebase/bakerydemo"   ]] && { \
    export _BT_SSD_HP_600="/Volumes/SSD-HP-P600/billtorcaso_org_bakery_codebase";
    function ssdrepo()  { cd $_BT_SSD_HP_600/$1 && pwd; }
    function ssd_btb()  { ssdrepo bakerydemo/$1; }  # This is where things happen
    function ssd_venv() { ssdrepo venv_bakerydemo/$1; }
    function ssd_act()  { source $_BT_SSD_HP_600/venv_bakerydemo/bin/activate; }
}

[[ -d "$_BT_GIT_REPOS_HERE/billtorcaso_org_bakery_codebase" ]] && {
    export _BT_BT_BAKERY_REPO="$_BT_GIT_REPOS_HERE/billtorcaso_org_bakery_codebase";
    function btbrepo()  { cd $_BT_BT_BAKERY_REPO/$1; }
    function btb()      { btbrepo bakerydemo/$1; }  # This is where things happen
    function btbb()     { btb bakerydemo/$1; }  # This is where things happen
    function btb_env()  { btbrepo ../venv_bakerydemo/$1; }
    function btb_act()  { source $_BT_BT_BAKERY_REPO/venv_bakerydemo/bin/activate; }
}

[[ -d "$_BT_GIT_REPOS_HERE/extras/bakerydemo" ]] && {
    export _BT_WAG_BAKERYDEMO_REPO="$_BT_GIT_REPOS_HERE/extras/bakerydemo";
    function bakerepo() { cd $_BT_WAG_BAKERYDEMO_REPO/$1; }
    function bake()     { bakerepo $1; }  # This is where things happen
    function bake_env() { bakerepo ../venv_bakerydemo/$1; }
    function bake_act()  { source $_BT_WAG_BAKERYDEMO_REPO/../venv_bakerydemo/bin/activate; cd - > /dev/null; }
}

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

