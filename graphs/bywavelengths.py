import numpy as np
import matplotlib.pyplot as plt
import matplotlib.font_manager as font_manager
from matplotlib.offsetbox import (TextArea, DrawingArea, OffsetImage,
                                  AnnotationBbox)
from matplotlib import cm 
import pandas as pd
import seaborn as sns

from openmod import *
from pltfunc import *
from normalize import *

import os



## 'AWY4','AWY7','CNY7','CVZ7','CWX7','CWZ7',
alllabels= [ 'AVX4',  'AVZ4',    'BVX4',  'BVZ4',  'BWY4',  'CVX4',  'CVZ4',  'CWY4',  'SW4',
            'AVY4' , 'AWX4',  'AWZ4',  'BVY4',  'BWX4',  'BWZ4',  'CVY4',  'CWX4',  'CWZ4',  'SV4', 
            'AVX7', 'AVZ7',    'BVX7',  'BVZ7',  'BWY7',    'CVY7',     'SV7',
            'AVY7',  'AWX7',  'AWZ7',  'BVY7',  'BWX7',  'BWZ7',  'CVX7',    'CWY7',  'SW7' ] 
alllabels.sort()
waves=["A", "B", "C", "S"]
## MAC
path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"
os.chdir("/Users/akubo/myprojects/channelized-pdcs/graphs/")
## LAPTOP
#path ="/home/akh/myprojects/channelized-pdcs/graphs/processed/"

def subplotsbywave(path, fid, datacol, out, pltby, pid, xlab, ylab):
    
    fig, axes = plt.subplots(1,4, sharey=True)
    palette=setgrl(alllabels, fig, axes, 4, 8)
    for i in waves:
        labels=[j for j in alllabels if i in j]
        print(labels)
        loc=waves.index(i)
        ax=axes[loc]
        data=openmine(labels, path, fid, datacol, out)
        plottogether2(pid, data, pltby, ylab, xlab, fig, ax)
    
    axes[0].set_ylabel(ylab)

    fig.legend(    # The line objects
            bbox_to_anchor=(1.01, 0.9), #outside on right
            labels=alllabels,   # The labels for each line
            #loc="center right",   # Position of legend
            #borderaxespad=0.5,    # Small spacing around legend box
            title="Geometries",  # Title for the legend
            )
    plt.show()
    #savefigure(pid)

def xxxplotsbywave(path, fid, datacol, out, pid, xlab, ylab):
    
    #path ="/home/akh/myprojects/channelized-pdcs/graphs/processed/"
    fig, axes = plt.subplots(1,4, sharey=True)
    palette=setgrl(alllabels, fig, axes, 5, 8)
    t=5
    for i in waves:
        labels=[j for j in alllabels if i in j]
        print(labels)
        loc=waves.index(i)
        ax=axes[loc]
        data=openmine(labels, path, fid, datacol, out)
        pltbytimebyx(data, t, fig, ax)
    
    axes[0].set_ylabel(ylab)

    fig.legend(    # The line objects
            bbox_to_anchor=(1.01, 0.9), #outside on right
            labels=alllabels,   # The labels for each line
            #loc="center right",   # Position of legend
            #borderaxespad=0.5,    # Small spacing around legend box
            title="Geometries",  # Title for the legend
            )
    #plt.show()
    savefigure(pid)

def xxxplotsnorm(path, fid1, datacol1, out1, fid2, datacol2, out2, pid, xlab, ylab):
    
    #path ="/home/akh/myprojects/channelized-pdcs/graphs/processed/"
    fig, axes = plt.subplots(1,4, sharey=True)
    palette=setgrl(alllabels, fig, axes, 5, 8)
    t=4
    for i in waves:
        labels=[j for j in alllabels if i in j]
        print(labels)
        loc=waves.index(i)
        ax=axes[loc]
        data1=openmine(labels, path, fid1, datacol1, out1)
        data2=openmine(labels, path, fid2, datacol2, out2)
        data=data1/data2
        pltbytimebyx(data, t, fig, ax)
    
    axes[0].set_ylabel(ylab)

    fig.legend(    # The line objects
            bbox_to_anchor=(1.01, 0.9), #outside on right
            labels=alllabels,   # The labels for each line
            #loc="center right",   # Position of legend
            #borderaxespad=0.5,    # Small spacing around legend box
            title="Geometries",  # Title for the legend
            )
   # plt.show()
    savefigure(pid)

time=[0,5,10,20,25,30,35,40]

fid1='_KEbyx.txt'
datacol1=['KE']
out1='KE'

fid2='_PEbyx.txt'
datacol2=['PE']
out2='PE'

pid='KPsubplots'
xlab="X (m)"
ylab="KE / PE "

xxxplotsnorm(path, fid1, datacol1, out1, fid2, datacol2, out2, pid, xlab, ylab)


fid='_KEbyx.txt'
datacol=['KE']
out='KE'
pid='KEsubplots'
xlab="X (m)"
ylab="Kinetic Energy (J)"

xxxplotsbywave(path, fid, datacol, out, pid, xlab, ylab)

fid='_PEbyx.txt'
datacol=['perpvel']
out='perpvel'
pid='PEsubplots'
xlab="X (m)"
ylab="Potential Energy (J)"

xxxplotsbywave(path, fid, datacol, out, pid, xlab, ylab)

fid='_dpu_peak.txt'
datacols=['time', 'peak','XXXin', 'ZZZin', 'peakin', 'XXXout', 'ZZZout','peakout']
out='peakout'
pid='peakinsubplots'
xlab="Time (s)"
ylab="Dynamic Pressure (Pa)"

subplotsbywave(path, fid, datacols, out, time, pid, xlab, ylab)


fid='_massbyxxx.txt'
datacols=[ 't', 'XXX', 'massonright', 'massonleft']
out='massonright'
pid='massoutbyxxxinsubplots'
xlab="X (m)"
ylab="Mass out of the channel (kg)"

fig, axes = plt.subplots(1,4, sharey=True)
palette=setgrl(alllabels, fig, axes, 5, 8)
t=7

for i in waves:
    labels=[j for j in alllabels if i in j]
    print(labels)
    data1=openmine(labels, path, fid, datacols, 'massonright')
    data2=openmine(labels, path, fid, datacols, 'massonleft')
    data= data1+data2
    print(data)
    loc=waves.index(i)
    ax=axes[loc]
    pltbytimebyx(data, t, fig, ax)
savefigure(pid)
#plt.show()