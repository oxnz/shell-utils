#!/usr/bin/env sh
# 
# ===============================================================
#
# Filename:	path.sh
#
# Author:		Oxnz
# Email:		yunxinyi@gmail.com
# Created:		[2014-12-09 23:37:00 CST]
# Last-update:	2014-12-09 23:37:00 CST
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

abspath() {
	readlink -f "$1"
}
