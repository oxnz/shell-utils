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
# ---------------------------------------------------------------
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
# ===============================================================
#

# set trap to intercept the non-zero return code of last program
##! @sig{ERR}
su::sig::err() {
	local ecode=$?
	local cmd="$BASH_COMMAND"
	#su::msgdump::error "cmd failed: cmd=[$cmd]"
	#local cmd
	#cmd="$(history | tail -1 | sed -e 's/^ *[0-9]* *//')"
	su::log::error "command: [${cmd}] exit code: [${ecode}]"
}

# do some stuff before exit
##! @sig{EXIT}
su::sig::exit() {
	su::log::info "${USER}:$(tty) leaves"
}

trap su::sig::err ERR
trap su::sig::exit EXIT
