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
#
# Filename:	log.sh
#
# Author:		Oxnz
# Email:		yunxinyi@gmail.com
# Created:		2015-11-24 23:23:11 CST
# Last-update:	2015-11-24 23:23:11 CST
# Description: ANCHOR
#
# Version:		0.0.1
# Revision:	[None]
# Revision history:	[None]
# Date Author Remarks:	[None]
#
# ==============================================================================

# log utilities for shell-utils

__su__log__level__=debug
__su__log__file__="${__SU__HOME__}/var/log/shell.log"
__su__log__lino__interval__="$((5*60))"
__su__log__lino__max__=10000

# log file is large enough, new log file needed
su::log::roll() {
	local file="${__su__log__file__}-$(date '+%s').tar.gz"
	while [ -e "$file" ]; do
		sleep "0.$((RANDOM%10))"
		file="${__su__log__file__}-$(date '+%s').tar.gz"
	done
	local dname="$(dirname "${__su__log__file__}")"
	local fname="$(basename "${__su__log__file__}")"
	if tar czf "$file" -C "$dname" "$fname"; then
		if :>"${__su__log__file__}"; then
			su::log::info "log file roll to $file"
		else
			su::msgdump::error "failed to truncate log file: ${__su__log__file}"
		fi
	else
		su::msgdump::error "${FUNCNAME[0]}: failed to create archive: $file"
	fi
}

##! @property{log.file}
su::log::file() {
	local file="${__su__log__file__}"
	if [ $# -eq 0 ]; then
		echo "$file"
	elif [ $# -eq 1 ]; then
		file="$1"
		if [ -f "$file" -a -w "$file" ]; then
			__su__log__file__="$file"
		else
			su::msgdump::error "${FUNCNAME[0]}: invalid file: $file"
			return 1
		fi
	else
		su::msgdump::error "${FUNCNAME[0]}: too many arguments" 1>&2
		return 1
	fi
}

##! @property{log.level}
su::log::level() {
	local level="${__su__log__level__}"
	if [ $# -eq 0 ]; then
		echo "$level"
	elif [ $# -eq 1 ]; then
		local opt="$1"
		case "$opt" in
			-h)
				echo "Usage: ${FUNCNAME[0]} [debug|info|warning|error]"
				;;
			debug|info|warning|error)
				level="$opt"
				__su__log__level__="$level"
				;;
			*)
				su::log error \
					"${FUNCNAME[0]}: invalid option: $opt" 1>&2
				return 1
				;;
		esac
	else
		su::log::error "${FUNCNAME[0]}: too many arguments"
		return 1
	fi
}

##! @property{log.verbose}
su::log::verbose() {
	if [ $# -eq 0 ]; then
		su::log::verbose "${__su__log__level__}"
	elif [ $# -eq 1 ]; then
		local opt="$1"
		case "$opt" in
			-h)
				echo "Usage: ${FUNCNAME[0]} level"
				;;
			error|warning|info|debug)
				local level
				local verbose=0
				for level in error warning info debug; do
					if [ "$opt" = "$level" ]; then
						echo "$verbose"
						return
					fi
					verbose="$((verbose+1))"
				done
				;;
			*)
				su::msgdump::error "${FUNCNAME[0]}: invalid option: '$opt'"
				return 1
				;;
		esac
	else
		su::msgdump::error "${FUNCNAME[0]}: too many arguments"
		return 1
	fi
}

##! @api{log}
##! @desc{log function}
su::log() {
	if [ $# -ne 2 ]; then
		echo "Usage: su::log level msg" >&2
		return 1
	fi
	local level="$1"
	local msg="$2"
	local func="${FUNCNAME[1]}"

	# return if verbose level is not enough
	if [ "$(su::log::verbose "$level")" -gt "$(su::log::verbose)" ]; then
		return
	fi

	case "$func" in
		su::log::error|su::log::warning|su::log::info|su::log::debug)
			func="${FUNCNAME[2]}"
			;;
	esac

	case "$level" in
		debug|info|warning|error)
			if [ -n "$func" ]; then
				msg="[${level}][$(date '+%F %T %Z') $(pwd) ${func}] ${msg}"
			else
				msg="[${level}][$(date '+%F %T %Z') $(pwd)] ${msg}"
			fi
			echo "$msg" >> "${__su__log__file__}"
			local ts="$(date '+%s')"
			ts="$((ts%__su__log__lino__interval__))"
			local lino="$(wc -l "${__su__log__file__}" | awk '{print $1}')"
			if [ "$lino" -gt "${__su__log__lino__max__}" -a "$ts" -eq 0 ]; then
				if ! su::log::roll; then
					su::msgdump::error \
						"failed to roll when log file lino reached max"
				fi
			fi
			;;
		*)
			su::log::error "invalid level: '$level' for msg: '$msg'"
			return 1
			;;
	esac
}

##! @api{log.error}
su::log::error() {
	su::log 'error' "$*"
}

##! @api{log.warning}
su::log::warning() {
	su::log 'warning' "$*"
}

##! @api{log.info}
su::log::info() {
	su::log 'info' "$*"
}

##! @api{log.debug}
su::log::debug() {
	su::log 'debug' "$*"
}
