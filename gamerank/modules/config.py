# encoding = utf-8
"""
Created on 2016-1-5
@author: LZM
"""

# Genernal
ENCODING = "UTF8"

# HTTP
HTTP_HOST = ""
HTTP_PORT = 8000

# Route
ROUTE_DEF = {
    "/upload_score.lol": ("POST", "upload_score"),
    "/get_rank.lol": ("GET", "get_rank"),
    "/login.lol": ("POST", "login"),
    "/create_user.lol": ("POST", "create_user")
}

STATIC_DIR = "pages"

TYPE_DEF = {
    '.html':'text/html',
    '.htm':'text/html',
    '.css':'text/css',
    '.js':'application/x-javascript',
    '.ico':'image/x-icon',
    '.jpg':'image/jpeg',
    '.jpeg':'image/jpeg'
}

# DB
DB_HOST = "localhost"
DB_PORT = 3307
DB_USER = "root"
DB_PWD = "7684"
DB_NAME = "gamerank"
