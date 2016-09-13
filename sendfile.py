#!/usr/bin/env python
# -*- coding: utf-8 -*-
# ===============================================================
#
# Filename:	send.py
#
# Author:		Oxnz
# Email:		yunxinyi@gmail.com
# Created:		2016-05-26 15:25:06 CST
# Last-update:	2016-05-26 15:25:06 CST
# Description: ANCHOR
#
# Version:		0.0.1
# Revision:	[None]
# Revision history:	[None]
# Date Author Remarks:	[None]
#
# License:
# Copyright (c) 2016 Oxnz
#
# Distributed under terms of the [LICENSE] license.
# [license]
#
# ===============================================================
#

import socket
import sys

s = socket.socket()
host = 'oxnz.github.io'
port = 8000
s.connect((host, port))
f = open('mysql-5.7.12-linux-glibc2.5-x86_64.tar.gz')
buflen = 1024*1024*128
buf = f.read(buflen)
while buf:
    s.send(buf)
    buf = f.read(buflen)
s.close()
