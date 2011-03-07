# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

export PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '
export PATH=/usr/local/bin:$PATH

export HISTSIZE=5000
export HISTFILESIZE=5000
export HISTCONTROL=erasedups
export HISTTIMEFORMAT="%h/%d - %H:%M:%S "
shopt -s histappend

source /usr/local/bin/virtualenvwrapper.sh


export ALTERNATE_EDITOR="" EDITOR="emacsclient -c" VISUAL="emacsclient -c"

