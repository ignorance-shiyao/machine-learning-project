#!/usr/bin/env python
# -*- coding: UTF-8 -*-


"""
@Project：machine-learning-project
@Author：shiyao
@Email：13207690135@163.com
@Time：2019-07-04 09:30:18
@IDE：PyCharm
@File Name：train_predict.py
"""

import pymysql
import pandas as pd
from sklearn.linear_model import LinearRegression

import sys
import numpy

numpy.set_printoptions(threshold=sys.maxsize)


def get_connection():
    connection = pymysql.connect(
        user='root',
        password='shiyao'
    )

    return connection


sql = 'select * from db_ml.train_data'

train = pd.read_sql(sql=sql, con=get_connection())
# print(train)
x = train.drop(labels='order_count', axis=1)
y = train[['order_count']]
# print(x,y)

lr = LinearRegression()
lr.fit(x, y)

sql = 'select * from db_ml.test_data'

test = pd.read_sql(sql=sql, con=get_connection())

x_test = test[
    [
        "s_petrol", "s_market", "s_uptown", "s_metro", "s_bus",
        "s_cafe", "s_restaurant", "s_atm", "s_office", "s_hotel",
        "e_petrol", "e_market", "e_uptown", "e_metro", "e_bus",
        "e_cafe", "e_restaurant", "e_atm", "e_office", "e_hotel",
        "w_temperature", "w_feels_like", "w_pressure", "w_humidity",
        "w_visibility", "w_direction_degree", "w_wind_speed"
    ]
]

y_predict = lr.predict(x_test)

print('y predict', y_predict)

print('y predict type', type(y_predict))
print('y predict size', y_predict.size)
