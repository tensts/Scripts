#!/usr/bin/env python

from pyftpdlib import servers
from pyftpdlib.handlers import FTPHandler
from pyftpdlib.authorizers import DummyAuthorizer

address = ("0.0.0.0", 21)

authorizer = DummyAuthorizer()
authorizer.add_user('user', '12345', '.', perm='elradfmwMT')

handler = FTPHandler
handler.authorizer = authorizer

server = servers.FTPServer(address, handler)
server.serve_forever()
