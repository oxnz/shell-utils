#
# lang.sh:	Set interactive language environment
#
# Used configuration files:
#
#     /etc/sysconfig/language
#     $HOME/.i18n
#

#
# Already done by the remote SSH side
#
test -z "$SSH_SENDS_LOCALE" || return

#
# Already done by the GDM
#
test -z "$GDM_LANG" || return

#
# Get the system and after that the users configuration
#
if test -s /etc/sysconfig/language ; then
    while read line ; do
	case "$line" in
	\#*|"")
	    continue
	    ;;
	RC_*)
	    eval ${line#RC_}
	    ;;
	ROOT_USES_LANG*)
	    eval $line
	    test "$UID" != 0 && ROOT_USES_LANG=yes
	    ;;
	esac
    done < /etc/sysconfig/language
fi
test -s $HOME/.i18n && . $HOME/.i18n

#
# Handle all LC and the LANG variable
#
for lc in LANG LC_CTYPE LC_NUMERIC LC_TIME	\
	  LC_COLLATE LC_MONETARY LC_MESSAGES	\
	  LC_PAPER LC_NAME LC_ADDRESS 		\
	  LC_TELEPHONE LC_MEASUREMENT		\
	  LC_IDENTIFICATION LC_ALL
do
    eval val="\$$lc"
    if  test "$ROOT_USES_LANG" = "yes"    ; then
	if test -z "$val" ; then
	    eval unset $lc
	else
	    eval $lc=\$val
	    eval export $lc
	fi
    elif test "$ROOT_USES_LANG" = "ctype" ; then
	test "$lc" = "LANG" && continue
	if test "$lc" = "LC_CTYPE" ; then
	    LC_CTYPE=$LANG
	    LANG=POSIX
	    export LANG LC_CTYPE
	else
	    eval unset $lc
	fi
    else
	if test "$lc" = "LANG" ; then
	    LANG=POSIX
	    export LANG
	else
	    eval unset $lc
	fi
    fi
done

#
# Special LC_ALL handling because the LC_ALL
# overwrites all LC but not the LANG variable
#
if test -n "$LC_ALL" -a "$LC_ALL" != "$LANG" ; then
    export LC_ALL
else
    unset LC_ALL
fi

unset line ROOT_USES_LANG lc val
#
# end of lang.sh
