#!/usr/bin/env python
# -*- coding: utf-8 -*-


"""
@author: lyl
@Software: PyCharm
@file: weather_clean.py
@time: 2019/7/2 9:26
"""


import pandas as pd

weather = pd.read_csv('../data/UAI_Data/weather.csv')

code =  weather['code']
date = weather['date']

day = date.map(lambda x : x.split(' ')[0])
day = pd.to_datetime(day,format="%Y-%m-%d")
hour = date.map(lambda x : x.split(' ')[1])
weather_clean = pd.DataFrame({'create_date':day,'create_hour':hour,'code':code})
weather_clean['create_hour'] = weather_clean['create_hour'].map(lambda x : x.split(':')[0])
weather_clean['create_hour'] = pd.to_numeric(weather_clean['create_hour'])
weather_clean = weather_clean.iloc[::2]
weather_clean.to_csv('../data/UAI_Data/weather_clean.csv',index=False)



