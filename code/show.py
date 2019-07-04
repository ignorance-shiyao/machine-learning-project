#!/usr/bin/env python
# -*- coding: utf-8 -*-


"""
@author: lyl
@Software: PyCharm
@file: show.py
@time: 2019/7/2 11:28
"""

import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np


def show():
    train_data = pd.read_csv("../data/UAI_Data/train_July_clean.csv")
    sns.set(style='whitegrid', context='notebook')
    cols = ['create_hour', 'gas_station', 'super_market',
            'uptown', 'subway', 'bus', 'coffee', 'c_restaurant', 'ATM', 'office_building', 'hotel', 'code', 'status']
    sns.pairplot(train_data[cols], height=2.5)
    plt.show()

    cm = np.corrcoef(train_data[cols].values.T)
    sns.set(font_scale=0.1)
    sns.heatmap(cm, cbar=True, annot=True, square=True,
                fmt='.1f', annot_kws={'size': 15}, yticklabels=cols, xticklabels=cols)
    plt.show()


if __name__ == '__main__':
    show()
