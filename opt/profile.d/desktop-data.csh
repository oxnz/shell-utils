#
# Set the default mouse cursor theme for X11
# therefore find out if this is a local or remote
# display and set the cursor theme only for the
# local system
#
if ( -r /etc/sysconfig/windowmanager) then
    set location=""
    set line=""
    if ( ${?DISPLAY} ) then
	set location="`echo $DISPLAY | sed 's/:[^:]*//'`"
	set line="`echo $DISPLAY | sed 's/[^:]*:/:/'`"
    endif
    if ( ${%location} == 0 ) then
	# local connection
	switch ( $line )
        case \:0:
	   # console
	   set location=local
	   breaksw
	case \:0.0:
	   # console
	   set location=local
	   breaksw
        default:
	   # other displays
	   set location=local
	   breaksw
	endsw
    endif
    if ( "$location" == "local" ) then
	eval `sed -n -e 's/^\(X_MOUSE_CURSOR\) *=/set \1=/p' < /etc/sysconfig/windowmanager`
	setenv XCURSOR_THEME "$X_MOUSE_CURSOR"
	unset XCURSOR_THEME
    endif
    unset location
    unset line
endif

setenv QT_SYSTEM_DIR /usr/share/desktop-data
