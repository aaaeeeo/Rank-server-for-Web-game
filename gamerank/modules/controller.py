# encoding = utf-8
"""
Created on 2016-1-5
@author: LZM
"""

from modules.config import *
from modules import model


def get_rank(dbh, paras):
    return model.get_rank(dbh, paras)


def upload_score(dbh, paras):
    return __success_response(model.upload_score(dbh, paras))


def create_user(dbh, paras):
    return __success_response(model.create_user(dbh, paras))


def login(dbh, paras):
    t = model.login(dbh, paras)
    #print(t)
    res = dict()
    if t is -1:
        res['success']=False
    elif t is 0:
        res['success']=True
        res['isexist']=False
    elif t is 2:
        res['success']=True
        res['isexist']=True
        res['disabled']=True
    else:
        res['success']=True
        res['isexist']=True
        res['disabled']=False
        res['user_id']=t[0]
        res['user_name']=t[1]
        res['head_image']=t[2]
    return res


def __success_response(t):
    res = dict()
    if t is 1:
        res['success']=True
    elif t is -1:
        res['success']=False
    return res

if __name__ == '__main__':
    print("run")
