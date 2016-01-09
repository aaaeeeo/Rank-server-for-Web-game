# encoding = utf-8
"""
Created on 2016-1-5
@author: LZM
"""

from config import *
import MySQLdb

class DbHandler(object):

    def __init__(self):
        self.db = MySQLdb.connect(host=DB_HOST, port=DB_PORT, user=DB_USER, passwd=DB_PWD, db=DB_NAME)
        self.c = self.db.cursor()

if __name__ == '__main__':
    print("run")
    try:
        dbh = DbHandler()
        dbh.c.execute("select * from users")
        print(dbh.c.fetchone())

    except:
        print("error")
    pass