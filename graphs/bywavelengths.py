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

alllabels= [ "AVY4","AWX4", "AWY4", "AVY7", "BVY4", "BWX4", "CVY4", "CWX4", "SV4", "SW4", "BVY7", "CWY7", "CWY4", "SW7", "SV7"]
alllabels.sort()
waves=["A", "B", "C", "S"]
## MAC
path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"

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
    plt.show()
    #savefigure(pid)

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
    plt.show()
    #savefigure(pid

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
out='massonleft'
pid='massoutbyxxxinsubplots'
xlab="X (m)"
ylab="Mass out of the channel (kg)"

xxxplotsbywave(path, fid, datacols, out, pid, xlab, ylab)

