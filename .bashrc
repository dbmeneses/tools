PROMPT_COMMAND=__prompt_command

__prompt_command() {
    local curr_exit="$?"

    local red='\[\033[91m\]'
    local res='\[\033[00m\]'
    local yel='\[\033[33m\]'
    local b_blue='\[\033[01;34m\]'
    local b_green='\[\033[01;32m\]'

    local branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/')

    inside="\${debian_chroot:+(\$debian_chroot)}${b_green}\u@\h${res}:${b_blue}\w${yel}${branch}${res}\$ "

    if [ "$curr_exit" != 0 ]; then
        PS1="[${red}$curr_exit${res}]$inside"
    else
        PS1="$inside"
    fi
}
