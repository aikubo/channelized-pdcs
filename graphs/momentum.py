#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Mar  9 15:50:22 2021

@author: akh
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.font_manager as font_manager
 
import pandas as pd
import seaborn as sns
import math

from slength import *

from openmod import openmomentum
from entrainmod import *
from pltfunc import *
from curv import curvat
from normalize import labelparam
from matplotlib import rcParams
from regime_fnc import paramlists

rcParams['pdf.fonttype'] = 42
rcParams['ps.fonttype'] = 42

path = "/home/akh/myprojects/channelized-pdcs/graphs/processed/"
os.chdir('/home/akh/myprojects/channelized-pdcs/graphs/')

alllabels = [
    'AVX4', 'AVZ4', 'AVY4', 'AWX4', 'AWZ4', 'AWY4', 
    'BVX4', 'BVZ4', 'BVY4', 'BWY4', 'BWX4', 'BWZ4', 
    'CVX4', 'CVZ4', 'CWY4', 'CVY4', 'CWX4', 'CWZ4',
    'DVX4', 'DVY4', 'DVZ4', 'DWX4', 'DWY4', 'DWZ4',
    'AVX7', 'AVZ7', 'AVY7', 'AWY7', 'AWX7', 'AWZ7',
    'BVX7', 'BVY7', 'BVZ7', 'BWX7', 'BWY7', 'BWZ7',
    'CVX7', 'CVY7', 'CWX7', 'CVZ7', 'CWZ7', 'CWY7',
    'DVX7', 'DVY7', 'DVZ7', 'DWY7', 'DWZ7', 'DWX7',
    'SW7','SV4','SW4','SV7']


amprat, wave = paramlists(alllabels, 'Amprat', 'Wave')
amp, vol = paramlists(alllabels, 'Amp', 'Vflux')
width, depth = paramlists(alllabels, 'Width', 'Depth')
inlet, inletrat = paramlists(alllabels, 'Inlet', 'Inletrat')

size=0.5*((np.array(vol))/10000)**2

InC, OC, InCAlong, InCPerp, OCAlong, OCPerp=openmomentum(alllabels, path)
fig,ax=plt.subplots(3,2)

fw,fl=[19/2.54, 11/2.54]
fig.set_size_inches(fw,fl)

kappa=np.array(amp)/np.array(width)
# for t in range(3,6):

#     ax[0,0].scatter(np.array(amp)/np.array(width), InC.iloc[t,:])
#     ax[1,0].scatter(np.array(amp)/np.array(width), InCAlong.iloc[t,:])
#     ax[0,1].scatter(np.array(amp)/np.array(width), OC.iloc[t,:])
#     ax[1,1].scatter(np.array(amp)/np.array(width), OCAlong.iloc[t,:])
#     ax[2,0].scatter(np.array(amp)/np.array(width), InCPerp.iloc[t,:])
#     ax[2,1].scatter(np.array(amp)/np.array(width), OCPerp.iloc[t,:])

t=4
ax[0,0].scatter(np.array(amp)/np.array(width), InC.iloc[t,:], s=size)
ax[0,0].tick_params(labelsize=8)

ax[1,0].scatter(np.array(amp)/np.array(width), InCAlong.iloc[t,:], s=size)
ax[1,0].tick_params(labelsize=8)

ax[0,1].scatter(np.array(amp)/np.array(width), OC.iloc[t,:], s=size)
ax[0,1].tick_params(labelsize=8)
ax[0,1].set_ylim([0,0.2])

ax[1,1].scatter(np.array(amp)/np.array(width), OCAlong.iloc[t,:], s=size)
ax[1,1].tick_params(labelsize=8)
ax[1,1].set_ylim([0,0.05])


ax[2,0].scatter(np.array(amp)/np.array(width), InCPerp.iloc[t,:], s=size)
ax[2,0].tick_params(labelsize=8)

ax[2,1].scatter(np.array(amp)/np.array(width), OCPerp.iloc[t,:], s=size)
ax[2,1].tick_params(labelsize=8)
ax[2,1].set_ylim([0,0.10])


ax[0,0].set_ylabel("Momentum in Channel", fontsize=8)
ax[1,0].set_ylabel("Momentum in Channel Along", fontsize=8)
ax[0,1].set_ylabel("Momentum in Outside Channel", fontsize=8)
ax[1,1].set_ylabel("Momentum in Outside Channel Along", fontsize=8)
ax[2,0].set_ylabel("Momentum in Channel Perp", fontsize=8)
ax[2,1].set_ylabel("Momentum in Outside Channel Perp", fontsize=8)

ax[2,0].set_xlabel("Normalized Curvature", fontsize=8)
ax[2,1].set_xlabel("Normalized Curvature", fontsize=8)



fig.savefig('momentum.eps', dpi=600)

fig2,ax2=plt.subplots(2)
ax2[0].scatter(InCPerp.iloc[t,:], InCAlong.iloc[t,:] )

ax2[1].scatter(InCPerp.iloc[t,:], OC.iloc[t,:], c=InCAlong.iloc[t,:])