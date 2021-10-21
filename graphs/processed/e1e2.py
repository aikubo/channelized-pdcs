#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Dec  2 15:01:06 2020

@author: akh
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.font_manager as font_manager
 
import pandas as pd
import math

from openmod import *
from entrainmod import *
from curv import curvat
from normalize import labelparam
from matplotlib import rcParams
from regime_fnc import paramlists 

## MAC
#path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"
#os.chdir("/Users/akubo/myprojects/channelized-pdcs/graphs/")
## LAPTOP
path = "/home/akh/myprojects/channelized-pdcs/graphs/processed/"
os.chdir('/home/akh/myprojects/channelized-pdcs/graphs/')

labels=['DVY7']
EP1, EP2, V1, V2, R1, R2, DPU1, DPU2, T1, T2, M1, M2=e1e2(labels, path)
co=['EPP', 'VEL', 'RI', 'DPU', 'T', 'MASS']
time=np.arange(0,40,5)

color='tab:blue'
fig,ax=plt.subplots(2,3)
ax[0][0].plot(time, EP1)
ax[0][0].plot(time, EP2)
ax[0][0].set_ylabel('EPP Out of Channel')
ax2=ax[0][0].twinx()
color='tab:grey'
ax2.plot(time, EP1/EP2, '--', color=color)
ax2.set_ylabel('E1/E2', color=color)
ax2.tick_params(axis='y', labelcolor=color)

ax[0][1].plot(time, V1)
ax[0][1].plot(time, V2)
ax[0][1].set_ylabel('Velocity In Channel')
ax2=ax[0][1].twinx()
color='tab:grey'
ax2.plot(time, V1/V2, '--', color=color)
ax2.set_ylabel('E1/E2', color=color)
ax2.tick_params(axis='y', labelcolor=color)




ax[0][2].plot(time, R1)
ax[0][2].plot(time, R2)
ax[0][2].set_ylabel('Richardson # In Channel')
ax2=ax[0][2].twinx()
color='tab:grey'
ax2.plot(time, R1/R2, '--', color=color)
ax2.set_ylabel('E1/E2', color=color)
ax2.tick_params(axis='y', labelcolor=color)


ax[1][0].plot(time, DPU1)
ax[1][0].plot(time, DPU2)
ax[1][0].set_ylabel('Dynamic Pressure In Channel')
ax2=ax[1][0].twinx()
color='tab:grey'
ax2.plot(time, DPU1/DPU2, '--', color=color)
ax2.set_ylabel('E1/E2', color=color)
ax2.tick_params(axis='y', labelcolor=color)


ax[1][1].plot(time, T1)
ax[1][1].plot(time, T2)
ax[1][1].set_ylabel('Temperature Out of Channel')
ax2=ax[1][1].twinx()
color='tab:grey'
ax2.plot(time, T1/T2, '--', color=color)
ax2.set_ylabel('E1/E2', color=color)
ax2.tick_params(axis='y', labelcolor=color)



ax[1][2].plot(time, M1)
ax[1][2].plot(time, M2)
ax[1][2].set_ylabel('Mass out ')
ax2=ax[1][2].twinx()
color='tab:grey'
ax2.plot(time, M1/M2, '--', color=color)
ax2.set_ylabel('E1/E2', color=color)
ax2.tick_params(axis='y', labelcolor=color)



plt.tight_layout()
