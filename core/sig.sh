#!/usr/bin/env sh
#
# ===============================================================
#
# Filename:	sig.sh
#
# Author:		Oxnz
# Email:		yunxinyi@gmail.com
# Created:		2015-11-26 02:07:13 CST
# Last-update:	2015-11-26 02:07:13 CST
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

# set trap to intercept the non-zero return code of last program
su::sig::err() {
	local ecode=$?
	local cmd="$BASH_COMMAND"
	su::msgdump::error "cmd failed: cmd=[$cmd]"
	#local cmd
	#cmd="$(history | tail -1 | sed -e 's/^ *[0-9]* *//')"
	#su::log::error "command: [${cmd}] exit code: [${ecode}]"
}

# do some stuff before exit
su::sig::exit() {
	su::log::info "${USER}:$(tty) leaves"
}

trap su::sig::err ERR
trap su::sig::exit EXIT
