#!/usr/bin/env bash

#----------------------------

# This file is specific to DARWIN, aka MacOS

#----------------------------

# Non-generic functions that happen to work on this machine.

[[ "$(which -s md5; echo $?)" == 0 ]] && {
    function md5r()     { md5 -r $@ | sort; }
}

[[ "$(which -s md5sum; echo $?)" == 0 ]] && {
    function md5r()     { md5sum $@ | sort; }
}


#----------------------------------------------------------
# This is an experiment
export TAX2021="$HOME/Desktop/2021-Tax-Prep-here";
function tax21() { cd $TAX2021/"$1"; }
function mvtax21()  { mv "$@" $TAX2021; }


####----------------------------------------------------------
#### This is an experiment
###function ...() {
###    cd $(find "${2:-$HOME}" -type d -name "${1}" 2>/dev/null);
###    pwd;
###}

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

true    # That's all, folks!
