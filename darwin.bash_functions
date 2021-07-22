#!/usr/bin/env bash

#----------------------------

# This file is specific to DARWIN, aka MacOS

#----------------------------

# Experiments and temporary things go here ...


#----------------------------

# Non-generic functions that happen to work on this machine.

[[ "$(which -s md5; echo $?)" == 0 ]] && {
    function md5r()     { md5 -r $@ | sort; }
}

[[ "$(which -s md5sum; echo $?)" == 0 ]] && {
    function md5r()     { md5sum $@ | sort; }
}

true    # That's all, folks!
