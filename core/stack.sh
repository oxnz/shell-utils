#!/usr/bin/env sh
# 
# ===============================================================
#
# Filename:	stack.sh
#
# Author:		Oxnz
# Email:		yunxinyi@gmail.com
# Created:		2015-12-02 23:42:26 CST
# Last-update:	2015-12-02 23:42:26 CST
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

##! @desc: stack trace utility
function pstack() {
	local i
	printf -- '----------------stack trace-------------------\n'
	for ((i = ${#FUNCNAME[@]}-1; i >= 0; --i)); do
		printf "${FUNCNAME[$i]}\n"
	done
	printf '=====================end======================\n'
}
