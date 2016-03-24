#!/usr/bin/env python
# -*- coding: utf-8 -*-
# ===============================================================
#
# Filename:	fortune.py
#
# Author:		Oxnz
# Email:		yunxinyi@gmail.com
# Created:		[2015-08-12 12:46:19 CST]
# Last-update:	2015-08-12 12:46:19 CST
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

FORTUNES = '../data/fortunes'

with open(FORTUNES, 'r') as f:
    for line in f:
        print line
