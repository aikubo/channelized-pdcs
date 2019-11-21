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

## MAC
path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"
os.chdir("/Users/akubo/myprojects/channelized-pdcs/graphs/")
## LAPTOP
#path ="/home/akh/myprojects/channelized-pdcs/graphs/processed/"
#os.chdir("/home/akh/myprojects/channelized-pdcs/graphs/")

## still running 
## 'CVZ7' "CWY7"
alllabels= [ 'AVX4',  'AVZ4',    'BVX4',  'BVZ4',  'BWY4',  'CVX4',  'CVZ4',  'CWY4',  'SW4',
            'AVY4' , 'AWX4',  'AWZ4',  'BVY4',  'BWX4',  'BWZ4',  'CVY4',  'CWX4',  'CWZ4',  'SV4', 
            'AVX7', 'AVZ7',  'BVX7', 'BVZ7','BWY7','CVY7', 'SV7', 'AWY4','AWY7','CWX7','CWZ7',
            'AVY7',  'AWX7',  'AWZ7',  'BVY7',  'BWX7',  'BWZ7',  'CVX7', 'CWY7',  'SW7' ] 
labels= ['AVX4', 'BVX4', 'CVX4' ] #,'AVY7',  'CVY7',  'BVY7'] # #alllabels
time= [1,2,3,4,5,6,7,8]


labels.sort()
fid='_massbyxxx.txt'
cols=[ 'time', 'XXX', 'massonright', 'massonleft', 'sum']
out='massonright'
colspec= [[1,4], [5,9], [13,29], [32,49], [52,68]]
twant=8
massR=picktime(labels,path,fid,cols,out, twant, colspec=colspec)

fig, axes = plt.subplots()
palette=setgrl(alllabels, fig, axes, 5, 8)

fid="_edge_vel.txt"
cols= ["XXX", "perpvel1", "perpvel2", "minval1", "minval2"]
out= "perpvel1"
colspec= [[7, 13], [31,44], [53,63],[74,87],[96,109]]
evel=pd.DataFrame()

for sim in labels: 
    pathid=path+sim
    loc= pathid+fid
    temp_1=pd.read_fwf(loc, header=None, skiprows=9, colspec=colspec)
    temp_1.columns=cols
    evel[sim]=temp_1[out]

print(evel)
print(massR)
cols=['time', 'T_G','U_G','V_G','W_G','U_S1','DPU' ]
TG, UG, DPU= opendenseaverage(labels,path)
sumUG=pd.DataFrame()
for sim in labels:
    sumUG[sim]= sum(UG[sim])
#nvel= evel/sumUG
nmass=normalizebymass(massR)

#fid= "_edge_vel1.txt"
#edgevel2=openmine(labels, path, fid, cols, out)

#evel= edgevel1/edgevel2
fid="edgevel_comparewave"
ylab='Avulsed Mass/Total mass'
xlab='Max Velocity Pointing Out of Curve'

#plotscatter(labels, fid, evel, massR, ylab, xlab, fig, axes)
plotscatter(labels, fid, evel, nmass, ylab, xlab, fig, axes)
