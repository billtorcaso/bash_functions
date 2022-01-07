# Temporary things, before I decide to promote them.

export _BT_BTO_KEYPAIR="$HOME/.ssh/key-BTO-2021-12-09-V2.pem"
export _BT_BTO_PUBLIC_IP=ec2-18-118-47-163.us-east-2.compute.amazonaws.com


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
        ssh -i ${_BT_BTO_KEYPAIR} \
            ubuntu@${_BT_BTO_PUBLIC_IP} \
            "${@:--v}";
    )
    pwd
}

ec2curl()   {
    curl ec2-3-133-238-192.us-east-2.compute.amazonaws.com:${1:-8000};
}

# "Homebrew" is Macos only
function ngetc()    { cd /opt/homebrew/etc/nginx/"$1"; }
function nglog()    { cd /opt/homebrew/var/log/nginx/"$1"; }
