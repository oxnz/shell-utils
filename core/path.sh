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
	local i
	for i in jdk go maven; do
		if [ -d "/usr/local/$i/bin" ]; then
			su::pathmunge "/usr/local/$i/bin" 'after'
		elif [ -d "/opt/$i/bin" ]; then
			su::pathmunge "/opt/$i/bin" 'after'
		fi
	done
}

su::abspath() {
	local path="$1"
	while [ -L "${path}" ]; do
		if ! path="$(readlink "${path}")"; then
			printf "$FUNCNAME: bad link: ${path}" >&2
			return 1
		fi
	done
	echo "${path}"
}
