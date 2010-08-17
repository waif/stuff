# Delete bash_history

if [ -f ~/.bash_history ]; then
    rm ~/.bash_history
fi

# Bash completion - pretty important!@#

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

set show-all-if-ambiguous on

# {{{ Kill an orphaned console
sk(){
    skill -KILL -t $1
}

# {{{ Prompt
setprompt(){
    # Capture last return code
    local rts=$?

    # Get path with tilde for home
    if [[ "
$PWD" == "$HOME" ]]; then
        local dir="~"
    elif [[ "${PWD:0:${#HOME}}" == "$HOME" ]]; then
        local dir="~${PWD:${#HOME}}"
    else
        local dir=$PWD
    fi

    # Truncate path if it's long
    if [[ ${#dir} -gt 19 ]]; then
        local offset=$((${#dir}-18))
        dir="+${dir:$offset:18}"
    fi

    # Path color indicates host
    case "$HOSTNAME" in
        "mizuyu") local dircol="\[\e[1;35m\]"; ;; # Desktop
        "ubuntu") local dircol="\[\e[1;32m\]"; ;; # Laptop
        "izaya") local dircol="\[\e[1;31m\]"; ;; # Server
        *) local dircol="\[\e[1;37m\]"; ;; # Other
    esac

    # Marker char indicates root or user
    [[ $UID -eq 0 ]] && local marker='#' || local marker='$'

    # Marker color indicates successful execution
    [[ $rts -eq 0 ]] && local colormarker="\[\e[1;37m\]$marker" \
                     || local colormarker="\[\e[1;31m\]$marker"

    # Set PS1
    PS1="${dircol}${dir} ${colormarker}\[\e[0;37m\] "

    # Append history to saved file
    history -a
}

PROMPT_COMMAND="setprompt &> /dev/null"
# }}}
# {{{ Bash settings
# Applications

export EDITOR='emacsclient -t'
export BROWSER='conkeror {0}'

# History control

export HISTCONTROL="ignoreboth"
export HISTFILESIZE=500000
export HISTIGNORE="cd:..*:no:na:clear:reset:j *:exit:hc:h:-"

# Check for current bash version
if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
    shopt -s autocd cdspell
    shopt -s dirspell globstar
fi

# General options
shopt -s cmdhist nocaseglob
shopt -s histappend extglob

# Complete only directories on cd
complete -d cd

# Don't echo ^C
stty -ctlecho

# Load autojump
if [[ -f /etc/profile.d/autojump.bash ]]; then
    . /etc/profile.d/autojump.bash
fi

# Give ls more colors
if [[ -x /bin/dircolors ]]; then
    eval $(/bin/dircolors ~/.dircolors)
fi
# }}}
# {{{ Key bindings and macros
case "$-" in *i*)
    # Remove annoying fc map
    bind -m vi -r v

    # Walk through completions with ^N
    bind "\C-n: menu-complete"

    # Clear screen with ^L
    bind "\C-l: clear-screen"

    # Add pager pipe with ^T

    # Background & ignore with <C-b>
    bind '"\C-b":" &> /dev/null &\C-m"'

    # Search
    bind '"\C-w":" | ack "'

    # Reset and clear
    bind '"\C-a":"reset ; clear \C-m"'
    bind '"\C-k":"cd ; clear \C-m"'
    bind '"\C-e":"clear \C-m"'
;; esac;
# }}}

# {{{ General shortcuts
# Ls


alias g='gcc -ansi -pedantic -Wall -W -Wshadow -Wcast-qual -Wwrite-strings -Wextra -Werror -fstrength-reduce -fomit-frame-pointer -finline-functions '
alias ls='ls --color=auto -Fh --group-directories-first'
alias ll='ls -lah'
alias no='ls'
alias na='ll'
alias g='gcc -Wall -Wextra -pedantic'

# Devtodo

alias t='todo'
alias td='todo --database ~/.todo.daily'
alias ts='todo --database ~/.todo.schedule'

# Editor

alias e='emacs -nw'
alias ee='sudo emacs -nw'
alias v='vim'
alias vv='sudo vim'

# Tmux

tm() { tmux attach -t $1; }
tmn() { tmux new -n $1 $1; }

# Misc
## mount encrypted filesystems
alias m='encMount'
## start xorg

x(){ builtin cd ~; exec xinit $@; }

## sync music to iriver
syncm() { 
  sudo rsync -vhru --progress /data/music/Anime/ /mnt/iriver/Music/Anime/; 
}

# }}}
# {{{ Git shortcuts

alias a='git add'
alias d='git diff'
alias p='git push origin master'
alias pu='git pull origin master'
alias gpo='git push origin'
alias gpom='git push origin master'
alias gpuo='git pull origin'
alias gp='git push'
alias gpu='git pull'

# Commit everything or specified path
c() {
    if [[ "$1" == "-i" ]]; then
        shift; git commit -s --interactive $@
    else
        if [[ -n "$@" ]]; then
            git commit -s $@
        else
            git commit -s -a
        fi;
    fi;
}

# Git show relevant status
sa() {
    git status | ack -B 999 --no-color "Untracked"
}
# }}}

# {{{ Directory navigation
# General

alias h='builtin cd'
hc() { builtin cd; clear; }
mcd() { mkdir -p "$1" && eval cd "$1"; }

# Directory up
..() { cd "../$@"; }
..2() { cd "../../$@"; }
..3() { cd "../../../$@"; }
..4() { cd "../../../../$@"; }
..5() { cd "../../../../../$@"; }

# Auto-Ls after CD
cd() { if [[ -n "$1" ]]; then builtin cd "$1" && ls;
                         else builtin cd && ls; fi; }
,cd() { [[ -n "$1" ]] && builtin cd "$1" || builtin cd; }
ca() { ,cd "$1"; ls -la; }
cn() { ,cd "$1"; ls -a; }

# Directory stack
di() { dirs -v; }
po() { if [[ -n "$1" ]]; then popd "$1" 1>/dev/null && ls;
                         else popd 1>/dev/null && ls; fi; }
ph() { pushd "$1" 1>/dev/null && ls; }

alias chat='ssh -2 devio.us'
alias wb='torify ssh -2 writesruby.com -p 2322'
alias p+='ph +1'
alias p2='ph +2'
alias p3='ph +3'
alias p4='ph +4'
alias -- p-='ph -0'
alias -- p-1='ph -1'
alias -- p-2='ph -2'
alias -- p-3='ph -3'
alias -- p-4='ph -4'
alias -- -='cd -'
# }}}

alias grep="grep -i --color=always"
alias ack="ack -i"

# Unpack programs
if [[ -x '/usr/bin/aunpack' ]]; then
    alias un='aunpack'
else
    alias un='tar xvf'
fi
# }}}

# {{{ Daemons
rc.d() { [[ -d /etc/rc.d ]] && sudo /etc/rc.d/$@;
         [[ -d /etc/init.d ]] && sudo /etc/init.d/$@; }
dr() { for d in $@; do rc.d $d restart; done; }
ds() { for d in $@; do rc.d $d start; done; }
dt() { for d in $@; do rc.d $d stop; done; }
# }}}

# Make a git package, then show the log
gi() {
    gitdir=$1; shift
    from=$(git --git-dir=src/$gitdir/.git rev-parse HEAD)
    makepkg -fi $@
    git --git-dir=src/$gitdir/.git log --stat $from..HEAD
}

## Map function for bash.
map() {
    local command i rep
    if [ $# -lt 2 ] || [[ ! "$@" =~ :[[:space:]] ]];then
        echo "Invalid syntax." >&2; return 1
    fi
    until [[ $1 =~ : ]]; do
        command="$command $1"; shift
    done
    command="$command ${1%:}"; shift
    for i in "$@"; do
        if [[ $command =~ \{\} ]]; then
            rep="${command//\{\}/\"$i\"}"
            eval "${rep//\\/\\\\}"
        else
            eval "${command//\\/\\\\} \"${i//\\/\\\\}\""
        fi
    done
}

## wrapper for tvtime
tvtime() {
    sudo modprobe -a saa7134_alsa saa7134
    while [[ ! -e /dev/video0 ]]; do sleep 0.5; done;
    sudo /usr/bin/tvtime
    cp ~/.tvtime/tvtime.xml.orig ~/.tvtime/tvtime.xml
    sudo modprobe -r saa7134_alsa
}
# }}}

extract () {
  until [[ -z "$1" ]]; do
    echo Extracting $1 ...
    if [[ -f "$1" ]] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1  ;;
        *.tar.gz)    tar xzf $1  ;;
        *.tar.lzma)  tar --lzma xf $1 ;;
        *.bz2)       bunzip2 $1  ;;
        *.rar)       rar x $1    ;;
        *.gz)        gunzip $1   ;;
        *.tar)       tar xf $1   ;;
        *.tbz2)      tar xjf $1  ;;
        *.tgz)       tar xzf $1  ;;
        *.zip)       unzip $1   ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1  ;;
        *)        echo "Don't know how to extract '$1'" ;;
      esac
    else
      echo "'$1' is not a valid file"
    fi
    shift
  done
} 

