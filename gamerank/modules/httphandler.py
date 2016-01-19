# encoding = utf-8
"""
Created on 2016-1-5
@author: LZM
"""

from config import *
from modules.pathhelper import *
from modules.controller import *
from modules import dbhandler

from http.server import BaseHTTPRequestHandler, HTTPServer
import io, shutil
import socketserver
import json
import urllib
import os

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

    def __all_path(self):
        return urllib.parse.unquote(self.path, ENCODING)

    def __split_route(self):
        if '?' in self.path:
            return urllib.parse.unquote(self.path.split('?', 1)[0], ENCODING)
        else:
            return urllib.parse.unquote(self.path, ENCODING)

    def __split_paras(self):
        if '?' in self.path:
            return urllib.parse.unquote(self.path.split('?', 1)[1], ENCODING)
        else:
            return ""

    def __resolve_route(self, type):
        #print(self.path)
        route = self.__split_route()
        #print(route)

        if route in ROUTE_DEF.keys():
            if ROUTE_DEF[route][0] == type:
                return ROUTE_DEF[route][1]
        return -1

    def __static_dir(self):
        static_path = WEB_PATH
        #print(static_path)
        return static_path

    def __resolve_paras(self, type):
        if type == "GET":
            url_paras = self.__split_paras()
            #print(url_paras)
            dict_paras = urllib.parse.parse_qs(url_paras)
            #print(dict_paras)
            return dict_paras

        if type == "POST":
            datas = self.rfile.read(int(self.headers['content-length']))
            datas = str(datas, ENCODING)
            json_datas = urllib.parse.unquote(datas)
            dict_datas = json.loads(json_datas)
            #print("!!!!!!!!! json_datas"+json_datas)
            return dict_datas

    def __response(self, code, content="", type="text/html", btype='text'):

        if code == 200:
            self.send_response(code)
            enc = ENCODING
            #print(content)

            if btype is 'text':
                content = content.encode(enc)
                self.send_header("Content-type", "%s; charset=%s" % (type, enc))
            else:
                self.send_header("Content-type", "%s" % type)

            f = io.BytesIO()
            f.write(content)
            f.seek(0)
            self.send_header("Content-Length", str(len(content)))
            self.end_headers()
            shutil.copyfileobj(f, self.wfile)
        else:
            self.send_error(code, content)

    def __get_dbh(self):
        if self.__dbh is None:
            self.__dbh = dbhandler.DbHandler()
            self.__dbh.connect()
        return self.__dbh

    def __append_head(self, dict):
        ip = "%s:%s" % (self.client_address[0], self.client_address[1])
        raw = "" + str(self.client_address)+"\t\n" + str(self.requestline)+"\t\n" + str(self.request)+"\t\n" + str(self.headers)
        dict["IP"] = ip
        dict["raw_request"] = raw
        #print(dict)
        return dict

    def __prepare_response(self, dict):
        return json.dumps(dict, ensure_ascii=False)

    def __get_static(self):
        #print("__get_static")
        ext_name = self.__split_route()[self.path.rfind('.'):]
        content_type = TYPE_DEF[ext_name]
        #print(ext_name)
        #print(content_type)
        print("@@@@@ __get_static.path: "+self.__split_route())
        static_path = self.__static_dir()
        path = static_path + self.__split_route()
        print("@@@@@ __get_static.path: "+path)
        try:
            content_data = open(path).read()
            type='text'
        except:
            content_data = open(path,'rb').read()
            type='binary'
        return content_data, content_type, type

    def process(self, type):
        print("@process: "+str(self.path))
        ctl = self.__resolve_route(type)
        #print(ctl)
        if ctl == -1:
            print("@process: ctl==-1")
            try:
                static = self.__get_static()
                print(static[1:])
                self.__response(200, static[0], static[1], static[2])
            except:
                self.__response(404, "File not found")
        else:
            paras = self.__resolve_paras(type)
            print("@@@@@ paras: "+str(paras))
            paras = self.__append_head(paras)
            dbh = self.__get_dbh()
            res_dict = eval(ctl)(dbh, paras)
            res_json = self.__prepare_response(res_dict)
            #print(res_dict)
            print("@@@@@ res_json: "+res_json)
            content = res_json
            self.__response(200, content, "application/json", 'text')


if __name__ == '__main__':

    try:
        server = ThreadingHTTPServer(('', 80), HTTPHandler)
        print('started httpserver...')
        print(server.server_address)
        server.serve_forever()

    except KeyboardInterrupt:
        server.socket.close()

    pass
