#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Feb  2 11:54:25 2021

@author: akh
"""

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

from slength import *

from openmod import *
from entrainmod import *
from pltfunc import *
from curv import curvat
from normalize import labelparam
from matplotlib import rcParams, colors

## MAC
#path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"
#os.chdir("/Users/akubo/myprojects/channelized-pdcs/graphs/")
## LAPTOP
path = "/home/akh/myprojects/channelized-pdcs/graphs/processed/"
os.chdir('/home/akh/myprojects/channelized-pdcs/graphs/')

#import cm_xml_to_matplotlib as cm


straight = [
    'SW7',
    'SV4',
    'SW4',
    'SV7',
]
alllabels = [
    'AVX4', 'AVZ4', 'AVY4', 'AWX4', 'AWZ4', 'AWY4', 
    'BVX4', 'BVZ4', 'BVY4', 'BWY4', 'BWX4', 'BWZ4', 
    'CVX4', 'CVZ4', 'CWY4', 'CVY4', 'CWX4', 'CWZ4',
    'DVX4', 'DVY4', 'DVZ4', 'DWX4', 'DWY4', 'DWZ4',
    'AVX7', 'AVZ7', 'AVY7', 'AWY7', 'AWX7', 'AWZ7',
    'BVX7', 'BVY7', 'BVZ7', 'BWX7', 'BWY7', 'BWZ7',
    'CVX7', 'CVY7', 'CWX7', 'CVZ7', 'CWZ7', 'CWY7',
    'DVX7', 'DVY7', 'DVZ7', 'DWY7', 'DWZ7', 'DWX7',
    'SW7', 'SV4','SW4','SV7']


Ao100, Ao200, Ao500, OAo100, OAo200, OAo500=exposure(alllabels, path)

def paramlists(labels, Xval, Yval):
    Y = []
    X = []
    for sim in labels:
        param = labelparam(sim)
        Y.append(param.at[0, Yval])
        X.append(param.at[0, Xval])
    return X, Y

Ta, TaO=area_values(alllabels, path)

Ta=np.array(Ta.iloc[0,:])
TaO=np.array(TaO.iloc[0,:])

amprat, wave = paramlists(alllabels, 'Amprat', 'Wave')
amp, vol = paramlists(alllabels, 'Amp', 'Vflux')
width, depth = paramlists(alllabels, 'Width', 'Depth')
inlet, inletrat = paramlists(alllabels, 'Inlet', 'Inletrat')

# fig,ax=plt.subplots(2)
# x= np.array(amp)/np.array(width)*np.array(inletrat)
# ax[0].scatter(x, Ao100.iloc[0,:]/(Ta), c='yellow', marker='o')
# ax[0].scatter(x, Ao200.iloc[0,:]/(Ta), c='orange', marker='^')
# ax[0].scatter(x, Ao500.iloc[0,:]/(Ta), c='r', marker='x')
# ax[0].set_ylabel('Fraction of Area Innundated')


# ax[1].scatter(x, OAo100.iloc[0,:]/(TaO), c='yellow', marker='o')
# ax[1].scatter(x, OAo200.iloc[0,:]/(TaO), c='orange', marker='^')
# ax[1].scatter(x, OAo500.iloc[0,:]/(TaO), c='r', marker='x')
# ax[1].set_xlabel('Normalized Curvature')
# ax[1].set_ylabel('Fraction of Area Innundated')

cmap=colors.ListedColormap(['yellow', 'red'])

fig2,ax2=plt.subplots(2)
x= np.array(amp)/np.array(width)
#ax2[0].scatter(x, Ao100.iloc[1,:]/(Ta), c=inletrat, marker='o', cmap=cmap)
ax2[0].scatter(x, Ao200.iloc[1,:]/(Ta), c=inletrat, marker='^', cmap=cmap)
ax2[0].scatter(x, Ao500.iloc[1,:]/(Ta), c=inletrat, marker='x', cmap=cmap)
ax2[0].set_ylabel('Fraction of Area Innundated')


#ax2[1].scatter(x, OAo100.iloc[1,:]/(TaO), c='yellow', marker='o')
ax2[1].scatter(x, OAo200.iloc[1,:]/(TaO), c=inletrat, marker='^', cmap=cmap)
ax2[1].scatter(x, OAo500.iloc[1,:]/(TaO), c=inletrat, marker='x', cmap=cmap)
ax2[1].set_xlabel('Normalized Curvature')
ax2[1].set_ylabel('Fraction of Area Innundated')


# fig3,ax3=plt.subplots(2)
# x= np.array(amp)/np.array(width)*np.array(inletrat)
# ax3[0].scatter(x, Ao100.iloc[2,:]/(Ta), c='yellow', marker='o')
# ax3[0].scatter(x, Ao200.iloc[2,:]/(Ta), c='orange', marker='^')
# ax3[0].scatter(x, Ao500.iloc[2,:]/(Ta), c='r', marker='x')
# ax3[0].set_ylabel('Fraction of Area Innundated')


# ax3[1].scatter(x, OAo100.iloc[2,:]/(TaO), c='yellow', marker='o')
# ax3[1].scatter(x, OAo200.iloc[2,:]/(TaO), c='orange', marker='^')
# ax3[1].scatter(x, OAo500.iloc[2,:]/(TaO), c='r', marker='x')
# ax3[1].set_xlabel('Normalized Curvature')
# ax3[1].set_ylabel('Fraction of Area Innundated')

