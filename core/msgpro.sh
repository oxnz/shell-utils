# this is the msg pro for shell-utils

__su__msgdump__verbose__=3

su::msgdump::level() {
	if [ $# -eq 0 ]; then
		su::msgdump::level "${__su__msgdump__verbose__}"
		return
	elif [ $# -eq 1 ]; then
		local opt="$1"
		case "$opt" in
			-h)
				printf "Usage: su::msgdump::level verbose"
				;;
			3)
				echo "debug"
				;;
			2)
				echo "info"
				;;
			1)
				echo "warning"
				;;
			0)
				echo "error"
				;;
			*)
				su::msgdump error \
					"su::msgdump::level: invalid option: $opt" 1>&2
				return 1
		esac
	else
		su::msgdump error "su::msgdump::level: too many arguments"
		return 1
	fi
}

su::msgdump::verbose() {
	local verbose="${__su__msgdump__verbose__}"
	if [ $# -eq 0 ]; then
		echo "${verbose}"
	elif [ $# -eq 1 ]; then
		local opt="$1"
		case "$opt" in
			-h)
				printf "Usage: su::msgdump::verbose [+|-v] (0..3)"
				return
				;;
			-v)
				verbose=$((verbose - 1 > 0 ? --verbose : verbose))
				;;
			+v)
				verbose=$((verbose + 1 > 3 ? verbose : ++verbose))
				;;
			0|1|2|3)
				verbose="$opt"
				;;
			*)
				su::msgdump error \
					"su::msgdump::verbose: invalid option: $opt" 1>&2
				return 1
				;;
		esac
		__su__msgdump__verbose__="$verbose"
	else
		su::msgdump error "su::msgdump::verbose: too many arguments"
		return 1
	fi
}

su::msgdump() {
	local OPTIND=1
	local opt
	local verbose=0
	local color=true
	while getopts "Chv" opt; do
		case "$opt" in
			C)
				color=false
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
			$((verbose+=3))
			;;
		info)
			$((verbose+=2))
			;;
		warning)
			$((verbose+=1))
			;;
		error)
			;;
		*)
			msg="su::msgdump unsupported level '${level}' for msg: ${msg}"
			su::msgdump 'error' "$msg"
			return 1
			;;
	esac
	if [ "$verbose" -gt "${__su__msgdump__verbose__}" ]; then
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

su::msgdump::debug() {
	shift
	su::msgdump debug "$@"
}

su::msgdump::info() {
	shift
	su::msgdump info "$@"
}

su::msgdump::warning() {
	shift
	su::msgdump warning "$@"
}

su::msgdump::error() {
	shift
	su::msgdump error "$@"
}
