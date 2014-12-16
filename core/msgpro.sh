# this is the msg pro for shell-utils

VERBOSE=3
su::msgdump() {
	local OPTIND=1
	local opt
	while getopts "hv" opt; do
		case "$opt" in
			h)
				cat << EOF
Usage: ${FUNCNAME[0]} [option] level message
  options:
	-h	show this message and exit
	-v  verbose output
  level:
  	debug
	info
	warning
	error
EOF
return
				;;
			v)
				VERBOSE=$((VERBOSE+1))
				;;
		esac
	done
	shift $((OPTIND-1))
	if [ $# -lt 2 ]; then
		su::log 'error' "2 or more arguments expected, but $# found"
		return 1
	fi
	local level="$1"
	case "$level" in
		debug)
			if [ $VERBOSE -le 0 ]; then
				return
			fi
			;;
		info)
			if [ $VERBOSE -le 1 ]; then
				return
			fi
			;;
		warning)
			if [ $VERBOSE -le 2 ]; then
				return
			fi
			;;
		error)
			;;
	esac
	shift
	local msg="$*"
	echo "[${FUNCNAME[1]} ${level}] $msg"
}
