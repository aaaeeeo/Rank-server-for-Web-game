# encoding = utf-8
"""
Created on 2016-1-5
@author: LZM
"""

from config import *
import controller

from http.server import BaseHTTPRequestHandler, HTTPServer
import io, shutil
import socketserver
import json
import urllib

class ThreadingHTTPServer(socketserver.ThreadingMixIn, HTTPServer):
    pass


class HTTPHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        self.process(2)

    def do_POST(self):
        self.process(1)

    def router(self, path):
        pass

    def process(self, type):
        print(self.path)
        path = urllib.parse.unquote(self.path.split('?', 1)[0])
        controller = self.router(path)

        if controller is not None:
            content =""
            if type == 1:
                datas = self.rfile.read(int(self.headers['content-length']))
                datas = str(datas, "utf-8")
                datas = urllib.parse.unquote(datas)
                print(datas)

                dict = json.loads(datas)
                print(dict)

                for key,val in dict.items():
                    content+=("{} = {}\r\n".format(key, val))
                print(content)

            if type == 2:
                print(self.path)
                query = urllib.parse.unquote(self.path.split('?',1)[1])
                dict = urllib.parse.parse_qs(query)
                print(query)
                for key,val in dict.items():
                    content+=("{} = {}\r\n".format(key, val[0]))



if __name__ == '__main__':

    try:
        server = ThreadingHTTPServer(('', 8000), HTTPHandler)
        print('started httpserver...')
        server.serve_forever()

    except KeyboardInterrupt:
        server.socket.close()

    pass
