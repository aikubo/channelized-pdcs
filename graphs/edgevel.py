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
labels= ['AVY7',  'AWX7',  'AWZ7'] # #alllabels
labels.sort()
fid='_massbyxxx.txt'
cols=[ 'time', 'XXX', 'massonright', 'massonleft', 'sum']
out='massonright'
colspec= [[1,4], [5,9], [13,29], [32,49], [52,68]]
massR=picktime(labels,path,fid,cols,out, 8, colspec=colspec)

fig, axes = plt.subplots()
palette=setgrl(alllabels, fig, axes, 5, 8)

fid="_edge_vel1.txt"
cols= ["time", "XXX", "perpvel", "W_G"]
out= "perpvel"
colspec= [[1,4], [5,9], [13,29], [32,49], [52,68]]
evel=sumovertime(labels,path,fid,cols,out)
print(evel)
print(massR)
nvel=normalizebywave(evel)
nvel=normalizebyamp(nvel)

nmass=normalizebymass(massR)

#fid= "_edge_vel1.txt"
#edgevel2=openmine(labels, path, fid, cols, out)

#evel= edgevel1/edgevel2
fid="edgexmass"
ylab='Avulsed Mass/Total mass'
xlab='Edge Velocity (velocity/wave/amp *stokes t)'

stokest= (1950)*(5e-5)**2/(18*0.00034)
nvel=nvel*stokest
#plotscatter(labels, fid, evel, massR, ylab, xlab, fig, axes)
axes.set_ylim([0,0.01])
axes.set_xlim([0,0.005])
plotscatter(labels, fid, nvel, nmass, ylab, xlab, fig, axes)