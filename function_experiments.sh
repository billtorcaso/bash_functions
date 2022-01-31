# Temporary things, before I decide to promote them.

[[ -d $HOME/.local/bin ]] && \
{
	PATH="$PATH:$HOME/.local/bin"
} || \
{ echo 1>&2 "Warning: can't find $HOME/.local/bin"; }

export _BT_BTO_KEYPAIR="$HOME/.ssh/key-BTO-2021-12-09-V2.pem"
export _BT_BTO_IP_PUBLIC_4DOTS=3.142.231.109
export _BT_BTO_IP_PUBLIC_NAME=ec2-$(sed 's/[.]/-/g' <<<"$_BT_BTO_IP_PUBLIC_4DOTS").us-east-2.compute.amazonaws.com


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
function bto2() { Code bto-2022-01-06-here/bto-2022-01-06/billtorcaso_org/"$1"; }

function bto2_act()    { 
    source $HOME/Code/bto-2022-01-06-here/venv-bto-2022-01-06/bin/activate;
}

# for the wag tutorial that has a photogallery

function wagtut() { Code wagtutorial-2022-01-27-here/wagtutorial/"$1"; }
function wagtut_act() { 
    source ~/Code/wagtutorial-2022-01-27-here/venv_wag_tutorial/bin/activate;
}

# for the offical wagtail bakery demo

function wagbake()      {  Code wagtailbakerydemo-here/bakerydemo/"$1"; }
function wagbake_act()  {
    source ~/Code/wagtailbakerydemo-here/venv_wagtailbakerydemo-here/bin/activate;
}

# Log in to AWS EC2 instance, aka 'billtorcaso.org'

function ec2sh(){ 
    clear;
    (   cd $HOME/tmp;
        ssh -i ${_BT_BTO_KEYPAIR} \
            ubuntu@${_BT_BTO_IP_PUBLIC_NAME} \
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
