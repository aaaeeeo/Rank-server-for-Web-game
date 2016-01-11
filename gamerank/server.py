# encoding = utf-8
"""
Created on 2016-1-5
@author: LZM
"""

from modules.httphandler import *
from modules.config import *

if __name__ == '__main__':

    try:
        server = ThreadingHTTPServer(('', HTTP_PORT), HTTPHandler)
        print('started httpserver...')
        server.serve_forever()

    except KeyboardInterrupt:
        server.socket.close()

    pass