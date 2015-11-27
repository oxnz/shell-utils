# Copyright (c) 2014 0xnz. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# you also need to put \[ and \] around any color codes so that bash does not
# take them into account when calculating line wraps. Also you can make use
# of the tput command to have this work in any terminal as long as the TERM
# is set correctly. For instance $(tput setaf 1) and $(tput sgr0)
# ref:
# http://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html

PS1='\[\e[01;34m\][\[\e[00m\]\[\e[00;36m\]\u\[\e[00;33m\]@\[\e[00;32m\]\h\[\e[01;32m\]:\[\e[00;36m\]\W\[\e[01;32m\]:\[\e[00;3$(($?==0?2:1))m\]$?\[\e[01;34m\]]\$\[\e[00m\] '

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# echo -en "\e]0;string\a" #-- Set icon name and window title to string
# echo -en "\e]1;string\a" #-- Set icon name to string
# echo -en "\e]2;string\a" #-- Set window title to string
# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h:\w\a\]$PS1"
		;;
	*)
		;;
esac

# prompt for bash
# There are several variables that can be set to control the appearance of the
# bach command prompt: PS1, PS2, PS3, PS4 and PROMPT_COMMAND the contents are
# executed just as if they had been typed on the command line.

# PS1 – Default interactive prompt (this is the variable most often customized)
# PS2 – Continuation interactive prompt (when a long command is broken up
#	    with \ at the end of the line) default=">"
# PS3 – Prompt used by “select” loop inside a shell script
# PS4 – Prompt used when a shell script is executed in debug mode
#       (“set -x” will turn this on) default ="++"
# PROMPT_COMMAND - If this variable is set and has a non-null value, then it
#		will be executed just before the PS1 variable.
# quote from tldp:
#	Bash provides an environment variable called PROMPT_COMMAND. The contents
#	of this variable are executed as a regular Bash command just before Bash
#	displays a prompt.

function prompt_command() {
    GIT_PS1_SHOWUPSTREAM='auto' \
    GIT_PS1_SHOWDIRTYSTATE='Y' \
    GIT_PS1_SHOWSTASHSTATE='Y' \
    GIT_PS1_SHOWCOLORHINTS='Y' \
    GIT_PS1_SHOWUNTRACKEDFILES='Y' \
	__git_ps1 "(%s)"
}

# this may cause bash prompt messed up
#PROMPT_COMMAND=prompt_command
