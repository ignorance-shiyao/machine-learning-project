#!/usr/bin/env python
# -*- coding: UTF-8 -*-


"""
@Project：machine-learning-project
@Author：shiyao
@Email：13207690135@163.com
@Time：2019-07-03 20:54:56
@IDE：PyCharm
@File Name：train_read.py
"""

import csv


def TRAIN_read(fileName):
    csv_reader = csv.reader(open(fileName, encoding='utf-8'))
    trainSet = []

    for row in csv_reader:
        item = {}
        item["order_id"] = row[0]
        item["driver_id"] = row[1]
        item["member_id"] = row[2]
        item["create_date"] = row[3]
        item["create_hour"] = row[4]
        item["status"] = row[5]
        item["estimate_money"] = row[6]
        item["estimate_distance"] = row[7]
        item["estimate_term"] = row[8]
        item["start_geo_id"] = row[9]
        item["end_geo_id"] = row[10]
        trainSet.append(item)

    trainSet.pop(0)
    return trainSet
