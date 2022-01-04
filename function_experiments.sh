# Temporary things, before I decide to promote them.

function fns_begin()  {
    fns_refresh && \
    source $HOME/m1.setup;
}

function fns_refresh()  {
    source $HOME/bin/truly_generic.bash_functions && \
    source $HOME/bin/function_experiments.sh;
}

function gth()  { Code github-here/"$1"; }
function btoh() { gth bto_v2/"$1"; }

function ec2sh(){ 
    clear;
    (   cd $HOME/tmp;
        ssh -i "$HOME/.ssh/key-BTO-2021-12-09-V2.pem" \
            ubuntu@ec2-3-133-238-192.us-east-2.compute.amazonaws.com \
            "$@";
    )
    pwd
}

btosh() { echo 1>&2 "This function name iss obsolete; use 'ec2sh'."; }

btocurl()   {
    curl ec2-3-133-238-192.us-east-2.compute.amazonaws.com:${1:-8000};
}
