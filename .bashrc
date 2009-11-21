export PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '

export PATH="/Library/Frameworks/Python.framework/Versions/2.6/bin:${PATH}"
export PATH=/usr/local/bin:/opt/subversion/bin:$PATH
export PATH=/Library/PostgreSQL/8.4/bin:$PATH

alias emacs='emacs -nw'

unset HISTSIZE
unset HISTFILESIZE 
export HISTCONTROL=erasedups
export HISTTIMEFORMAT="%h/%d - %H:%M:%S "
shopt -s histappend