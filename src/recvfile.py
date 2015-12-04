#!/usr/bin/env python
#-*- encoding: utf-8 -*-

# receive octstream over socket

import socket

def recv(name, port):
    srv_sock = socket.socket()
    host = socket.gethostname()
    srv_sock.bind((host, port))
    f = open(name, 'wb')
    srv_sock.listen(5)
    while True:
        cli_sock, addr = srv_sock.accept()
        print 'client in: ', addr
        trunk = cli_sock.recv(1024)
        print '.',
        while (trunk):
            print '.',
            f.write(trunk)
            trunk = cli_sock.recv(1024)
        f.close()
        print 'done'
        cli_sock.close()

import sys

if __name__ == '__main__':
    if len(sys.argv) != 3:
        sys.stderr.write('Usage: {} <file> <port>\n'.format(sys.argv[0]))
        sys.exit(1)
    recv(sys.argv[1], sys.argv[2])
