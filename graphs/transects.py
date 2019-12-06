import numpy as np
import matplotlib.pyplot as plt
import matplotlib.font_manager as font_manager
from matplotlib.offsetbox import (TextArea, DrawingArea, OffsetImage,
                                  AnnotationBbox)
from matplotlib import cm 
import pandas as pd
import seaborn as sns

from openmod import *
from entrainmod import *
from pltfunc import *
from normalize import *
import os 
import math

## MAC
#path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"
#os.chdir("/Users/akubo/myprojects/channelized-pdcs/graphs/")
## LAPTOP
path ="/home/akh/myprojects/channelized-pdcs/graphs/processed/"
os.chdir("/home/akh/myprojects/channelized-pdcs/graphs/")

alllabels= [ 'AVX4',  'AVZ4',    'BVX4',  'BVZ4',  'BWY4',  'CVX4',  'CVZ4',  'CWY4',  'SW4',
            'AVY4' , 'AWX4',  'AWZ4',  'BVY4',  'BWX4',  'BWZ4',  'CVY4',  'CWX4',  'CWZ4',  'SV4', 
            'AVX7', 'AVZ7',  'BVX7', 'BVZ7','BWY7','CVY7', 'SV7', 'AWY4','AWY7','CWX7','CWZ7',
            'AVY7',  'AWX7',  'AWZ7',  'BVY7',  'BWX7',  'BWZ7',  'CVX7', 'CWY7',  'SW7' ] 
labels= [ 'BVY4']


TG3=pd.DataFrame()
TG6=pd.DataFrame()
TG9=pd.DataFrame()
TG3_2=pd.DataFrame()
TG6_2=pd.DataFrame()
TG9_2=pd.DataFrame()

for sim in labels: 
    pathid=path+sim+'_transect.txt'
    temp=pd.read_fwf(pathid, header=None, skiprows=9)
    TG3[sim]=temp.iloc[:,3]-273
    TG6[sim]=temp.iloc[:,4]-273
    TG9[sim]=temp.iloc[:,5]-273

    TG3_2[sim]=temp.iloc[:,12]-273
    TG6_2[sim]=temp.iloc[:,13]-273
    TG9_2[sim]=temp.iloc[:,14]-273

avgTG, avgUG, avgdpu= opendenseaverage(labels, path)
froude, front= openfroude(labels,path)
dist = np.arange(0,906,3)

tg1= TG3_2.rolling(15, win_type=None,min_periods=1).mean()
tg2= TG6_2.rolling(15, win_type=None,min_periods=1).mean()
tg3= TG9_2.rolling(15, win_type=None,min_periods=1).mean()
print(tg1)
param= labelparam(labels)

wave=param.get_value(0, "Wave")
transects=[0.5*600, 0.75*600, 1*600]
fig,ax=plt.subplots(2)
ax[0].plot(dist, tg1)
ax[0].plot(dist, tg2)
ax[0].plot(dist, tg3)
ax[0].set_ylabel('Temperature (C)')
ax[0].set_xlabel("Distance from edge of channel (m)")
ax[0].set_xlim([0,450])
plottogether2(labels,  'tempfromchanel' , avgTG, front, "Temperature (C)", 'Down Valley Distance (m)', fig, ax[1])
ax[1].scatter(transects[0],TG3_2.max())
ax[1].scatter(transects[1], TG6_2.max())
ax[1].scatter(transects[2], TG9_2.max())
ax[1].set_ylim([300,600])
plt.show()

# print(avgTG)