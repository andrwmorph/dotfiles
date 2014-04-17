#
# ~/.bashrc
#
# Most of this was stolen from other people

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PATH=$PATH:$HOME/bin

set_colors () {
	
	# Normal Colors
	Black="\033[0;30m"        # Black
	Red="\033[0;31m"          # Red
	Green="\033[0;32m"        # Green
	Yellow="\033[0;33m"       # Yellow
	Blue="\033[0;34m"         # Blue
	Purple="\033[0;35m"       # Purple
	Cyan="\033[0;36m"         # Cyan
	White="\033[0;37m"        # White
	
	# Bold
	BBlack="\033[1;30m"       # Black
	BRed="\033[1;31m"         # Red
	BGreen="\033[1;32m"       # Green
	BYellow="\033[1;33m"      # Yellow
	BBlue="\033[1;34m"        # Blue
	BPurple="\033[1;35m"      # Purple
	BCyan="\033[1;36m"        # Cyan
	BWhite="\033[1;37m"       # White
	
	# Background
	On_Black="\033[40m"       # Black
	On_Red="\033[41m"         # Red
	On_Green="\033[42m"       # Green
	On_Yellow="\033[43m"      # Yellow
	On_Blue="\033[44m"        # Blue
	On_Purple="\033[45m"      # Purple
	On_Cyan="\033[46m"        # Cyan
	On_White="\033[47m"       # White
	
	NC="\033[m"               # Color Reset
}

set_colors

case "$TERM" in
	xterm) color_prompt=yes;;
	rxvt*) color_prompt=yes;;
esac

LINE=""
line_on () {
	LINE="\[\e[31;1m\]\$(s=\$(printf "%*s" \$COLUMNS); echo \${s// /―})\n\[\e[0m\]"
}

#Overly complicated PS1
set_ps1 () {
	if [ "$color_prompt" = yes ]; then
		local O="\["
		local C="\]"
		local PS1EXIT=""
		[[ $? != 0 ]] && local PS1EXIT="${O}${BRed}${C}($?)${O}${NC}${C}";
		local JOBPS1=""
		if [ `jobs | wc -l` -ne 0 ]; then
			local JOBPS1="${O}${BPurple}${C}[\j]${O}${NC}${C}―";
		fi
		local COMMAND_NUM="${O}${Green}${C}(\!)${O}${NC}${C}";
		local PS1USER="${O}${Blue}${C}\u${O}${NC}${C}";
		local PS1HOST="${O}${Cyan}${C}\h${O}${NC}${C}";
		local PS1PATH="${O}${Red}${C}[\w]${O}${NC}${C}";
		local PS1DATE="${O}${Purple}${C}\t${O}${NC}${C}";
		PS1="${O}${Blue}${C}$(echo $'\u250C\u252C')";
		PS1="${PS1}${COMMAND_NUM}―${JOBPS1}[${PS1USER}@${PS1HOST}]―[${PS1DATE}]―${PS1PATH}";
		PS1="${PS1}\n${O}${Blue}${C}$(echo $'\u2514\u2534')${O}${NC}${C}";
		PS1="${PS1}${PS1EXIT}\$ ";
		PS1="${LINE}${PS1}";
	else
		PS1="[\u@\h][\w]\n\$ "
	fi
}

PROMPT_COMMAND=set_ps1

#Terminal options
shopt -s checkwinsize
shopt -s histappend

#Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

#Aliases
alias ls='ls --color=auto'						#Standard ls with color
alias lt='ls -ltr'								#Sort by date
alias ll='ls -lv --group-directories-first'		#ll
alias lr='ll -R'								#Recursive ls
alias tree='tree -Csuh'							#Tree view
alias grep='grep --color=auto'
alias dmesg='dmesg --color'

alias ..='cd ..'								#Go up one directory
alias path='echo -e ${PATH//:/\\n}'

alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

alias alert='twmnc -t "$([ $? = 0 ] && echo terminal || echo error)" -c "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias tcplistening='lsof -sTCP:LISTEN -iTCP'

#Alias File
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# Swap 2 filenames around, if they exist (from Uzi's bashrc).
function swap()
{ 
    local TMPFILE=tmp.$$

	[ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
	[ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
	[ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

	mv "$1" $TMPFILE
	mv "$2" "$1"
	mv $TMPFILE "$2"
}

function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }
function pp() { my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }


function mydf()         # Pretty-print of 'df' output.
{                       # Inspired by 'dfc' utility.
    for fs ; do
        if [ ! -d $fs ]
        then
          echo -e $fs" :No such file or directory" ; continue
        fi

        local info=( $(command df -P $fs | awk 'END{ print $2,$3,$5 }') )
        local free=( $(command df -Pkh $fs | awk 'END{ print $4 }') )
        local nbstars=$(( 20 * ${info[1]} / ${info[0]} ))
        local out="["
        for ((j=0;j<20;j++)); do
            if [ ${j} -lt ${nbstars} ]; then
               out=$out"*"
            else
               out=$out"-"
            fi
        done
        out=${info[2]}" "$out"] ("$free" free on "$fs")"
        echo -e $out
    done
}

function ii()   # Get current host related info.
{
    echo -e "\nYou are logged on ${BRed}`hostname`"
    echo -e "\n${BRed}Additionnal information:$NC " ; uname -a
    echo -e "\n${BRed}Users logged on:$NC " ; w -hs |
             cut -d " " -f1 | sort | uniq
    echo -e "\n${BRed}Current date :$NC " ; date
    local UPTIME=`uptime` #Formatting fix
	echo -e "\n${BRed}Machine stats :$NC\n${UPTIME:1}"
    echo -e "\n${BRed}Memory stats :$NC " ; free -m
    echo -e "\n${BRed}Diskspace :$NC " ; mydf / $HOME
    echo -e "\n${BRed}Local IP Address :$NC" ; my_ip
    echo -e "\n${BRed}Open connections :$NC "; netstat -pan --inet;
    echo
}

function _exit()              # Function to run upon exit of shell.
{
    echo -e "${BRed}Hasta la vista, baby${NC}"
}
trap _exit EXIT

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

function ask()          # y/n prompt
{
    echo -n "$@" '[y/n] ' ; read ans
    case "$ans" in
        y*|Y*) return 0 ;;
        *) return 1 ;;
    esac
}

function my_ip() # Get IP adress on ethernet.
{
    MY_IP=$(ip addr show dev net0 | awk '/inet/ { print $2 } ' |
      sed -e s/addr://)
    echo ${MY_IP:-"Not connected"}
}

function public_ip()
{
	PUBLIC_IP=$(curl -s icanhazip.com)
	echo ${PUBLIC_IP:-"Not found"}
}
