# encoding = utf-8
"""
Created on 2016-1-5
@author: LZM
"""

from config import *
from controller import *
import dbhandler

from http.server import BaseHTTPRequestHandler, HTTPServer
import io, shutil
import socketserver
import json
import urllib

class ThreadingHTTPServer(socketserver.ThreadingMixIn, HTTPServer):
    pass


class HTTPHandler(BaseHTTPRequestHandler):
    def __init__(self, request, client_address, server):
        self.__dbh = None
        super().__init__(request, client_address, server)

    def do_GET(self):
        self.process("GET")

    def do_POST(self):
        self.process("POST")

    def __split_route(self):
        return urllib.parse.unquote(self.path.split('?', 1)[0])

    def __split_paras(self):
        return urllib.parse.unquote(self.path.split('?', 1)[1])

    def __resolve_route(self, type):
        print(self.path)
        route = self.__split_route()

        if route in ROUTE_DEF.keys():
            if ROUTE_DEF[route][0] == type:
                return ROUTE_DEF[route][1]
        return -1

    def __resolve_paras(self, type):
        if type == "GET":
            url_paras = self.__split_paras()
            dict_paras = urllib.parse.parse_qs(url_paras)
            print(dict_paras)
            return dict_paras

        if type == "POST":
            datas = self.rfile.read(int(self.headers['content-length']))
            datas = str(datas, "utf-8")
            json_datas = urllib.parse.unquote(datas)
            dict_datas = json.loads(json_datas)
            print(dict_datas)
            return dict_datas

    def __response(self, code, content=""):
        self.send_response(code)
        if code == 200:
            enc="UTF-8"
            content = content.encode(enc)
            f = io.BytesIO()
            f.write(content)
            f.seek(0)
            self.send_header("Content-type", "text/html; charset=%s" % enc)
            self.send_header("Content-Length", str(len(content)))
            self.end_headers()
            shutil.copyfileobj(f,self.wfile)

    def __get_dbh(self):
        if self.__dbh is None:
            self.__dbh = dbhandler.DbHandler()
            self.__dbh.connect()
        return self.__dbh

    def __prepare_response(self, dict):
        return json.dumps(dict)

    def process(self, type):
        ctl = self.__resolve_route(type)
        if ctl == -1:
            self.__response(404)
        else:
            paras = self.__resolve_paras(type)
            dbh = self.__get_dbh()
            res_dict = eval(ctl)(dbh, paras)
            res_json = self.__prepare_response(res_dict)
            print(res_dict)
            content = res_json
            self.__response(200, content)


if __name__ == '__main__':

    try:
        server = ThreadingHTTPServer(('', 8000), HTTPHandler)
        print('started httpserver...')
        server.serve_forever()

    except KeyboardInterrupt:
        server.socket.close()

    pass
