# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#-------------------------------------------------------------
# Greeting, motd etc. ...
#-------------------------------------------------------------

# Color definitions (taken from Color Bash Prompt HowTo).
# Some colors might look different of some terminals.
# For example, I see 'Bold Red' as 'orange' on my screen,
# hence the 'Green' 'BRed' 'Red' sequence I often use in my prompt.

# Normal Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

NC="\e[m"               # Color Reset

ALERT=${BWhite}${On_Red} # Bold White on red background

# Starting message
#echo -e "${Blue}This is BASH ${Red}${BASH_VERSION%.*}${Blue}\
#- DISPLAY on ${Red}$DISPLAY${NC}"

# For fortune
#if [ -x /usr/games/fortune ]; then
#    fortune | cowsay     # Makes our day a bit more fun.... :-)
#fi

function _exit()              # Function to run upon exit of shell.
{
    echo -e "${Blue}Bye bye now.${NC}"
}
trap _exit EXIT


# Test connection type:
#if [ -n "${SSH_CONNECTION}" ]; then
    #CNX=${Green}        # Connected on remote machine, via ssh (good).
#elif [[ "${DISPLAY%%:0*}" != "" ]]; then
    #CNX=${ALERT}        # Connected on remote machine, not via ssh (bad).
#elif [ -n "$TMUX" ]; then
    #CNX=${BBlack}        # tmux session
#else
    #CNX=${BBlue}        # Connected on local machine.
#fi

## Test user type:
#if [[ ${USER} == "root" ]]; then
    #SU=${Red}           # User is root.
##elif [[ ${USER} != $(logname) ]]; then
##    SU=${BRed}          # User is not login user.
#else
    #SU=${BCyan}         # User is normal (well ... most of us are).
#fi

# Adds some text in the terminal frame (if applicable).

PROMPT_COMMAND="history -a"

## unconditional, try to use color support everywhere
#PS1="\[${SU}\]\u@\[${CNX}\]\h\[${NC}\]:"
#PS1=${PS1}"\W\[${CNX}\]>\[${NC}\] "

PS1="\[${BCyan}\]\u@\[${BBlue}\]\h\[${NC}\]:\[${Green}\]\W\[${NC}\]> "

export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export HISTIGNORE="&:bg:fg:ll:h"
export HISTTIMEFORMAT="$(echo -e ${BCyan})[%d/%m %H:%M:%S]$(echo -e ${NC}) "
export HISTCONTROL=ignoredups
export HOSTFILE=$HOME/.hosts    # Put a list of remote hosts in ~/.hosts

# Add colors for filetype and  human-readable sizes by default on 'ls':
alias ls='ls -h --color'

function cd_
{
  #[[ -d "$@" ]] || return 1
  cd "$@"
  echo $(pwd) > ~/.last_dir
}
# Renamed cd to cd and export the directory path we are entering
alias cd='cd_'

# accidental deletion
alias rm='rm -I'

# Optional alias
alias lx='ls -lXB'         #  Sort by extension.
alias lk='ls -lSr'         #  Sort by size, biggest last.
alias lt='ls -ltr'         #  Sort by date, most recent last.
alias lc='ls -ltcr'        #  Sort by/show change time,most recent last.
alias lu='ls -ltur'        #  Sort by/show access time,most recent last.

# Sort by size, biggest last, add the contents of each directory
alias ls_size='du -sch .[!.]* * | sort -h'

# Extract the latest downloaded zip file and cd into it
## Note that leading dot so that cd in the script takes effect in the shell that it calls from
alias dwz='. dwz'

# directory changing from the last opened path
# ldp to load the path from the file .last_dir which was created by the modified "cd" alias. See the function cd_ for details.
alias ldp='cd $(cat ~/.last_dir)'

# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Nice examples of functions
function swap()
{ # Swap 2 filenames around, if they exist (from Uzi's bashrc).
    local TMPFILE=tmp.$$

    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

# Makes your life easy
function extract()      # Handy Extract Program
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

#######################################################################
#           setting the editor for ranger to use clipboard            #
#######################################################################
VISUAL=nvim; export VISUAL EDITOR=nvim; export EDITOR
alias vim=nvim

#Creating a config file for linux calculator bc, which does not support a config file by default
# we will add scale=5 in this file to make it support decimal divisions
export BC_ENV_ARGS=~/.bcrc

# Use bash-completion, if available
# The package bash-completion is needed
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

#######################################################################
#                     Adding path for my scripts                      #
#######################################################################

export PATH=$PATH:~/.myscr/


# obligatory
export PATH="$PATH:$HOME/.local/bin"

# nvim
export PATH="$PATH:$HOME/Downloads/nvim-linux64/bin"
# nodejs
export PATH="$PATH:$HOME/Downloads/node-v16.13.0-linux-x64/bin"

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# force read inputrc
export INPUTRC=$HOME/.inputrc
