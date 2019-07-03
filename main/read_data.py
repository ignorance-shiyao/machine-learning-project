#!/usr/bin/env python
# -*- coding: UTF-8 -*-


"""
@Project：machine-learning-project
@Author：shiyao
@Email：13207690135@163.com
@Time：2019-07-03 23:33:02
@IDE：PyCharm
@File Name：read_data.py
"""

import pymysql
import pandas as pd


def getConnection():
    conn = pymysql.connect(
        host='127.0.0.1',
        port=3306,
        user='root',
        passwd='shiyao',
        db='db_ml',
        charset='utf8')
    return conn


train = pd.read_sql(sql="select * from t_train_real",
                    con=getConnection())

x = train.drop(labels="order_count", axis=1)
y = train[["order_count"]]

from sklearn.linear_model import LinearRegression

lr = LinearRegression()
lr.fit(x, y)

test = pd.read_sql(sql="select * from db_ml.t_aug_test_real",
                   con=getConnection())
x_test = test[["s_petrol", "s_market", "s_uptown", "s_metro", "s_bus",
               "s_cafe",
               "s_restruant", "s_atm", "s_office", "s_hotel",
               "e_petrol", "e_market",
               "e_uptown", "e_metro", "e_bus", "e_cafe", "e_restruant",
               "e_atm",
               "e_office", "e_hotel", "w_temperature", "w_feels_like",
               "w_pressure",
               "w_humidity", "w_visibility", "w_wind_direction_degree",
               "w_wind_speed"]]

y_test = test[["count"]]

print(lr.score(x_test, y_test))
