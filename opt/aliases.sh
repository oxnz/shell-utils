################################################################################
# Alias definitions.
#-------------------------------------------------------------------------------
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
#-------------------------------------------------------------------------------

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# make colorful grep {{{
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
#}}}

# platform compatible {{{
which xdg-open > /dev/null && alias open='xdg-open'
which pbcopy > /dev/null && alias pbcopy='xsel --clipboard --input'
which pbpaste > /dev/null && alias pbcopy='xsel --clipboard --output'
#}}}

# play safer {{{
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'
#}}}

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'
elif [ $(uname -s) = "Darwin" ]; then
    :
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
which notify-send > /dev/null && alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# some more ls aliases
# specify format {{{
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias df='df -h'
alias du='du -h'
alias gdb='gdb --quiet'
alias bc='bc --quiet'
#}}}

# typo {{{
alias cd..='cd ..'
alias unmount='echo "Error: Try the command: umount" >&2 && false'
#alias sl='ls'
#}}}

#short cuts {{{
alias e="${EDITOR:-vim}"
alias o='less'
alias h='history'
alias j='jobs -l'
alias -- +='pushd'
alias -- -='popd'
alias ..='cd ..'
alias ...='cd ../..'
alias x='extract'
alias g='google'
alias rd='rmdir'
alias md='mkdir -p'
alias beep='printf "\007"'
#}}}

# command wrapper {{{
alias svn='svn-color'
alias define='define -d ~/.shell/data/define'
#}}}

# override default vesion or default path command {{{
#alias emacs='emacs-24.3 -nw'
#alias emacs-nox='emacs-24.3 -nw'
#alias emacsclient='/usr/local/bin/emacsclient'
#alias bash='/usr/local/bin/bash'
#alias edit='emacs-24.3 -nw'
#alias make='/usr/local/bin/gnu-make'
#}}}

#new command {{{
alias now='/bin/date +"%F %T"'
alias goc='go build'
alias netstat6='netstat -A inet6'
#}}}

#command not in PATH var {{{
case "$OSTYPE" in
	darwin*)
		alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'
		alias py2applet='/System/Library/Frameworks/Python.framework/Versions/Current/Extras/bin/py2applet'
		;;
esac

# learn you a good emacs
#alias vi='echo "command not found"'
#alias vi='emacs-24.3 -nw'
#}}}

# Local variables:
# mode: shell-script
# sh-basic-offset: 4
# sh-indent-comment: t
# indent-tabs-mode: nil
# End:
# ex: ts=4 sw=4 et filetype=sh
