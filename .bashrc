# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

source .commonrc

#################################################
# Shell settings
#################################################

# Colors
export CLICOLOR=1

export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""

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

complete -C /usr/bin/terraform terraform
