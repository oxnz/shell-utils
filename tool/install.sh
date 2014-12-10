#!/usr/bin/env sh
#
# ===============================================================
#
# Filename:	install.sh
#
# Author:		Oxnz
# Email:		yunxinyi@gmail.com
# Created:		[2014-12-09 19:11:50 CST]
# Last-update:	2014-12-09 19:11:50 CST
# Description: ANCHOR
#
# Version:		0.0.1
# Revision:	[None]
# Revision history:	[None]
# Date Author Remarks:	[None]
#
# License:
# Copyright (c) 2013 Oxnz
#
# Distributed under terms of the [LICENSE] license.
# [license]
#
# ===============================================================
#

set -e

PROGNAME='INSTALL'

msgdump() {
	echo "$*"
}

errdump() {
	if [ $# -ne 2 ]; then
		errdump "error" "errdump: 2 arguments expected, but $# found: '$@'"
		return 1
	fi
	local level="$1"
	local content="$2"
	msgdump "[${PROGNAME}] ${level}: ${content}" >&2
}

main() {
	local OPTIND=1
	local opt
	local verbose=0

    while getopts "d:hv" opt; do
		case $opt in
			d)
				local dest=$OPTARG
				if [ -d $dest ]; then
					errdump 'error' "directory already exists: [$dest]"
					return 1
				fi
				;;
			h)
				cat << EOH
Usage: $0 [options]"
  Options:
	  -d DIR	specify the installation directory
	  -h		show this message and exit
	  -v		specify verbose level
EOH
				return
				;;
			v)
				verbose=$((verbose+1))
				;;
		esac
	done
	shift $((OPTIND-1))

	if [ $# -ne 0 ]; then
		errdump 'error' "unexpected argument(s): $@"
		return 1
	fi

	install
}

main $@

# detect shell type:
#http://stackoverflow.com/questions/3327013/how-to-determine-the-current-shell-im-working-on#comment17728546_3327013
