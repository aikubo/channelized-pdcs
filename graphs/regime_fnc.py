import numpy as np
import matplotlib.pyplot as plt
import matplotlib.font_manager as font_manager
from matplotlib.offsetbox import (TextArea, DrawingArea, OffsetImage,
                                  AnnotationBbox)
from mpl_toolkits import mplot3d
from mpl_toolkits.mplot3d import Axes3D
from scipy.interpolate import griddata
from matplotlib import cm
import pandas as pd
import seaborn as sns
import math

from slength import channelvolume

from openmod import *
from entrainmod import *
from pltfunc import *

from scipy.special import ellipk

def regime(labels, data, param, xlab, ylab, fid):
    fig, axes = plt.subplots()
    setgrl(labels, fig, axes, 6, 4)
    palette = setcolorandstyle(labels)

    for sim in labels:
        i = labels.index(sim)
        c = palette[i]
        initialcond = labelparam(sim)
        X = initialcond[param]
        end = data.loc[data.index[-1], sim]
        print(X)
        print(end)
        axes.scatter(X, end, color=c)

    axes.set_xlabel(param)
    axes.set_ylabel(ylab)
    savefigure(fid)


def curvat(labels):
    kapa = []
    dist = []
    kapadist = []
    for sim in labels:
        param = labelparam(sim)
        wave = param.get_value(0, 'Wave')
        A = param.get_value(0, 'Amprat')
        amp = param.get_value(0, 'Amp')
        width = param.get_value(0, 'Width')
        slope = 0.18
        X = wave / 4
        kapamax = 4 * ((np.pi)**2) * A * np.sin(2 * np.pi * X / wave)
        kapa.append(kapamax)
        d = (amp + width)

        d2 = np.sqrt(d**2 + (wave / 2)**2)
        dist.append(d)
        kdist = kapamax / d
        # print("kapamax",kapamax)
        # print( "dist", d)

        kapadist.append(kdist)

    return kapa, dist, kapadist


def paramlists(labels, Xval, Yval):
    Y = []
    X = []
    for sim in labels:
        param = labelparam(sim)
        Y.append(param.at[0, Yval])
        X.append(param.at[0, Xval])
    return X, Y


def interp(X, Y, Z):
    Z = np.array(Z)
    xmin = min(X)
    xmax = max(X)
    ymin = min(Y)
    ymax = max(Y)
    XX = np.linspace(xmin, xmax, 500)
    YY = np.linspace(ymin, ymax, 500)
    grid_x, grid_y = np.meshgrid(XX, YY)
    print(grid_x)
    print(grid_y)

    grid = griddata((X, Y), Z, (grid_x, grid_y), method='linear')
    return grid_x, grid_y, grid


def regimecontour(labels, X, Y, Z, xlab, ylab, title):
    print(X)
    print(Y)
    print(Z)
    fig, ax = plt.subplots()
    lrange = np.arange(min(Z), max(Z), (max(Z) - min(Z)) / 10)
    ax.tricontour(X, Y, Z, levels=lrange, colors='k')
    cntr = ax.tricontourf(X, Y, Z, levels=lrange, cmap="hot_r")
    ax.set_xlabel(xlab)
    #ax.get_xaxis().set_ticks(np.unique(X))
    ax.set_ylabel(ylab)
    #ax.get_yaxis().set_ticks(np.unique(Y))
    fig.colorbar(cntr)
    plt.title(title)
    plt.show()


def interpcontour(labels, X, Y, Z, xlab, ylab, title):
    fig, ax = plt.subplots()

    ax.contour(X, Y, Z, colors='k')
    cntr = ax.contourf(X, Y, Z, cmap="hot_r")
    ax.set_xlabel(xlab)
    ax.set_ylabel(ylab)
    fig.colorbar(cntr)
    plt.title(title)
    plt.show()

