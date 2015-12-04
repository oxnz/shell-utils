#!/bin/sh
#
# Copyright (c) 2015 0xnz. All rights reserved.
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
# ---------------------------------------------------------------
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
# ===============================================================
#

set -e
set -u
set -o pipefail

##! @desc: identical to echo, but more portable
puts() {
	printf '%b\n' "$*"
}

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
					puts "multiple action specified"
					return 1
				fi
				act='recvfile'
				;;
			s)
				if [ -n "${act}" -a "${act}" != 'sendfile' ]; then
					puts "multiple action specified"
					return 1
				fi
				act='sendfile'
				;;
			h)
				puts "Usage: $0 <file> <host> <port>"
				return
				;;
			*)
				puts "$0: invalid arguments: $OPTARG" >&2
				return 1
				;;
		esac
	done
	shift $(( OPTIND - 1 ))
	if [ $# -ne 3 ]; then
		main -h >&2
		return 1
	fi

	local file="$1"
	local host="$2"
	local port="$3"
	case "$0" in
		sendfile*)
			puts "send '${file}' > ${host}:${port}"
			cat "${file}" > "/dev/tcp/${host}/${port}"
			;;
		recvfile*)
			puts "recv '${file}' < ${host}:${port}"
			cat < "/dev/tcp/${host}/${port}" > "${file}"
			;;
		*)
			puts "$0: action unspecified: -r(recvfile) or -s(sendfile)" >&2
			return 1
			;;
	esac
}

main "$@"
