#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Oct 23 13:08:17 2020

@author: akh
"""

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Oct  9 15:51:15 2020

@author: akh
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.font_manager as font_manager
from cycler import cycler
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


labels = [
    'AVX4', 'AVZ4', 'AVY4', 'AWX4', 'AWZ4', 'AWY4', 
    'BVX4', 'BVZ4', 'BVY4', 'BWY4', 'BWX4', 'BWZ4', 
    'CVX4', 'CVZ4', 'CWY4', 'CVY4', 'CWX4', 'CWZ4',
    'DVX4', 'DVY4', 'DVZ4', 'DWX4', 'DWY4', 'DWZ4',
    'AVX7', 'AVZ7', 'AVY7', 'AWY7', 'AWX7', 'AWZ7',
    'BVX7', 'BVY7', 'BVZ7', 'BWX7', 'BWY7', 'BWZ7',
    'CVX7', 'CVY7', 'CWX7', 'CVZ7', 'CWZ7', 'CWY7',
    'DVX7', 'DVY7', 'DVY7', 'DWY7', 'DWZ7', 'DWX7',  
    'SW7', 'SV4','SW4','SV7', 'uncon']

alllabels=['SW7', 'SV4','SW4','SV7', 'uncon']
froudefid='_froude.txt'
frcols= ['time', 'AvgU','AvgEP','AvgT','Froude','Front',' Width','Height' ]
head=openmine(alllabels, path, froudefid, frcols, 'Height')
fr=openmine(alllabels, path, froudefid, frcols, 'Froude')
bulk_ent, med_ent, dense_ent = openent(alllabels,path)
avgTG, avgUG, avgdpu, avgWG, avgEPP, avgrho=openaverage(alllabels, path)
ent= entrain(alllabels, bulk_ent)
davgTG, davgUG, davgdpu, davgWG, davgEPP, davgrho=opendenseaverage(alllabels, path)

fig, ax=plt.subplots(2,2)

time=np.arange(0,40, 5)
time2=np.arange(5,40, 5)

colors=[(0.99609375, 0.3984375, 0.3984375), 
          (0.796875, 0.0, 0.99609375),
          (0.59765625, 0.99609375, 0.0)]

colors2=[(0.99609375, 0.3984375, 0.3984375), 
          (0.796875, 0.0, 0.99609375),
          (0.59765625, 0.99609375, 0.0), 
          (0.99609375, 0.3984375, 0.3984375), 
          (0.796875, 0.0, 0.99609375),
          (0.59765625, 0.99609375, 0.0)]

plt.rc('axes', prop_cycle=(cycler(color=colors2) +
                           cycler(linestyle=['-','-','-', '--', '--','--'])))
#ax[0,0].set_prop_cycle(color=colors, lw=[])
ax[0,0].plot(time, fr)

#ax[0,1].set_prop_cycle('color', colors)
#ax[0,1].plot(head, bulk_ent)
ax[0,1].plot(time2, davgUG)

#ax[1,0].set_prop_cycle('color', colors)
ax[1,0].plot(time2, avgrho)

#ax[1,1].set_prop_cycle('color', colors)
ax[1,1].plot(time, np.log(bulk_ent))
ax[1,1].plot(time, np.log(dense_ent))

plt.legend(alllabels)


# alllabels=['AVY7', 'BVY7', 'CVY7']

# spillEPP, spillRho, spillTG, spillUG, spilldpu=openspillavg(alllabels,path)
# tot, avulsed, buoyant, massout, area, areaout= openmassdist(alllabels, path)

# fig1,ax2=plt.subplots(1,2)
# ax2[0].plot(time2, avulsed)
# ax2[1].plot(time2,buoyant)

# fig, ax=plt.subplots(2,2)
# ax[0,0].set_ylabel('Temperature (C)')
# ax[0,1].set_ylabel('Velocity (m/s)')
# ax[1,0].set_ylabel('Density (kg/m3)')
# ax[1,1].set_ylabel('Dynamic Pressur (kPa)')

# ax[1,0].set_xlabel('Time (s)')
# ax[1,1].set_xlabel('Time (s)')


# ax[0,0].plot(time2, spillTG.iloc[1:8])

# #ax[0,1].set_prop_cycle('color', colors)
# ax[0,1].plot(time2, spillUG.iloc[1:8])
# #ax[0,1].plot(time2, )

# #ax[1,0].set_prop_cycle('color', colors)
# ax[1,0].plot(time2, spillRho.iloc[1:8])

# #ax[1,1].set_prop_cycle('color', colors)
# ax[1,1].plot(time2, spilldpu.iloc[1:8]/1000)
# #ax[1,1].plot(time, np.log(dense_ent))
# plt.legend(alllabels)
# plt.tight_layout()
# plt.savefig('spillavg.svg')