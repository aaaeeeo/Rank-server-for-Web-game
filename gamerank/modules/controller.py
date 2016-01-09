# encoding = utf-8
"""
Created on 2016-1-5
@author: LZM
"""

from config import *
import dbhandler



def get_rank(dbh):
    dbh.c.execute("SELECT * FROM RANK")
    print(dbh.c.fetchall())

def upload_score(dbh,username):
    dbh.c.execute("SELECT * FROM RANK")

def create_user(dbh):
    dbh.c.execute("SELECT * FROM RANK")

def login(dbh):
    dbh.c.execute("SELECT * FROM RANK")

def log(dbh,gameid,userid,action,value,IP,rawrequest,level=0,notes=""):
    dbh.c.execute("INSERT INTO log(game_id, user_id, action, value, IP, raw_request, level, notes)"
                  "VALUES()")

if __name__ == '__main__':
    print("run")
    try:
        dbh = dbhandler.DbHandler()
        get_rank(dbh)
        dbh.c.execute("SELECT LAST_INSERT_ID()")

    except:
        print("error")
    pass