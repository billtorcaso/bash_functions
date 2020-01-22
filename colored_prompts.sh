#----------------------------------------------------------

# I use colored prompts to indicate the type of machine this is.
#   green     ==  development server
#   magenta   ==  production server, and/or host of a Docker container
#   red       ==  production code running within a Docker container
#   blue      ==  ???
#   cyan      ==  ???
#   yellow    ==  Too hard on my eyes
#   black     ==  restore the default color (black)

###function bt_prompt()     { PS1='\[\e[35m\]'"[${1:+$1}]"'[ $? ][\u][\h]\n[\w]\n\[\e[30m\]'; }
function magenta_prompt()   { PS1="${1}"'\[\e[35m\][ $? ][\u][\h]\n[\w]\n\[\e[30m\]'; }
function green_prompt()     { PS1="${1}"'\[\e[32m\][ $? ][\u][\h]\n[\w]\n\[\e[30m\]'; }
function red_prompt()       { PS1="${1}"'\[\e[31m\][ $? ][\u][\h]\n[\w]\n\[\e[30m\]'; }
function cyan_prompt()      { PS1="${1}"'\[\e[36m\][ $? ][\u][\h]\n[\w]\n\[\e[30m\]'; }
function black_prompt()     { PS1="${1}"'[ $? ][\u][\h]\n[\w]\n '; }

#   This is my favorite for local use: The delineator is white text on a teal background
function setPS1()  {
    PS1='\[\e[7;36m\]----------\[\e[27;30m\]\n[ $? ][\u][\h]\n[\w]\n'
}
#   This is for use with a virtual environment.  It makes the delineator cover the 
#   whole top line
function colorPS1(){ PS1="\[\e[7;36m\]$PS1"; }

