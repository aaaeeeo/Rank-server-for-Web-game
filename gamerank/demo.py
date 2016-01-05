# encoding=utf-8
"""
Created on 2016-1-4
@author: LZM
"""
from http.server import BaseHTTPRequestHandler, HTTPServer
import io,shutil
import socketserver
import json
import urllib
from pymongo import MongoClient


class MyThreadingHTTPServer(socketserver.ThreadingMixIn, HTTPServer):
    pass


class MyRequestHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        self.process(2)

    def do_POST(self):
        self.process(1)

    def process(self, type):

        content =""
        if type==1:
            datas = self.rfile.read(int(self.headers['content-length']))
            datas = str(datas, "utf-8")
            datas = urllib.parse.unquote(datas)
            print(datas)

            dict = json.loads(datas)
            print(dict)

            for key,val in dict.items():
                content+=("{} = {}\r\n".format(key, val))
            print(content)

            client = MongoClient()
            db = client.gamerank
            coll = db.rank
            coll.update_one(
                {"name": dict["name"]},
                {
                    "$set": {
                    "score": dict["score"]
                    }
                },
                True
            )

        if '?' in self.path:

            print(self.path)
            query = urllib.parse.unquote(self.path.split('?',1)[1])
            dict = urllib.parse.parse_qs(query)
            print(query)
            # action = query[0]

            for key,val in dict.items():
                content+=("{} = {}\r\n".format(key, val[0]))

        #指定返回编码
        enc="UTF-8"
        content = content.encode(enc)
        f = io.BytesIO()
        f.write(content)
        f.seek(0)
        self.send_response(200)
        self.send_header("Content-type", "text/html; charset=%s" % enc)
        self.send_header("Content-Length", str(len(content)))
        self.end_headers()
        shutil.copyfileobj(f,self.wfile)
        print(self.headers )
        print(content)

        # else:
        #    self.send_response(200)
        #    self.send_header('Content-type', 'text/html')
        #    self.end_headers()
        #    self.wfile.write("nothing")


def transDicts(params):
    dicts={}
    if len(params)==0:
        return
    params = params.split('&')
    for param in params:
        dicts[param.split('=')[0]]=param.split('=')[1]
    return dicts

if __name__=='__main__':

    try:
        server = MyThreadingHTTPServer(('', 8000), MyRequestHandler)
        print('started httpserver...')
        server.serve_forever()

    except KeyboardInterrupt:
        server.socket.close()

    pass
