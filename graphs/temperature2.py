#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Jul 26 16:37:09 2020

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
from matplotlib import rcParams

## MAC
#path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"
#os.chdir("/Users/akubo/myprojects/channelized-pdcs/graphs/")
## LAPTOP
path = "/home/akh/myprojects/channelized-pdcs/graphs/processed/"
os.chdir('/home/akh/myprojects/channelized-pdcs/graphs/')

#import cm_xml_to_matplotlib as cm

# alllabels = [
#     'AVX4', 'AVZ4', 'AVY4', 'AWX4', 'AWZ4', 'AWY4', 
#     'BVX4', 'BVZ4', 'BVY4', 'BWY4', 'BWX4', 'BWZ4', 
#     'CVX4', 'CVZ4', 'CWY4', 'CVY4', 'CWX4', 'CWZ4',
#     'DVX4', 'DVY4', 'DVZ4', 'DWX4', 'DWY4', 'DWZ4',
#     'AVX7', 'AVZ7', 'AVY7', 'AWY7', 'AWX7', 'AWZ7',
#     'BVX7', 'BVY7', 'BVZ7', 'BWX7', 'BWY7', 'BWZ7',
#     'CVX7', 'CVY7', 'CWX7', 'CVZ7', 'CWZ7', 'CWY7',
#     'DVX7', 'DVY7', 'DVY7', 'DWY7', 'DWZ7', 'DWX7']
alllabels=['BVY7']
schan=['SV4', 'SW4', 'SW7', 'SV7', 'uncon']
alllabels.sort()
print(alllabels)

TG, UG, dpu, avgW= openaverage(alllabels, path)
dTG, dUG, ddpu, davgW= opendenseaverage(alllabels, path)

spillTG, spillUG, spilldpu, spillWG, dspillTG, dspillWG, dspillUG, dspilldpu=openspillavg(alllabels, path)
time=np.arange(0,40,5)

bottom=time
xx=dTG
o=TG

# for i in range(len(xx)):
#     print(i)
#     xs=[bottom[i], bottom[i]]
#     ys=[xx.iloc[i], o.iloc[i]]
#     plt.plot(xs,ys)
plt.plot(bottom, xx, 'x-')
plt.plot(bottom, o, 'o-')
plt.plot(bottom, spillTG, "*-")
plt.plot(bottom, dspillTG, "*-")
plt.xlabel('Time')
plt.ylabel('Temperature')