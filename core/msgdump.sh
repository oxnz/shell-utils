#!/bin/sh
#
# Copyright (c) 2015-2016 0xnz. All rights reserved.
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
#
# this is the msg pro for shell-utils

# TODO: fix color and other stuff cause su::msgdump::error will put error in first and stop arg parse

##! @desc: print msg with trailing newline
su::puts() {
	printf '%b\n' "$*"
}

# msgdump should not have any dependencies
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
	-v  verbose output will contains more context info
  level:
  	debug info warning error
EOF
return
				;;
			v)
				((++verbose))
				;;
		esac
	done
	shift $((OPTIND-1))
	if [ $# -lt 2 ]; then
		su::msgdump::error "2 or more arguments expected, but $# found"
		return 1
	fi
	local level="$1"
	shift
	local msg="$*"
	local color_code='31;1'
	local out=1
	case "$level" in
		debug)
			verbose=$((verbose+3))
			color_code='34'
			;;
		info)
			verbose=$((verbose+2))
			color_code='32'
			;;
		warning)
			verbose=$((verbose+1))
			color_code='33'
			out=2
			;;
		error)
			out=2
			;;
		*)
			msg="${FUNCNAME[0]}: unsupported level '${level}' for msg: ${msg}"
			su::msgdump::error "$msg"
			return 1
			;;
	esac
	local func="${FUNCNAME[1]}"
	case "$func" in
		su::msgdump::debug|su::msgdump::info|\
			su::msgdump::warning|su::msgdump|:error)
			func="${FUNCNAME[2]}"
			;;
	esac
	if [ -n "$func" ]; then
		msg="[${func} ${level}] $msg"
	else
		msg="[${level}] $msg"
	fi
	if [ -t "$out" -a "$color" = "true" ]; then
		msg="\e[${color_code}m${msg}\e[0m"
	fi
	if [ "$verbose" -gt 0 ]; then
		msg="[$(date '+%F %T %Z')] $msg"
	fi
	su::puts "${msg}" >&"${out}"
}

su::msgdump::debug() {
	su::msgdump debug "$@"
}

su::msgdump::info() {
	su::msgdump info "$@"
}

su::msgdump::warning() {
	su::msgdump warning "$@"
}

su::msgdump::error() {
	su::msgdump error "$@"
}
