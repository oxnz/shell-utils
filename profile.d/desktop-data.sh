#
# Set the default mouse cursor theme for X11
# therefore find out if this is a local or remote
# display and set the cursor theme only for the
# local system
#
if test -r /etc/sysconfig/windowmanager; then
    location=${DISPLAY%:*}
    if test -z "$location" ; then
	# local connection
	case ":${DISPLAY#*:}" in
        :0|:0.0) location=local ;; # console
        *)       location=local ;; # other displays
	esac
    fi
    if test "$location" = local ; then
	. /etc/sysconfig/windowmanager
	XCURSOR_THEME="$X_MOUSE_CURSOR"
	export XCURSOR_THEME
    fi
    unset location
fi

export QT_SYSTEM_DIR=/usr/share/desktop-data
