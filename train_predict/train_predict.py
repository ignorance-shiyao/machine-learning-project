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

# 输出全部数据
numpy.set_printoptions(threshold=sys.maxsize)


# 连接数据库
def get_connection():
    connection = pymysql.connect(
        user='root',
        password='shiyao'
    )
    return connection


# 读取训练集数据
sql = 'select * from db_ml.train_data'

train = pd.read_sql(sql=sql, con=get_connection())
# print(train)

# 读取 order_count 之外的所有列
x = train.drop(labels='order_count', axis=1)

# 读取 order_count
y = train[['order_count']]
# print(x,y)

# 采用线性模型
lr = LinearRegression()
lr.fit(x, y)

# 读取测试集数据
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

# 预测 order_count
y_predict = lr.predict(x_test)

# 将预测值存入model.csv
with open('../output/model.csv', 'w') as f:
    for y in y_predict:
        for z in y:
            f.write(str(z) + "\n")

print('y predict', y_predict)

print('y predict type', type(y_predict))
print('y predict size', y_predict.size)
