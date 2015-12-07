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
# Filename:	mod.sh
#
# Author:		Oxnz
# Email:		yunxinyi@gmail.com
# Created:		2015-11-22 14:32:08 CST
# Last-update:	2015-11-22 14:32:08 CST
# Description:  this file contains the stuff to load other modules
#
# Version:		0.0.1
# Revision:	[None]
# Revision history:	[None]
# Date Author Remarks:	[None]
#
# ===============================================================
#

# global variable holds all the loaded modules
__su__mod__loaded__=
__su__mod__skipped__=

# import specified semantics into current context
su::use() {
	if [ $# -ne 1 ]; then
		echo "Usage: ${FUNCNAME} <mod>" >&2
		return 1
	fi
	local mod="$1"
	local f="$mod"
	if [ ! -f "$f" ]; then
		local suffix
		for suffix in "-${OSTYPE}.${__SU__SHELL__}" \
			".${__SU__SHELL__}" \
			"-${OSTYPE}.sh" \
			".sh" \
			""; do
			f="${__SU__HOME__}/${mod}${suffix}"
			if [ -e "$f" -a "$f" ]; then
				break
			fi
		done
	fi
	if [ ! -e "$f" ]; then
		su::msgdump::error "cannot find mod: $mod"
		return 1
	fi
	if source "$f"; then
		__su__mod__loaded__="${__su__mod__loaded__}:$mod"
	fi
}

# test if mod is loaded
su::using() {
	if [ $# -ne 1 ]; then
		echo "Usage: ${FUNCNAME[0]} <name>" >&2
		return 1
	fi
	local mod="$1"
	case ":${__su__mod__loaded__}:" in
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
	for mod in ${__su__mod__loaded__//:/ }; do
		echo "$mod"
	done
}

# indicate depends on relations
su::dep() {
	if [ $# -ne 1 -o -z "$1" ]; then
		echo "Usage: ${FUNCNAME[0]} <name>" >&2
		return 1
	fi
	local mod="$1"
	echo "depending on module [$mod]"
	if su::using "$mod"; then
		echo "already loaded"
	else
		su::use "$mod"
	fi
}

