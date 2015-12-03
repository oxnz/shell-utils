#!/usr/bin/env python
#-*- encoding: utf-8 -*-

# receiver over socket

import socket

s = socket.socket()
host = socket.gethostname()
port = 8982
s.bind((host, port))
f = open('./x.tgz', 'wb')
s.listen(5)
while True:
	c, addr = s.accept()
	print 'client in: ', addr
	trunk = c.recv(1024)
	print '.',
	while (trunk):
		print '.',
		f.write(trunk)
		trunk = c.recv(1024)
	f.close()
	print 'done'
	c.send('ok')
	c.close()
