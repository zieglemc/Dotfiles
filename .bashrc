# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific aliases and functions


vv() {
    /usr/local/bin/vv "$@" 1>/dev/null 2>/dev/null
}

ddump() {
    dcmdump +C "$1" | less -r
}

show() {

    fname="$1"
    shift
    while [ "$1" ]; do   # combine all "inputs" if there are spaces within the path
        fname="$fname $1"
        shift
    done

    if [ ! -f "$fname" ]; then
        echo "$fname: This file does not exist!"
        return 1
    fi


    ext="${fname##*.}"
    fname=$(echo "$fname" | sed -e 's/^[ \t]*//') # remove leadin white space

    case "$ext" in
        pdf)  okular "$fname";;
        raw)  imagej "$fname";;
        jpg)  gpicview "$fname";;
        png)  gpicview "$fname";;
        gif)  eyesight "$fname";;
        svg)  inkscape "$fname";;
        nrrd) vv "$fname";;
        mha)  vv "$fname";;
        html) firefox "$fname";;
        dcm) ddump "$fname";;
        tiff) gpicview "$fname";;
        *) less "$fname";;

    esac
}

calc_func(){
    res=$(echo "$@" | sed 's/[eE]+*/\*10\^/g' | sed 's/ibas\*10\^/ibase/g' | bc -l)
    echo "${*} = $res"
    set +f
}

..(){
    DIRHIST+=("$PWD")
    up="../"
    num=${1:-1}
    for (( i=1; i<num; i++)); do
        up="$up../"
    done
    command cd "$up"
}

mycd_func(){
    DIRHIST+=("$PWD")
    if [[ $1 =~ ^-[0-9]+$ ]]; then
        histitem=$((${1/-/}+1))
        if [[ "$histitem" -lt "${#DIRHIST[@]}" ]]; then
            command cd "${DIRHIST[${#DIRHIST[@]}-$histitem]}"
        else
            echo "Not enugh directories in history!"
            unset 'DIRHIST[${#DIRHIST[@]}-1]'
        fi
    elif [[ $1 == .. ]]; then
        .. "$2"
    else
        command cd "$@"
    fi
}

extract() {
    if [ -f "$1" ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf "$1"    ;;
            *.tar.gz)    tar xvzf "$1"    ;;
            *.tar.xz)    tar xvJf "$1"    ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"       ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xvf "$1"     ;;
            *.tbz2)      tar xvjf "$1"    ;;
            *.tgz)       tar xvzf "$1"    ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7za x "$1"        ;;
            *)           echo "don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

pinnacle() {
    if [ -z ${1+x} ]; then
        login=zieglemc
    else
        login=$1
    fi

    ssh -X "${login}@141.67.133.149"
}

dirhist() {
    if [ -z "$1" ]; then
        min=${#DIRHIST[@]}
    else
        if [[ "${#DIRHIST[@]}" -gt "$1" ]]; then
            min=$1
        else
            min=${#DIRHIST[@]}
        fi
    fi

    for (( i=0; i<min;i++)) ; do
        echo -e "$((i+1)).\t${DIRHIST[${#DIRHIST[@]}-$i-1]}"
    done

}

wttr() {
    local request="wttr.in/${1:-Erlangen}"
    [ "$COLUMNS" -lt 125 ] && request+='?n'
    curl -H "Accept-Language: ${LANG%_*}" --compressed "$request"
}

alias ll='ls -lh --color=auto'
alias la='ls -lha --color=auto'
alias rm='rm -i'
alias em='emacs -nw'
alias ec='emacsclient -c'
alias xelatex='xelatex --shell-escape'
alias 12stein='ssh -X zieglemc@10.0.0.2'
alias 24stein='ssh -X zieglemc@10.0.0.1'
alias calc='set -f; calc_func'
alias reload='source ~/.bashrc'
alias nrrdinfo='unu head'
alias myconky='/usr/bin/conky -c /home/zieglemc/.conky/BlackPearlConky/conkyrc0 --daemon'
alias cd=mycd_func
alias less='less -r'



# User specific optical stuff
# color prompt
case $HOSTNAME in
    st-190-082) HOSTCOLOR="1;32m" ;;
    st-190-011) HOSTCOLOR="01;33m" ;;
    *) HOSTCOLOR="01;32m" ;;
esac

PS1="\n\[\e[1;37m\]┌─[\[\e[1;34m\]\u\[\e[1;37m\]@\[\e[${HOSTCOLOR}\]\h \[\e[0;37m\]\w\[\e[1;37m\]]\n└──●\[\e[0;37m\] "
#DEFAULT : PS1="[\u@\h\W]$"

export HISTSIZE=1000000
export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode
export LESS_TERMCAP_md=$(printf "\e[%s", $HOSTCOLOR) # enter double-bright mode
export LESS_TERMCAP_me=$(printf '\e[0m') # turn off all appearance modes (mb, md, so, us)
export LESS_TERMCAP_se=$(printf '\e[0m') # leave standout mode
export LESS_TERMCAP_so=$(printf '\e[01;37m') # enter standout mode
export LESS_TERMCAP_ue=$(printf '\e[0m') # leave underline mode
export LESS_TERMCAP_us=$(printf '\e[04;36m') # enter underline mode ? cyan
DIRHIST=("$PWD")

export SHELLCHECK_OPTS="-e SC2039 -e SC2034 -e SC1090"

# User specific environment and startup programs

PATH=$HOME/src/bin:$PATH

export PATH

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
