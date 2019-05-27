# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific aliases and functions



# User specific optical stuff
# color prompt
case $HOSTNAME in
    st-190-082) HOSTCOLOR="1;32m" ;;
    st-190-011) HOSTCOLOR="01;33m" ;;
    *) HOSTCOLOR="01;32m" ;;
esac

PS1="\n\[\e[1;37m\]┌─[\[\e[1;34m\]\u\[\e[1;37m\]@\[\e[${HOSTCOLOR}\]\h \[\e[0;37m\]\w\[\e[1;37m\]]\n└──●\[\e[0;37m\] "
#DEFAULT : PS1="[\u@\h\W]$"

source "$HOME/.config/bash/bash_funcs"
source "$HOME/.config/bash/bash_aliases"
source "$HOME/.config/bash/bash_exports"


[ -f ~/.fzf.bash ] && source ~/.fzf.bash
