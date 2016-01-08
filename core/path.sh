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
# This file is part of the Shell-Utils project
# Copyright (C) 2014 Oxnz, All rights reserved
# manage PATH variable

su::pathremove() {
	local IFS=':'
	# path to be removed
	local rmpath="$1"
	local newpath
	local subpath
	for subpath in $PATH; do
		if [ $subpath != "$rmpath" ]; then
			newpath="${newpath:+$newpath:}$subpath"
		fi
	done
	export PATH="$newpath"
}

su::pathmunge() {
	case ":${PATH}:" in
		*:"$1":* | "$1:${PATH}:")
			# $1 is already contained or $1 is NIL
			;;
		*)
			if [ "$2" = "after" ]; then
				PATH=$PATH:$1
			else
				PATH=$1:$PATH
			fi
	esac
}

su::autopath() {
	local ppth pth
	for ppth in /usr/local /opt; do
		for pth in "$ppth"/*/bin; do
			if [ -d "$pth" ]; then
				su::pathmunge "$pth" 'after'
			fi
		done
	done
}

which realpath > /dev/null 2>&1 || su::realpath() {
	local file
	local dir
	local base
	for file; do
		while [ -L "$file" ]; do
			file="$(readlink "$file")"
		done
		if [ -d "$file" ]; then
			base="";
			dir="$file"
		else
			base="/$(basename "$file")"
			dir="$(dirname "$file")"
		fi
		dir="$(cd "$dir" && pwd)"
		su::puts "$dir$base"
	done
}
