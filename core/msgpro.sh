# this is the msg pro for shell-utils

VERBOSE=3
su::msgdump() {
	local OPTIND=1
	local opt
	local verbose=0
	while getopts "Chv" opt; do
		case "$opt" in
			C)
				local color=false
				;;
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
				$((++verbose))
				;;
		esac
	done
	shift $((OPTIND-1))
	if [ $# -lt 2 ]; then
		su::msgdump 'error' "2 or more arguments expected, but $# found"
		return 1
	fi
	local level="$1"
	shift
	local msg="$*"
	case "$level" in
		debug)
			verbose=3
			;;
		info)
			verbose=2
			;;
		warning)
			verbose=1
			;;
		error)
			verbose=0
			;;
		*)
			msg="su::msgdump unsupported level '${level}' for msg: ${msg}"
			su::msgdump 'error' "$msg"
			return 1
			;;
	esac
	if [ "$verbose" -gt "$VERBOSE" ]; then
	   	return
	fi
	local func="${FUNCNAME[1]}"
	if [ -n "$func" ]; then
		msg="[${func} ${level}] $msg"
	else
		msg="[${level}] $msg"
	fi
	printf "%b\n" "$msg"
}
