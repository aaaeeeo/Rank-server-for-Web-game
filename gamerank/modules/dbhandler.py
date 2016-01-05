# encoding = utf-8
"""
Created on 2016-1-5
@author: LZM
"""

from config import *
from pymongo import MongoClient

class DbHandler(object):

    def __init__(self):
        self.client = MongoClient()
        self.db = self.client.eval(DB_NAME)
        self.coll = self.db.eval(COLL_NAME)

