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

from openmod import *
from entrainmod import *
from pltfunc import *

## LAPTOP
path ="/home/akh/myprojects/channelized-pdcs/graphs/processed/"
os.chdir('/home/akh/myprojects/channelized-pdcs/graphs/')

def curvat(labels):
    kapa=[]
    dist=[]
    kapadist=[]
    kapam=pd.DataFrame()
    for sim in labels:
        param=labelparam(sim)
        wave = param.get_value(0,'Wave')
        A=param.get_value(0,'Amprat')
        amp=param.get_value(0,'Amp')
        width=param.get_value(0,'Width')
        slope= 0.18
        X = wave/4
        kapamax= 4*((np.pi)**2)*A*np.sin(2*np.pi*X/wave)

        XX=np.arange(0,1212,3)
        kapax= 4*((np.pi)**2)*A*np.sin(2*np.pi*XX/wave)/(1+2*np.pi*A*np.cos(2*np.pi*XX/wave))**(3/2)
        kapa.append(kapamax)
        d=2*(amp+width)

        d2= np.sqrt(d**2 + (wave/2)**2)
        dist.append(d2)
        kdist=kapamax/d2

        # print("kapamax",kapamax)
        # print( "dist", d)
        kapam[sim]=kapax

        kapadist.append(kdist)
        

    return kapa, dist, kapadist, kapam


XX=np.arange(0,1212,3)
labels=['CVY4']
fid='_massbyxxx.txt'
cols=[ 'time', 'XXX', 'massonright', 'massonleft', 'sum']
out='massonright'
colspec= [[1,4], [5,9], [10,31],[32,49], [52,68]]
twant=8
massR=picktime(labels,path,fid,cols,out, twant, colspec=colspec)
kapa,dist, kapadist, kapam = curvat(labels)

fid="_edge_vel.txt"
cols= ["XXX", "perpvel1", "perpvel2", "minval1", "minval2"]
out= "perpvel1"
colspec= [[7, 13], [31,44], [53,63],[74,87],[96,109]]
edgevel2=openmine(labels, path, fid, cols, out)

for sim in labels:
    param=labelparam(sim)
    wave = param.get_value(0,'Wave')
    A=param.get_value(0,'Amprat')
    amp=param.get_value(0,'Amp')
    width=param.get_value(0,'Width')
    Dkapa= kapam[sim].max()-abs(kapam)
fig,ax=plt.subplots(4)

sin1= amp*np.sin(2*np.pi*XX/wave)+450- width/2
sin2= amp*np.sin(2*np.pi*XX/wave)+450+ width/2
ax[0].plot(XX, sin1, 'k.')
ax[0].plot(XX, sin2, 'k.')
ax[0].set_ylim([0,900])
ax[0].set_xlim([0,1212])
ax[1].plot(XX, massR)
ax[1].set_xlim([0,1212])
ax[2].plot(XX, edgevel2)
ax[2].set_xlim([0,1212])
ax[3].scatter(Dkapa, massR)
plt.show()