archive () {
  FILE=$1
  case $FILE in
    *.tar.bz2) shift && tar cjf $FILE $* ;;
    *.tar.gz) shift && tar czf $FILE $* ;;
    *.tar.lzma) shift && tar --lzma cf $FILE $* ;;
    *.tgz) shift && tar czf $FILE $* ;;
    *.zip) shift && zip $FILE $* ;;
    *.rar) shift && rar $FILE $* ;;
  esac
}

# recursively 'fix' dir/file perm
fix() {
  for dir in "$@"; do
    find "$dir" -type d -exec chmod 755 {} \;
    find "$dir" -type f -exec chmod 644 {} \;
  done
}

# go to google for a definition
define() {
  which lynx &>/dev/null || return 1

  local lang=$(echo $LANG | cut -d '_' -f 1)
  local charset=$(echo $LANG | cut -d '.' -f 2)

  lynx -accept_all_cookies -dump -hiddenlinks=ignore -nonumbers -assume_charset="$charset" -display_charset="$charset" "http://www.google.com/search?hl=$lang&q=define%3A+$1&btnG=Google+Search" | grep -m 5 -C 2 -A 5 -w "*" > /tmp/define

  if [ ! -s /tmp/define ]; then
    echo -e "No definition found.\n"
  else
    echo -e "$(grep -v Search /tmp/define | sed "s/$1/\\\e[1;32m&\\\e[0m/g")\n"
  fi

  rm -f /tmp/define
}

# simple spellchecker, uses /usr/share/dict/words
spellcheck() {
  [ -f /usr/share/dict/words ] || return 1

  for word in "$@"; do
    if grep -Fqx "$word" /usr/share/dict/words; then
      echo -e "\e[1;32m$word\e[0m" # green
    else
      echo -e "\e[1;31m$word\e[0m" # red
    fi
  done
}

# omp load
ompload() { 
  curl -# -F file1=@"$1" http://omploader.org/upload|awk '/Info:|File:|Thumbnail:|BBCode:/ {
    gsub(/<[^<]*?\/?>/,"");
    $1 = $1;
    print
  }';
}

# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
export GPGKEY=D4F2CDCC
function env() {
  exec /usr/bin/env "$@" | grep -v ^LESS_TERMCAP_
}
    
export GTAGSLABEL=rtags
RUBYOPT="rubygems"
export RUBYOPT

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" 
