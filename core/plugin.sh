#!/usr/bin/env sh
#
# ===============================================================
#
# Filename:	plug.sh
#
# Author:		Oxnz
# Email:		yunxinyi@gmail.com
# Created:		2015-11-22 17:52:24 CST
# Last-update:	2015-11-22 17:52:24 CST
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

__su__plugins__=''

su::plug() {
	echo "plug in"
}

su::unplug() {
	echo "unplug"
}

su::replug() {
	su::unplug
	su::plug
}
