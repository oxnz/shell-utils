#!/bin/sh
#
# ===============================================================
#
# Filename:	killtop.sh
#
# Author:		Oxnz
# Email:		yunxinyi@gmail.com
# Created:		[2014-12-06 15:59:34 CST]
# Last-update:	2014-12-06 15:59:34 CST
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

function main() {
    local opt
    local OPTIND=1
    while getopts "h" opt; do
        case "$opt" in
            h)
                cat <<End-Of-Help
killtop -k [KEY] -v [VAL] -c [cmd]
End-Of-Help
                return
                ;;
            ?)
                tree -h >&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND-1))
    if [ $# -gt 1 ]; then
        echo "too many parameters" >&2
        return 1
	fi
}
