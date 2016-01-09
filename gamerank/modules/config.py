# encoding = utf-8
"""
Created on 2016-1-5
@author: LZM
"""

# HTTP
HTTP_HOST = ""
HTTP_PORT = 80

# Route
ROUTE_DEF = [
    ("POST", "upload_score.lol", "upload_score"),
    ("GET",  "get_rank.lol", "get_rank"),
    ("POST", "login.lol", "login"),
    ("POST", "create_user.lol", "create_user")
]

# DB
DB_HOST = "localhost"
DB_PORT = 3307
DB_USER = "root"
DB_PWD = "7684"
DB_NAME = "gamerank"
