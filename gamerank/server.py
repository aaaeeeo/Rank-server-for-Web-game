# encoding = utf-8
"""
Created on 2016-1-5
@author: LZM
"""

from modules.httphandler import *
from config import *

if __name__ == '__main__':

    print("**************************************************")
    print("** GAMERANK webgame ranking server  VERSION 1.0 **")
    print("**        Authur: Zuoming Li, Baolin Fan        **")
    print("**************************************************")
    try:
        server = ThreadingHTTPServer(('', HTTP_PORT), HTTPHandler)
        print('GAMERANK server running...')
        print("Listening on: "+server.server_address[0]+":"+str(server.server_address[1]))
        server.serve_forever()

    except KeyboardInterrupt:
        server.shutdown()

    pass