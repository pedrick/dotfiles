# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

#################################################
# Shell settings
#################################################

# Colors
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# Edit preferences
set -o vi
export EDITOR=vi

# History
export HISTFILESIZE=5000

# Ulimit (helpful for core dump)
ulimit -c unlimited

#################################################
# Aliases
#################################################

alias ll='ls -l'

#################################################
# Autocomplete
#################################################

# git
source ~/util/git-completion.bash

# ssh
complete -W "$(echo $(grep '^ssh ' ~/.bash_history | sort -u | sed 's/^ssh //'))" ssh

# fab
has_fab=true
type fab >/dev/null 2>&1 || has_fab=false
if $has_fab ; then
    source ~/util/fabric-completion.bash
fi

#################################################
# OS Specific
#################################################

if [[ `uname` == "Linux" ]]; then
    #################################################
    # Linux
    #################################################

    alias ls='ls --color=auto'
fi
