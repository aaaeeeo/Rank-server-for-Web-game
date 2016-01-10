# encoding = utf-8
"""
Created on 2016-1-5
@author: LZM
"""

from config import *
import dbhandler
import MySQLdb


def get_rank(dbh, paras):
    try:
        print(paras)
        #__log(dbh, paras["gameid"], paras["userid"], "GET RANK",
        #  0, paras["IP"], paras["rawrequest"])
        dbh.c.execute("SELECT * FROM RANK WHERE game_id=%s",
                  (paras["gameid"],))
        return dbh.c.fetchall()
    except MySQLdb.Error as e:
        __error_handle(e)
        return -1


def upload_score(dbh, paras):
    try:
        __log(dbh, paras["gameid"], paras["userid"], "UPLOAD SCORE",
              paras["score"], paras["IP"], paras["rawrequest"])
        return 1
    except MySQLdb.Error as e:
        __error_handle(e)
        return -1


def create_user(dbh, paras):
    try:
        __log(dbh, paras["gameid"], paras["userid"], "CREATE USER",
          0, paras["IP"], paras["rawrequest"])
        dbh.c.execute("INSERT INTO users(user_id, user_name, head_image) "
                  "VALUES (%s,%s,%s)",
                  (paras["userid"], paras["username"], paras["headimage"]))
        return 1
    except MySQLdb.Error as e:
        __error_handle(e)
        return -1


def login(dbh, paras):
    try:
        __log(dbh, paras["gameid"], paras["userid"], "LOGIN",
          0, paras["IP"], paras["rawrequest"])
        dbh.c.execute("SELECT user_id, user_name, head_image FROM users "
                      "WHERE user_id=%s AND disabled=1",
                      (paras["userid"],))
        if len(dbh.c.fetchall()) is not 0:
            return 2
        else:
            dbh.c.execute("SELECT user_id, user_name, head_image FROM users "
                          "WHERE user_id=%s AND disabled=0",
                          (paras["userid"],))
            return len(dbh.c.fetchall())
    except MySQLdb.Error as e:
        __error_handle(e)
        return -1


def __log(dbh, gameid, userid, action, value, IP, rawrequest, level=0, notes=""):
    try:
        dbh.c.execute("INSERT INTO log(game_id, user_id, action, value, IP, raw_request, level, notes) "
                      "VALUES(%s,%s,%s,%s,%s,%s,%s,%s)",
                      (gameid,userid,action,value,IP,rawrequest,level,notes))
        return 1
    except MySQLdb.Error as e:
        __error_handle(e)
        return -1


def __error_handle(e):
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