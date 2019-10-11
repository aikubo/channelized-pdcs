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


def regime(data, ylab):
    fig,axes=plt.subplots(3)
    setgrl(fig,axes, 6, 4)
    palette=setcolorandstyle(labels)

    for sim in labels:
        i=labels.index(sim)
        c=palette[i]      
        wave, width, depth, inlet, vflux = labelparam(sim)
        end = data.loc[data.index[-1], sim]
        axes[0].scatter(wave, end, color=c)
        axes[1].scatter(width, end, color=c)
        axes[2].scatter(vflux, end, color=c)

    for i in range(len(axes)):
        axes[i].autoscale()
        axes[i].set_ylabel(ylab)

    axes[0].set_xlabel("Wavelength")
    axes[1].set_xlabel("Width")
    axes[2].set_xlabel("Volume Flux")
    labelsubplots(axes, 'uleft')
    plt.show()

# now plot based on label 

#regime(1-inchannelmass, "Avulsed Mass %")

def regime2(data, ylab):
    fig,axes=plt.subplots()
    setgrl(fig,axes, 4,4)
    palette=setcolorandstyle(labels)
    lamb=[]
    vei=[]
    end =[] 

    for sim in labels:
        wave, width, depth, inlet, vflux = labelparam(sim)
        end.append(data.loc[data.index[-1], sim])
        lamb.append(wave)
        vei.append(vflux)

    vmin=min(vei)
    vmax=max(vei)
    cs=axes.scatter(lamb, end, s=40, c=vei, cmap=cm.jet, vmin=vmin, vmax=vmax)
       # axes[1].scatter(width, end, color=c)
        #axes[2].scatter(vflux, end, color=c)

    plt.colorbar(cs)
    axes.autoscale()
    axes.set_ylabel(ylab)

    axes.set_xlabel("Wavelength")
    #axes[1].set_xlabel("Width")
    #axes[2].set_xlabel("Volume Flux")
    #labelsubplots(axes, 'uleft')
    savefigure("regime2")

#regime2(avulseddense, "Avulsed Mass %")