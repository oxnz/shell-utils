case "$-" in
*i*)
    #
    # Colored file listings
    #
    if test -x /usr/bin/dircolors ; then
        #
        # set up the color-ls environment variables:
        #
        if test -f $HOME/.dir_colors ; then
	    eval "`/usr/bin/dircolors -b $HOME/.dir_colors`"
        elif test -f /etc/DIR_COLORS ; then
	    eval "`/usr/bin/dircolors -b /etc/DIR_COLORS`"
        fi
    fi
    
    #
    # ls color option depends on the terminal
    # If LS_COLORS is set but empty, the terminal has no colors.
    #
    if test "${LS_COLORS+empty}" = "${LS_COLORS:+empty}" ; then
        LS_OPTIONS=--color=tty
    else
        LS_OPTIONS=--color=none
    fi
    if test "$UID" = 0 ; then
        LS_OPTIONS="-A -N $LS_OPTIONS -T 0"
    else
        LS_OPTIONS="-N $LS_OPTIONS -T 0"
    fi
    
    #
    # Avoid trouble with Emacs shell mode
    #
    if test "$EMACS" = "t" ; then
        LS_OPTIONS='-N --color=none -T 0';
    fi
    export LS_OPTIONS
    
    #
    # useful ls aliases
    #
    if test "$is" != "ash" ; then
	unalias ls 2>/dev/null
    fi
    case "$is" in
	bash|dash|ash)
	    _ls ()
	    {
		local IFS=' '
		command ls $LS_OPTIONS ${1+"$@"}
	    }
	    alias ls=_ls
	    ;;
	zsh)
	    z_ls ()
	    {
		local IFS=' '
		command \ls $=LS_OPTIONS ${1+"$@"}
	    }
	    alias ls=z_ls
	    ;;
	ksh)
	    _ls ()
	    {
		typeset IFS=' '
		command ls $LS_OPTIONS ${1+"$@"}
	    }
	    alias ls=_ls
	    ;;
	*)  alias ls='/bin/ls $LS_OPTIONS' ;;
    esac
    alias dir='ls -l'
    alias ll='ls -l'
    alias la='ls -la'
    alias l='ls -alF'
    alias ls-l='ls -l'
    ;;
esac
