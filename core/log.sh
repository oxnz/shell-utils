# ==============================================================================
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

__su__log__file__="${SHELL_UTILS_HOME}/var/log/shell.log"

# log file is large enough, new log file needed
su::log::roll() {
	local file="${__su__log__file__}-$(date '+%F').tar.gz"
	if tar czf "$file" "${__su__log__file__}"; then
		:>"${__su__log__file__}"
	else
		su::msgdump error "su::log::roll failed to create archive: $file"
	fi
}

su::log::file() {
	local file="${__su__log__file__}"
	if [ $# -eq 0 ]; then
		echo "$file"
	elif [ $# -eq 1 ]; then
		file="$1"
		if [ -f "$file" -a -w "$file" ]; then
			__su__log__file__="$file"
		else
			su::msgdump error "su::log::file: invalid file: $file"
			return 1
		fi
	else
		su::msgdump error "su::log::file: too many arguments" 1>&2
		return 1
	fi
}

su::log() {
    echo "[$(date '+%F %T %Z') $(pwd) ${FUNCNAME[1]}] $@" >> "${__su__log__file__}"
}
