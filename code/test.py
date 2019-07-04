#!/usr/bin/env python
# -*- coding: utf-8 -*-


"""
@author: lyl
@Software: PyCharm
@file: test.py
@time: 2019/7/2 9:25
"""


def extract_statis(train):
    trainDic = dict()
    for item in train:
        try:
            row = list()
            row.append(item["startpoi"]["petrol"])
            row.append(item["startpoi"]["market"])
            row.append(item["startpoi"]["uptown"])
            row.append(item["startpoi"]["metro"])
            row.append(item["startpoi"]["bus"])
            row.append(item["startpoi"]["cafe"])
            row.append(item["startpoi"]["restruant"])
            row.append(item["startpoi"]["atm"])
            row.append(item["startpoi"]["office"])
            row.append(item["startpoi"]["hotel"])
            row.append(item["endpoi"]["petrol"])
            row.append(item["endpoi"]["market"])
            row.append(item["endpoi"]["uptown"])
            row.append(item["endpoi"]["metro"])
            row.append(item["endpoi"]["bus"])
            row.append(item["endpoi"]["cafe"])
            row.append(item["endpoi"]["restruant"])
            row.append(item["endpoi"]["atm"])
            row.append(item["endpoi"]["office"])
            row.append(item["endpoi"]["hotel"])
            row.append(item["weather"][0]["date"])
            row.append(item["weather"][0]["hour"])
            row.append(item["weather"][0]["min"])
            row.append(item["weather"][0]["code"])
            row.append(item["weather"][0]["temperature"])
            row.append(item["weather"][0]["feels_like"])
            row.append(item["weather"][0]["pressure"])
            row.append(item["weather"][0]["humidity"])
            row.append(item["weather"][0]["visibility"])
            row.append(item["weather"][0]["wind_direction_degree"])
            row.append(item["weather"][0]["wind_speed"])
            row.append(item["weather"][0]["wind_scale"])
            key = "@".join(row)

            if key not in trainDic.keys():
                trainDic[key] = dict()
                trainDic[key]["features"] = row
                trainDic[key]["count"] = 0

            trainDic[key]["count"] += 1
        except:
            continue

    trainList = list()
    for k in trainDic.keys():
        trainDic[k]["features"].append(trainDic[k]["count"])
        trainList.append(trainDic[k]["features"])

    columnNames = ["s_petrol", "s_market", "s_uptown", "s_metro", "s_bu s", "s_cafe", "s_restruant",
                   "s_atm", "s_office", "s_hotel", "e_petrol", "e_market", "e_uptown", "e_metro", "e_bus", "e_cafe",
                   "e_restruant", "e_atm", "e_office", "e_hotel", "date", "hour", "min", "code", "temperature",
                   "feels_ like", "pressure", "humidity", "visibility", "wind_direction_degree", "wind_speed",
                   "wind_scale", "count"]
    return trainList, columnNames


extract_statis