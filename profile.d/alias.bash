# /etc/profile.d/alias.ash for SuSE Linux
#
# The ash shell does not have an alias builtin in
# therefore we use functions here. This is a seperate
# file because other shells may run into trouble
# if they parse this even if they do not expand.
#
suspend () { local -; set +j; kill -TSTP 0; }
#
# A bug? the builtin bltin is missed and mapped
# to the builtin command.
#
bltin () { command ${1+"$@"}; }
pushd () {
    local SAVE=`pwd`
    if test -z "$1" ; then
	if test -z "$DSTACK" ; then
	    echo "pushd: directory stack empty." 1>&2
	    return 1
	fi
	set $DSTACK
	cd $1 || return
	shift 1
	DSTACK="$@"
    else
	cd $1 > /dev/null || return
    fi
    DSTACK="$SAVE $DSTACK"
    dirs
}
popd () {
    if test -z "$DSTACK"; then
	echo "popd: directory stack empty." 1>&2
	return 1
    fi
    set $DSTACK
    cd $1
    shift 1
    DSTACK="$@"
    dirs
}
dirs () { echo "`pwd` $DSTACK"; return 0; }
