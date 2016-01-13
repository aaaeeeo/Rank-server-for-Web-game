# encoding = utf-8
"""
Created on 2016-1-10
@author: LZM
"""

from config import *
from modules import dbhandler
import MySQLdb


def get_rank(dbh, paras):
    try:
        #print(paras)
        __log(dbh, paras["game_token"], paras["user_id"], "GET RANK",
          0, paras["IP"], paras["raw_request"])
        dbh.db.commit()
        dbh.dictc.execute("SELECT * FROM rank WHERE game_token=%s",
                  (paras["game_token"],))
        return dbh.dictc.fetchall()
    except MySQLdb.Error as e:
        __error_handle(e, dbh)
        return -1


def upload_score(dbh, paras):
    try:
        __log(dbh, paras["game_token"], paras["user_id"], "UPLOAD SCORE",
              paras["score"], paras["IP"], paras["raw_request"])
        dbh.db.commit()
        return 1
    except MySQLdb.Error as e:
        __error_handle(e, dbh)
        return -1


def create_user(dbh, paras):
    try:
        dbh.c.execute("INSERT INTO users(user_id, user_name, head_image) "
                  "VALUES (%s,%s,%s)",
                  (paras["user_id"], paras["user_name"], paras["head_image"]))
        #dbh.db.commit()
        #__log(dbh, paras["game_token"], paras["user_id"], "CREATE USER",
        #  0, paras["IP"], paras["raw_request"])
        dbh.db.commit()
        return 1
    except MySQLdb.Error as e:
        __error_handle(e, dbh)
        return -1


def login(dbh, paras):
    try:
        print(paras["user_id"])
        __log(dbh, paras["game_token"], paras["user_id"], "LOGIN",
          0, paras["IP"], paras["raw_request"])
        dbh.db.commit()
        dbh.c.execute("SELECT user_id, user_name, head_image FROM users "
                      "WHERE user_id=%s AND disabled=1",
                      (paras["user_id"],))
        if len(dbh.c.fetchall()) is not 0:
            return 2
        else:
            dbh.c.execute("SELECT user_id, user_name, head_image FROM users "
                          "WHERE user_id=%s AND disabled=0",
                          (paras["user_id"],))
            res=dbh.c.fetchall()
            if len(res) is 0:
                return 0
            else:
                return res[0]
    except MySQLdb.Error as e:
        __error_handle(e, dbh)
        return -1


def __log(dbh, game_token, user_id, action, value, IP, raw_request, level=0, notes=""):

    dbh.c.execute("INSERT INTO log(game_token, user_id, action, value, IP, raw_request, level, notes) "
                  "VALUES(%s,%s,%s,%s,%s,%s,%s,%s)",
                  (game_token,user_id,action,value,IP,raw_request,level,notes))



def __error_handle(e, dbh):
    dbh.db.rollback()
    try:
        print("MySQL Error [%d]: %s" % (e.args[0], e.args[1]))
    except IndexError:
        print("MySQL Error: %s" % str(e))

def test(dbh):
    dbh.c.execute("SELECT user_id, user_name, head_image FROM users "
                  "WHERE user_id=%s AND disabled=0",("t2",))
    __log(dbh,1,2,"a","a",1,1)
    print(len(dbh.c.fetchall()))

if __name__ == '__main__':
    print("run")
    try:
        dbh = dbhandler.DbHandler()
        dbh.connect()
        test(dbh)

    except MySQLdb.Error as e:
        __error_handle(e)
    pass