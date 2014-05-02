# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f ~/.localrc ]; then
    source ~/.localrc
fi

#################################################
# Shell settings
#################################################

# Colors
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# Edit preferences
set -o vi
export EDITOR='emacs -nw'

# History
export HISTFILESIZE=5000
export HISTIGNORE="history*:  *"

# Ulimit (helpful for core dump)
ulimit -c unlimited

export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""

#################################################
# Aliases
#################################################

alias emacs='emacs -nw'
alias grep='grep --color -I'
alias hg='history | grep'
alias ll='ls -l'
alias please='sudo $(history -p !-1)'

#################################################
# Autocomplete
#################################################

source /usr/share/bash-completion/bash_completion

# fab
has_fab=true
type fab >/dev/null 2>&1 || has_fab=false
if $has_fab ; then
    source ~/util/fabric-completion.bash
fi

# ssh
complete -W "$(echo $(grep '^ssh ' ~/.bash_history | sort -u | sed 's/^ssh //'))" ssh


#################################################
# OS Specific
#################################################

if [[ `uname` == "Linux" ]]; then
    #################################################
    # Linux
    #################################################

    alias ls='ls --color=auto'
fi

#################################################
# Functions
#################################################

function targrep {

  local taropt=""

  if [[ ! -f "$2" ]]; then
    echo "Usage: targrep pattern file ..."
  fi

  while [[ -n "$2" ]]; do

    if [[ ! -f "$2" ]]; then
      echo "targrep: $2: No such file" >&2
    fi

    case "$2" in
      *.tar.gz) taropt="-z" ;;
      *) taropt="" ;;
    esac

    while read filename; do
      tar $taropt -xOf "$2" \
       | grep "$1" \
       | sed "s|^|$filename:|";
    done < <(tar $taropt -tf $2 | grep -v '/$')

  shift

  done
}

function up {
    usage='USAGE: up <number>'
    if [[ $# -ne 1 ]] ; then
        echo $usage && return 65
    fi

    num=$1
    upstr='.'
    iter=0
    until [ $iter -eq $num ] ; do
        upstr="${upstr}/.."
        let iter=iter+1
    done
    cd $upstr
}

### Added by the Heroku Toolbelt
export PATH="~/ssh-hosts:/usr/local/heroku/bin:$PATH"
