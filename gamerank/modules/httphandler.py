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

    def __static_dir(self):
        root_path = os.path.abspath(os.path.join(os.path.dirname('settings.py'), os.path.pardir))
        #print(root_path)
        return root_path

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

        if code == 200:
            self.send_response(code)
            enc = ENCODING
            #print(content)
            content = content.encode(enc)
            #print(content)
            f = io.BytesIO()
            f.write(content)
            f.seek(0)
            self.send_header("Content-type", "text/html; charset=%s" % enc)
            self.send_header("Content-Length", str(len(content)))
            self.end_headers()
            shutil.copyfileobj(f,self.wfile)
        else:
            self.send_error(code,content)

    def __get_dbh(self):
        if self.__dbh is None:
            self.__dbh = dbhandler.DbHandler()
            self.__dbh.connect()
        return self.__dbh

    def __append_head(self, dict):
        ip = "%s:%s" % (self.client_address[0], self.client_address[1])
        raw = "" + str(self.client_address)+"\t\n" + str(self.requestline)+"\t\n" + str(self.request)+"\t\n" + str(self.headers)
        dict["IP"]=ip
        dict["rawrequest"]=raw
        #print(dict)
        return dict

    def __prepare_response(self, dict):
        return json.dumps(dict, ensure_ascii=False)

    def __get_static(self):
        root_path = self.__static_dir()
        path = root_path + "/" + STATIC_DIR + self.__split_route()
        print(path)
        all_the_text = open(path).read( )
        return all_the_text

    def process(self, type):
        ctl = self.__resolve_route(type)
        if ctl == -1:
            try:
                html_text = self.__get_static()
                #print(html_text)
                self.__response(200, html_text)
            except:
                self.__response(404, "File not found")
        else:
            paras = self.__resolve_paras(type)
            paras = self.__append_head(paras)
            dbh = self.__get_dbh()
            res_dict = eval(ctl)(dbh, paras)
            res_json = self.__prepare_response(res_dict)
            #print(res_dict)
            print(res_json)
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
