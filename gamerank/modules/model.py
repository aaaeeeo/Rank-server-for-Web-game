# encoding = utf-8
"""
Created on 2016-1-10
@author: LZM
"""

from config import *
import dbhandler
import MySQLdb


def get_rank(dbh, paras):
    try:
        print(paras)
        __log(dbh, paras["gametoken"], paras["userid"], "GET RANK",
          0, paras["IP"], paras["rawrequest"])
        dbh.db.commit()
        dbh.c.execute("SELECT * FROM RANK WHERE game_token=%s",
                  (paras["gametoken"],))
        return dbh.c.fetchall()
    except MySQLdb.Error as e:
        __error_handle(e, dbh)
        return -1


def upload_score(dbh, paras):
    try:
        __log(dbh, paras["gametoken"], paras["userid"], "UPLOAD SCORE",
              paras["score"], paras["IP"], paras["rawrequest"])
        dbh.db.commit()
        return 1
    except MySQLdb.Error as e:
        __error_handle(e, dbh)
        return -1


def create_user(dbh, paras):
    try:
        dbh.c.execute("INSERT INTO users(user_id, user_name, head_image) "
                  "VALUES (%s,%s,%s)",
                  (paras["userid"], paras["username"], paras["headimage"]))
        __log(dbh, paras["gametoken"], paras["userid"], "CREATE USER",
          0, paras["IP"], paras["rawrequest"])
        dbh.db.commit()
        return 1
    except MySQLdb.Error as e:
        __error_handle(e, dbh)
        return -1


def login(dbh, paras):
    try:
        __log(dbh, paras["gametoken"], paras["userid"], "LOGIN",
          0, paras["IP"], paras["rawrequest"])
        dbh.db.commit()
        dbh.c.execute("SELECT user_id, user_name, head_image FROM users "
                      "WHERE user_id=%s AND disabled=1",
                      (paras["userid"],))
        if len(dbh.c.fetchall()) is not 0:
            return 2
        else:
            dbh.c.execute("SELECT user_id, user_name, head_image FROM users "
                          "WHERE user_id=%s AND disabled=0",
                          (paras["userid"],))
            res=dbh.c.fetchall()
            if len(res) is 0:
                return 0
            else:
                return res[0]
    except MySQLdb.Error as e:
        __error_handle(e, dbh)
        return -1


def __log(dbh, gametoken, userid, action, value, IP, rawrequest, level=0, notes=""):
    try:
        sql="INSERT INTO log(game_token, user_id, action, value, IP, raw_request, level, notes) " \
            "VALUES(%s,%s,%s,%s,%s,%s,%s,%s)"%(gametoken,userid,action,value,IP,rawrequest,level,notes)
        #print(sql)
        dbh.c.execute("INSERT INTO log(game_token, user_id, action, value, IP, raw_request, level, notes) "
                      "VALUES(%s,%s,%s,%s,%s,%s,%s,%s)",
                      (gametoken[0],userid[0],action,value,IP,rawrequest,level,notes))
        return 1
    except MySQLdb.Error as e:
        __error_handle(e, dbh)
        return -1


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