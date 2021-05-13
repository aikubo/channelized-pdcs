#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon May 10 23:25:50 2021

@author: akh
"""
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
    # 'AVX4', 'AVZ4', 'AVY4', 'AWX4', 'AWZ4', 'AWY4', 
    # 'BVX4', 'BVZ4', 'BVY4', 'BWY4', 'BWX4', 'BWZ4', 
    # 'CVX4', 'CVZ4', 'CWY4', 'CVY4', 'CWX4', 'CWZ4',
    # 'DVX4', 'DVY4', 'DVZ4', 'DWX4', 'DWY4', 'DWZ4',
    'AVX7', 'AVZ7', 'AVY7', 'AWY7', 'AWX7', 'AWZ7',
    'BVX7', 'BVY7', 'BVZ7', 'BWX7', 'BWY7', 'BWZ7',
    'CVX7', 'CVY7', 'CWX7', 'CVZ7', 'CWZ7', 'CWY7',
    'DVX7', 'DVY7', 'DVZ7', 'DWY7', 'DWZ7', 'DWX7',
    ]


amprat, wave = paramlists(alllabels, 'Amprat', 'Wave')
amp, vol = paramlists(alllabels, 'Amp', 'Vflux')
cwidth, depth = paramlists(alllabels, 'Width', 'Depth')
inlet, inletrat = paramlists(alllabels, 'Inlet', 'Inletrat')
kappa=np.array(amp)/np.array(cwidth)
size=0.5*((np.array(vol))/10000)**2
#InC, OC, InCAlong, InCPerp, OCAlong, OCPerp
InC, OC, InCAlong, InCPerp, OCAlong, OCPerp=openmomentum(alllabels, path)
tot, avulsed, buoyant, massout, area, areaout= openmassdist(alllabels, path)
time=np.arange(0,35,5)
fig,ax=plt.subplots()



n=len(np.unique(np.unique(kappa)))

c=cm.viridis(np.linspace(0, 1, n))

for i in range(len(alllabels)):
    cloc=np.where(np.unique(kappa)==kappa[i])[0][0]
    
    scat=ax.scatter(InCPerp[alllabels[i]],avulsed[alllabels[i]], color=c[cloc], s=time*2)
    
#ax.set_ylim([0,0.0000025])

