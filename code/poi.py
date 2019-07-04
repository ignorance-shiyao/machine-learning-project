#!/usr/bin/env python
# -*- coding: utf-8 -*-


"""
@author: lyl
@Software: PyCharm
@file: poi.py
@time: 2019/7/2 10:09
"""


import pandas as pd


poi = pd.read_csv('../data/UAI_Data/poi.csv',encoding='gbk',header=None)

poi = poi.drop(labels=[1,3,5,7,9,11,13,15,17,19],axis=1)
poi.columns=['geo_id','gas_station','super_market','uptown','subway','bus','coffee','restaurant','ATM','office_building','hotel']
print(poi)
poi.to_csv('../data/UAI_Data/poi_clean.csv',index=False)