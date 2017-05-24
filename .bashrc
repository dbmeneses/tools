PROMPT_COMMAND=__prompt_command

__prompt_command() {
    local curr_exit="$?"

    local red='\e[91m'
    local res='\e[00m'
    local yel='\e[33m'
    local b_blue='\e[01;34m'
    local b_green='\e[01;32m'

    local branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/')

    PS1="\${debian_chroot:+(\$debian_chroot)}${b_green}\u@\h${res}:${b_blue}\w${yel}${branch}${res}\$ "

    if [ "$curr_exit" != 0 ]; then
        PS1="[${red}$curr_exit${res}]$PS1"
    fi
}
