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
# ===============================================================
#
# Filename:	core.sh
#
# Author:		Oxnz
# Email:		yunxinyi@gmail.com
# Created:		2015-11-22 14:32:08 CST
# Last-update:	2015-11-22 14:32:08 CST
# Description:  The core functions of the shell-utils
#
# Version:		0.0.1
# Revision:	[None]
# Revision history:	[None]
# Date Author Remarks:	[None]
#
# ===============================================================
#

# global variable holds all the loaded modules
su__mods=''

# import specified semantics into current context
su::use() {
	if [ $# -ne 1 ]; then
		echo "Usage: ${FUNCNAME[0]} <name>" >&2
		return 1
	fi
	local mod="$1"
	echo "loading module [$mod]"
	if source "$mod"; then
		su__mods="${su__mods}:$mod"
		echo "loaded"
	fi
}

# test if mod is loaded
su::using() {
	if [ $# -ne 1 -o -z "$1" ]; then
		echo "Usage: ${FUNCNAME[0]} <name>" >&2
		return 1
	fi
	local mod="$1"
	case ":${su__mods}:" in
		*:"$mod":*)
			return 0
			;;
		*)
			return 1
			;;
	esac
}

# unimport essentials imported by `su::use'
su::no() {
	if [ $# -ne 1 ]; then
		echo "Usage: ${FUNCNAME[0]} <name>" >&2
		return 1
	fi
	local mod="$1"
	echo "unloading module [$mod]"
	if su::using "$mod"; then
		"$mod::undef"
	fi
}

su::reload() {
	if [ $# -ne 1 ]; then
		echo "Usage: ${FUNCNAME[0]} <name>" >&2
		return 1
	fi
	local mod="$1"
	if su::using "$mod"; then
		su::unload "$mod"
	fi
	su::load "$mod"
}

# list mods
su::lsmod() {
	local mod
	for mod in ${su__mods//:/ }; do
		echo "$mod"
	done
}

# depends on
su::dep() {
	if [ $# -ne 1 -o -z "$1"]; then
		echo "Usage: ${FUNCNAME[0]} <name>" >&2
		return 1
	fi
	local mod="$1"
	echo "depending on module [$mod]"
	if su::using "$mod"; then
		echo "already loaded"
	else
		su:use "$mod"
	fi
}
