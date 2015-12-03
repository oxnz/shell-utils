#!/usr/bin/env sh
#
# ===============================================================
#
# Filename:	sendfile.sh
#
# Author:		Oxnz
# Email:		yunxinyi@gmail.com
# Created:		2015-12-03 14:23:10 CST
# Last-update:	2015-12-03 14:23:10 CST
# Description: ANCHOR
#
# Version:		0.0.1
# Revision:	[None]
# Revision history:	[None]
# Date Author Remarks:	[None]
#
# License:
# Copyright (c) 2015 Oxnz
#
# Distributed under terms of the [LICENSE] license.
# [license]
#
# ===============================================================
#

set -e
set -u
set -o pipefail

##! @desc: send or recv file over socket
##! @param.1: file
##! @param.2: host
##! @parapm.3: port
main() {
	local OPTIND=1
	local opt
	local act
	while getopts "hrs" opt; do
		case "$opt" in
			r)
				if [ -n "${act}" -a "${act}" != 'recvfile' ]; then
					echo "multiple action specified"
					return 1
				fi
				act='recvfile'
				;;
			s)
				if [ -n "${act}" -a "${act}" != 'sendfile' ]; then
					echo "multiple action specified"
					return 1
				fi
				act='sendfile'
				;;
			h)
				echo "Usage: $0 <file> <host> <port>"
				return
				;;
			*)
				echo "$0: invalid arguments: $OPTARG" >&2
				return 1
				;;
		esac
	done
	shift $((OPTIND-1))
	if [ $# -ne 3 ]; then
		main -h >&2
		return 1
	fi

	local file="$1"
	local host="$2"
	local port="$3"
	case "$0" in
		sendfile*)
			echo "send '${file}' > ${host}:${port}"
			cat "${file}" > "/dev/tcp/${host}/${port}"
			;;
		recvfile*)
			echo "recv '${file}' < ${host}:${port}"
			cat < "/dev/tcp/${host}/${port}" > "${file}"
			;;
		*)
			echo "$0: action unspecified: -r(recvfile) or -s(sendfile)" >&2
			return 1
			;;
	esac
}

main "$@"
