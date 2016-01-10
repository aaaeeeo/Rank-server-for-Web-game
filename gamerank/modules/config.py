# encoding = utf-8
"""
Created on 2016-1-5
@author: LZM
"""

# HTTP
HTTP_HOST = ""
HTTP_PORT = 80

# Route
ROUTE_DEF = {
    "/upload_score.lol": ("POST", "upload_score"),
    "/get_rank.lol": ("GET", "get_rank"),
    "/login.lol": ("GET", "login"),
    "/create_user.lol": ("GET", "create_user")
}

# DB
DB_HOST = "localhost"
DB_PORT = 3307
DB_USER = "root"
DB_PWD = "7684"
DB_NAME = "gamerank"
