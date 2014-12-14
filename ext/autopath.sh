#!/usr/bin/env sh
# 
#================================================================
#
# Filename:	autopath.sh
#
# Author:		Oxnz
# Email:		yunxinyi@gmail.com
# Created:		[2014-12-14 23:16:00 CST]
# Last-update:	2014-12-14 23:16:00 CST
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
#====================================== [vim template v1.0] =====
#

# auto detect path
autopath() {
	if [ -d '/usr/local/jdk' ]; then
		:
	fi
}
unset autopath
