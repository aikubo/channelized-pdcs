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
#path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"

## LAPTOP
path ="/home/akh/myprojects/channelized-pdcs/graphs/processed/"

def subplotsbywave(fid, datacol, out, pltby, pid, xlab, ylab):
    path ="/home/akh/myprojects/channelized-pdcs/graphs/processed/"
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

def xxxplotsbywave(fid, datacol, out, pid, xlab, ylab):
    path ="/home/akh/myprojects/channelized-pdcs/graphs/processed/"
    fig, axes = plt.subplots(1,4, sharey=True)
    palette=setgrl(alllabels, fig, axes, 4, 8)
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

time=[0,5,10,20,25,30,35,40]

fid='_KEbyx.txt'
datacol=['perpvel']
out='perpvel'
pid='perpvelinsubplots'
xlab="X (m)"
ylab="Outward Velocity (m/s)"

xxxplotsbywave(fid, datacol, out, pid, xlab, ylab)

#subplotsbywave(fid, datacols, out, time, pid, xlab, ylab)


fid='_dpu_peak.txt'
datacols=['time', 'peak','XXXin', 'ZZZin', 'peakin', 'XXXout', 'ZZZout','peakout']
out='peakout'
pid='peakinsubplots'
xlab="Time (s)"
ylab="Dynamic Pressure (Pa)"

#subplotsbywave(fid, datacols, out, time, pid, xlab, ylab)