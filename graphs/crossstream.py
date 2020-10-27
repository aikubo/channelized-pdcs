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

import cm_xml_to_matplotlib as cm
def paramlists(labels, Xval, Yval):
    Y = []
    X = []
    for sim in labels:
        param = labelparam(sim)
        Y.append(param.at[0, Yval])
        X.append(param.at[0, Xval])
    return X, Y

## MAC
#path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"
#os.chdir("/Users/akubo/myprojects/channelized-pdcs/graphs/")
## LAPTOP
path ="/home/akh/myprojects/channelized-pdcs/graphs/processed/"
os.chdir("/home/akh/myprojects/channelized-pdcs/graphs/")

# cross stream
alllabels= [    'AVX4', 'AVZ4', 'AVY4', 'AWX4', 'AWZ4', 'AWY4', 
    'BVX4', 'BVZ4', 'BVY4', 'BWY4', 'BWX4', 'BWZ4', 
    'CVX4', 'CVZ4', 'CWY4', 'CVY4', 'CWX4', 'CWZ4',
    'DVX4', 'DVY4', 'DVZ4', 'DWX4', 'DWY4', 'DWZ4',
    'AVX7', 'AVZ7', 'AVY7', 'AWY7', 'AWX7', 'AWZ7',
    'BVX7', 'BVY7', 'BVZ7', 'BWX7', 'BWY7', 'BWZ7',
    'CVX7', 'CVY7', 'CWX7', 'CVZ7', 'CWZ7', 'CWY7',
    'DVX7', 'DVY7', 'DVY7', 'DWY7', 'DWZ7', 'DWX7',
    'SW7', 'SV4','SW4','SV7'
    ]
cols=['t', 'Udom', 'Uepp', 'Wdom', 'Wepp', 'Vdom', 'Vepp']
colspec= [[1,4], [10,26], [33, 48], [57,70], [79,92], [101,114], [119,135]]
tot, avulsed, buoyant, massout, area, areaout= openmassdist(alllabels, path)
sin=[ i for i in alllabels if "S" not in i]
amprat, wave = paramlists(alllabels, 'Amprat', 'Wave')
amp, vol = paramlists(alllabels, 'Amp', 'Vflux')
width, depth = paramlists(alllabels, 'Width', 'Depth')
inlet, inletrat = paramlists(alllabels, 'Inlet', 'Inletrat')

kapa, dist, kdist = curvat(alllabels)
kdist_norm= [float(x) * float(y)  for x, y in zip(kdist, wave)]
#froude, front=openfroude(alllabels, path)
#cm = cm.make_cmap('red-2.xml')

#shows that the 3 wavlengths have very different behaviors
# increase in crossstream magnitude increases avulsion 

mass=[]
a=[]
b=[]
for sim in alllabels:
    mass.append(avulsed[sim].max())
    a.append(area[sim].max())
    b.append(avulsed[sim].max())

fig,ax=plt.subplots(1,2, sharey=True)
for i in range(2):
    vdom=openmine(alllabels,path, "_cross_stream.txt", cols, cols[(2*i)+1+2], colspec) #1,3,5 
   
    epp=openmine(alllabels,path, "_cross_stream.txt", cols, cols[(2*i)+4], colspec) #2,4,6 
    vdom_s=[]
    ms=[]

    for sim in alllabels:
        vdom_s.append(vdom[sim].max())
        r=vdom[sim].idxmax(axis="columns")
        ms.append(epp[sim].iloc[r])
    print(vdom_s)
    scat=ax[i].scatter(vdom_s, b, c=kdist_norm, cmap=matplotlib.cm.Greys_r)
plt.colorbar(scat)
ax[0].set_ylabel("Overspilled Mass Fraction")
ax[0].set_xlabel("Dominant Velocity V")
ax[1].set_xlabel("Dominant Velocity W")
#ax[0].set_ylim([0.004, 0.016])
#ax[1].set_ylim([0.004, 0.016])
#savefigure("CROSSSTREAM_OCT_buoyant")