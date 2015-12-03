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
# Description:  The core of the shell-utils
#
# Version:		0.0.1
# Revision:	[None]
# Revision history:	[None]
# Date Author Remarks:	[None]
#
# ===============================================================
#

#---------------------------global switches-----------------------------
#set -e
#set -u
set -o pipefail
#===========================global variables============================

#---------------------------global variables----------------------------
# shell type
__SU__SHELL__="${__SU__SHELL__}"
# shell utils home path
__SU__HOME__="${__SU__HOME__}"
#===========================global variables============================

# load the core stuff
__su::bootstrap__() {
	local shell="${__SU__SHELL__}"
	if [ -z "$shell" ]; then
		if [ -n "$BASH_VERSION" ]; then
			shell='bash'
		elif [ -n "$ZSH_VERSION" ]; then
			shell='zsh'
		else
			echo "cannot detect shell type" 1>&2
			return 1
		fi
	fi
	__SU__SHELL__="$shell"
	if [ -z "${__SU__HOME__}" ]; then
		local self
		case "$shell" in
			bash)
				self="$BASH_SOURCE"
				;;
			zsh)
				echo "${FUNCNAME}: unimplemented yet" 1>&2
				return 1
				;;
			*)
				echo "${FUNCNAME}: unsupported shell: $shell" 1>&2
				return 1
				;;
		esac
		while [ -L "$self" ]; do
			if ! self="$(readlink "$self")"; then
				return 1
			fi
		done
		if ! self="$(dirname "$self")"; then
			return 1
		fi
		if ! __SU__HOME__="$(dirname "$self")"; then
			return 1
		fi
	fi
	case "$shell" in
	bash)
		local mod
		local suffix
		for mod in msgdump \
			env \
			mod \
			sig \
			path \
			log \
			backup \
			plug; do
			for suffix in "-${OSTYPE}.${SHELL}" \
				".${SHELL}" \
				"-${OSTYPE}.sh" \
				".sh"; do
				local f="${__SU__HOME__}/core/${mod}${suffix}"
				if [ -f "$f" ]; then
					source "$f"
					break
				fi
			done
		done
		;;
	zsh)
		echo "${FUNCNAME}: not implemented yet" 1>&2
		return 1
		;;
	*)
		echo "${FUNCNAME}: unsupported shell: $shell" 1>&2
		return 1
		;;
	esac
}

# load opt and ext stuff
__su::initialize__() {
	:
}

# final stuff goes here
__su::finalize__() {
	:
}

__su::bootstrap__
__su::initialize__
__su::finalize__
