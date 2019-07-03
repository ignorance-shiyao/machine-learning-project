#!/usr/bin/env python
# -*- coding: UTF-8 -*-


"""
@Project：machine-learning-project
@Author：shiyao
@Email：13207690135@163.com
@Time：2019-07-03 21:00:09
@IDE：PyCharm
@File Name：db_connect.py
"""

import pymysql


def getConnection():
    conn = pymysql.connect(
        host='127.0.0.1',
        port=3306,
        user='root',
        passwd='shiyao',
        db='db_ml',
        charset='utf8')
    return conn


def Train_import(data):
    conn = getConnection()
    cursor = conn.cursor()

    count = 0
    for item in data:
        sql = 'insert into db_ml.t_train(order_id, driver_id, member_id, create_date,create_hour, status, estimate_money, estimate_distance,estimate_term,start_geo_id, end_geo_id) values(\'%s\', \'%s\', \'%s\', \'%s\', %s, %s, %s, %s, %s,\'%s\', \'%s\')'(
            item["order_id"], item["driver_id"], item["member_id"], item["create_date"], item["create_hour"],
            item["status"],
            item["estimate_money"], item["estimate_distance"], item["estimate_term"], item["start_geo_id"],
            item["end_geo_id"])
        count += 1
        cursor.execute(sql)

        if count % 500 == 0:
            conn.commit()

    conn.commit()
    cursor.close()
    conn.close()
