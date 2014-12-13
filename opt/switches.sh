# Switches for shell control

# Enable 256 color capabilities for appropriate terminals
# ref: http://fedoraproject.org/wiki/Features/256_Color_Terminals#256_Color_Terminals
#
# Set this variable in your local shell config if you want remote
# xterms connecting to this system, to be sent 256 colors.
# This can be done in /etc/csh.cshrc, or in an earlier profile.d script.
#   SEND_256_COLORS_TO_REMOTE=1

# Terminals with any of the following set, support 256 colors (and are local)
if [ -n "$COLORTERM$XTERM_VERSION$ROXTERM_ID$KONSOLE_DBUS_SESSION" ]; then
    case $TERM in
        xterm) TERM=xterm-256color;;
        screen) TERM=screen-256color;;
        Eterm) TERM=Eterm-256color;;
    esac
    export TERM
    if [ -n "$TERMCAP" ] && [ "$TERM" = "screen-256color" ]; then
        TERMCAP=$(echo "$TERMCAP" | sed -e 's/Co#8/Co#256/g')
        export TERMCAP
    fi
fi

export CLICOLOR=1
export LC_ALL=en_US.UTF-8

HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:cd..:cd.."
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
#HISTFILE="$HOME/.sh_history"
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTFILESIZE=100000
HISTSIZE=10000
# for tcsh
SAVEHIST=$HISTSIZE

###var(s) for other commands {{{
# use all processors for fast, parallel make(1) builds
export MAKEFLAGS="-j $(fgrep -c processor /proc/cpuinfo)"
export EDITOR=vim
export PYTHONSTARTUP=~/.pythonrc
#}}}

# input method {{{
#export XMODIFIER$="@im=ibus"
#export QT_MODULE=ibus
#export GTK_MODULE=ibus
#}}}

# Local variables:
# mode: shell-script
# sh-basic-offset: 4
# sh-indent-comment: t
# indent-tabs-mode: nil
# End:
# vim: ts=4 sw=4 et filetype=sh
