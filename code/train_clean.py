#!/usr/bin/env python
# -*- coding: utf-8 -*-


"""
@author: lyl
@Software: PyCharm
@file: train_clean.py
@time: 2019/7/2 9:42
"""

import pandas as pd

# 读取数据
train_data = pd.read_csv('../data/UAI_Data/train_July.csv')
weather = pd.read_csv('../data/UAI_Data/weather_clean.csv')
poi = pd.read_csv('../data/UAI_Data/poi_clean.csv')
# print((train_data))

# 删除无用的列
train_data = train_data.drop(['id', 'driver_id', 'member_id'], axis=1)
# print(train_data)

# 处理数据类型
weather['create_date'] = pd.to_datetime(weather['create_date'], format="%Y-%m-%d")
train_data['create_date'] = pd.to_datetime(train_data['create_date'], format="%Y-%m-%d")
print(train_data['create_date'])

# 合并多个表格数据
train_data = pd.merge(train_data, poi, how='left', left_on=u'start_geo_id', right_on='geo_id')
train_data = pd.merge(train_data, weather, on=['create_date', 'create_hour'])
print(train_data)

# # 删除重复行
# train_data = train_data.drop(['geo_id'], axis=1)
#
# # 保存csv
train_data.to_csv('../data/UAI_Data/train_July_clean.csv', index=False)
