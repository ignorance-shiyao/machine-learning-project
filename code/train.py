#!/usr/bin/env python
# -*- coding: utf-8 -*-


"""
@author: lyl
@Software: PyCharm
@file: train.py
@time: 2019/7/2 17:13
"""

from sklearn import neighbors
import numpy as np
import matplotlib.pyplot as plt


def f(x1, x2):
    y = 0.5 * np.sin(x1) + 0.5 * np.cos(x2) + 3 + 0.1 * x1
    return y


def load_data():
    ''' 准备 训练集 和 测试集'''
    x1_train = np.linspace(0, 50, 500)
    x2_train = np.linspace(-10, 10, 500)
    data_train = np.array([[x1, x2,
                            f(x1, x2) + (np.random.random(1) - 0.5)]
                           for x1, x2 in zip(x1_train, x2_train)])
    x1_test = np.linspace(0, 50, 500) + 0.5 * np.random.random(500)
    x2_test = np.linspace(-10, 10, 500) + 0.02 * np.random.random(500)
    data_test = np.array([[x1, x2, f(x1, x2)]
                          for x1, x2 in zip(x1_test, x2_test)])
    return data_train, data_test


train, test = load_data()
x_train, y_train = train[:, :2], train[:, 2]  # 数据前两列是 x1,x2 第三列是 y, y 有随机噪声
x_test, y_test = test[:, :2], test[:, 2]  # 同上, y 没有噪声


def try_different_method(clf):
    clf.fit(x_train, y_train)
    score = clf.score(x_test, y_test)
    result = clf.predict(x_test)
    plt.figure()
    plt.plot(np.arange(len(result)), y_test, 'go-', label='true value')
    plt.plot(np.arange(len(result)), result, 'ro-', label='predict value')
    plt.title('score: %f' % score)
    print('score:', score)
    plt.legend()
    plt.show()


def initial():
    ''' 绘制 训练集 和 测试集 '''
    plt.rcParams['figure.figsize'] = (64.0, 32.0)  # 设置 figure_size 尺寸
    plt.figure()
    plt.plot(np.arange(len(x_train)), y_train, 'ro-', label='train set')
    plt.plot(np.arange(len(x_test)), y_test, 'go-', label='test set')
    plt.legend()
    plt.show()


initial()




knn = neighbors.KNeighborsRegressor()

try_different_method(knn)