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
    ]


amprat, wave = paramlists(alllabels, 'Amprat', 'Wave')
amp, vol = paramlists(alllabels, 'Amp', 'Vflux')
cwidth, depth = paramlists(alllabels, 'Width', 'Depth')
inlet, inletrat = paramlists(alllabels, 'Inlet', 'Inletrat')

size=0.5*((np.array(vol))/10000)**2
#InC, OC, InCAlong, InCPerp, OCAlong, OCPerp
InC, OC, InCAlong, InCPerp, OCAlong, OCPerp=openmomentum(alllabels, path)
tot, avulsed, buoyant, massout, area, areaout= openmassdist(alllabels, path)

fig,ax=plt.subplots(2)

fw,fl=[19/2.54, 11/2.54]
fig.set_size_inches(fw,fl)
fig2,ax2=plt.subplots(2)

for t in range(7):
    print(t)
    # fig,ax=plt.subplots(2)
    #fig2,ax2=plt.subplots(2)
    # ax[0].scatter(np.array(amp)/np.array(cwidth), InC.iloc[t,:])
    # ax[0].scatter(np.array(amp)/np.array(cwidth), OC.iloc[t,:], c="green")
    
    # ax[1].scatter(np.array(amp)/np.array(cwidth), InCAlong.iloc[t,:])
    # ax[1].scatter(np.array(amp)/np.array(cwidth), InCPerp.iloc[t,:], c="red")
    # ax[0].scatter(np.array(amp)/np.array(cwidth), InCPerp.iloc[t,:]+ InCAlong.iloc[t,:], c="gray")
    
    
    #ax2[0].scatter(avulsed.iloc[t,:], InCPerp.iloc[t,:], c= np.array(amp)/np.array(cwidth))
    #c=ax2[1].scatter(avulsed.iloc[t,:], InCAlong.iloc[t,:], c= np.array(amp)/np.array(cwidth))
    
    # ax[0,0].scatter(np.array(amp)/np.array(cwidth), InC.iloc[t,:])
    # ax[1,0].scatter(np.array(amp)/np.array(cwidth), InCAlong.iloc[t,:])
    # ax[2,0].scatter(np.array(amp)/np.array(cwidth), InCPerp.iloc[t,:])
    
    # ax[0,1].scatter(np.array(amp)/np.array(cwidth), OC.iloc[t,:])
    # ax[1,1].scatter(np.array(amp)/np.array(cwidth), OCAlong.iloc[t,:])
    # ax[2,1].scatter(np.array(amp)/np.array(cwidth), OCPerp.iloc[t,:])
#fig2.colorbar(c)

# t=4
# ax[0,0].scatter(np.array(amp)/np.array(width), InC.iloc[t,:], s=size)
# ax[0,0].tick_params(labelsize=8)

# ax[1,0].scatter(np.array(amp)/np.array(width), InCAlong.iloc[t,:], s=size)
# ax[1,0].tick_params(labelsize=8)

# ax[0,1].scatter(np.array(amp)/np.array(width), OC.iloc[t,:], s=size)
# ax[0,1].tick_params(labelsize=8)
# ax[0,1].set_ylim([0,0.2])

# ax[1,1].scatter(np.array(amp)/np.array(width), OCAlong.iloc[t,:], s=size)
# ax[1,1].tick_params(labelsize=8)
# ax[1,1].set_ylim([0,0.05])


# ax[2,0].scatter(np.array(amp)/np.array(width), InCPerp.iloc[t,:], s=size)
# ax[2,0].tick_params(labelsize=8)

# ax[2,1].scatter(np.array(amp)/np.array(width), OCPerp.iloc[t,:], s=size)
# ax[2,1].tick_params(labelsize=8)
# ax[2,1].set_ylim([0,0.10])

t=3
kappa=np.array(amp)/np.array(cwidth) #np.array(inletrat)

x=np.sort(kappa) #np.argsort(kappa)
width=(x[1:]-x[0:-1]) #.8s
width=np.append(width,np.average(width))
o=np.argsort(kappa)
ax[0].scatter(x, InC.iloc[t,o], s=size, edgecolor='black')

ax[1].scatter(x, InCPerp.iloc[t,o], edgecolor='black', s=size, c='green')
ax[1].scatter(x, InCAlong.iloc[t,o], edgecolor='black', s=size, c='red')
ax[0].scatter(x, OC.iloc[t,o], edgecolor='black', s=size)

# ax[1].bar(x, OC.iloc[t,:], width=width)
# ax[1].bar(x, OCPerp.iloc[t,:], width=width)
# ax[1].bar(x, OCAlong.iloc[t,:], bottom=OCPerp.iloc[t,:])


# ax[1,1].set_ylabel("Momentum in Outside Channel Along", fontsize=8)
# ax[2,0].set_ylabel("Momentum in Channel Perp", fontsize=8)
# ax[2,1].set_ylabel("Momentum in Outside Channel Perp", fontsize=8)
ax[1].set_ylabel("In Channel Momemtum", fontsize=8)
ax[0].set_ylabel("Overspill Momentum", fontsize=8)


ax[1].set_xlabel("Normalized Curvature", fontsize=8)


fig.savefig('momentum.eps', dpi=600)

# fig2,ax2=plt.subplots(2)
# ax2[0].scatter(InCPerp.iloc[t,:], InCAlong.iloc[t,:] )

# ax2[1].scatter(InCPerp.iloc[t,:], OC.iloc[t,:], c=InCAlong.iloc[t,:])