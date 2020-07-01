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
from regime_fnc import *
from scipy.special import ellipk

import cm_xml_to_matplotlib as cm

## MAC
path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"
os.chdir("/Users/akubo/myprojects/channelized-pdcs/graphs/")
## LAPTOP
#path ="/home/akh/myprojects/channelized-pdcs/graphs/processed/"
#os.chdir("/home/akh/myprojects/channelized-pdcs/graphs/")

# cross stream
alllabels= [ 'AVX4',  'AVZ4',    'BVX4',  'BVZ4',  'BWY4',  'CVX4',  'CVZ4',  'CWY4',  'SW4',
            'AVY4' , 'AWX4',  'AWZ4',  'BVY4',  'BWX4',  'BWZ4',  'CVY4',  'CWX4',  'CWZ4',  'SV4',              'AVX7', 'AVZ7',  'BVX7', 'BVZ7','BWY7','CVY7', 'SV7', 'AWY4','AWY7','CWX7','CWZ7',
             'AVY7',  'AWX7',  'AWZ7',  'BVY7',  'BWX7',  'BWZ7',  'CVX7', 'CWY7',  'SW7',  'DVX4', 'DVX7', 'DVY7', 'DVZ7', 'DWY7', 'DWZ7'] 


cols=['t', 'Udom', 'Udomepp', 'Wdom', 'Wepp', 'Vdom', 'Vepp']
vdom=openmine(alllabels,path, "_cross_stream.txt", cols, 'Vdom')

tot, avulsed, buoyant, massout, area = openmassdist(alllabels, path)

sin=[ i for i in alllabels if "S" not in i]
amprat, wave = paramlists(alllabels, 'Amprat', 'Wave')
amp, vol = paramlists(alllabels, 'Amp', 'Vflux')
width, depth = paramlists(alllabels, 'Width', 'Depth')
inlet, inletrat = paramlists(alllabels, 'Inlet', 'Inletrat')

cm = cm.make_cmap('5-discrete-gr-ye-rd-dark.xml')
#froude, front=openfroude(alllabels, path)
#cm = cm.make_cmap('red-2.xml')

#shows that the 3 wavlengths have very different behaviors
# increase in crossstream magnitude increases avulsion 
vdom_sin=[]
vdom_s=[]
msin=[]
ms=[]

for i in alllabels:
    if "S" not in i:
        vdom_sin.append(vdom[i].iloc[6])
        msin.append(avulsed[i].iloc[6])
    else: 
        ms.append(avulsed[i].iloc[6])
        vdom_s.append(vdom[i].iloc[6])

# fig,ax=plt.subplots(1,8, sharey=True)
# for i in range(1,8):
    
#     scat=ax[i-1].scatter(vdom.iloc[i],avulsed.iloc[i] ,c=wave, cmap=cm)
#     #cbar=plt.colorbar(scat)
gic,ax=plt.subplots()
scat=ax.scatter(vdom.max(), avulsed.max(), c=wave, cmap=cm)
cbar=plt.colorbar(scat)
savefigure('crosssstream_maxavulsed')
#plt.show()
