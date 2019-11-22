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


def regime(labels, data, param, xlab, ylab, fid):
    fig,axes=plt.subplots()
    setgrl(labels, fig,axes, 6, 4)
    palette=setcolorandstyle(labels)

    for sim in labels:
        i=labels.index(sim)
        c=palette[i]      
        initialcond = labelparam(sim)
        X= initialcond[param]
        end = data.loc[data.index[-1], sim]
        print(X)
        print(end)
        axes.scatter(X, end, color=c)

    axes.set_xlabel(param)
    axes.set_ylabel(ylab)
    savefigure(fid)

#regime2(avulseddense, "Avulsed Mass %")
## MAC
path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"
os.chdir("/Users/akubo/myprojects/channelized-pdcs/graphs/")
## LAPTOP
#path ="/home/akh/myprojects/channelized-pdcs/graphs/processed/"

alllabels= [ 'AVX4',  'AVZ4',    'BVX4',  'BVZ4',  'BWY4',  'CVX4',  'CVZ4',  'CWY4',  'SW4',
            'AVY4' , 'AWX4',  'AWZ4',  'BVY4',  'BWX4',  'BWZ4',  'CVY4',  'CWX4',  'CWZ4',  'SV4', 
            'AVX7', 'AVZ7',  'BVX7', 'BVZ7','BWY7','CVY7', 'SV7', 'AWY4','AWY7','CWX7','CWZ7',
            'AVY7',  'AWX7',  'AWZ7',  'BVY7',  'BWX7',  'BWZ7',  'CVX7', 'CWY7',  'SW7' ] 

alllabels.sort()

avulsed, buoyant, massout = openmassdist(alllabels, path)

regime(alllabels, avulsed, 'Amp', "Amplitude (m)", "Avulsed Mass", "regime_amp")
regime(alllabels, avulsed, 'Amprat', "Amplitude Ratio", "Avulsed Mass", "regime_amprat")
regime(alllabels, avulsed, 'Wave', "Wavelength (m)", "Avulsed Mass", "regime_wave")
regime(alllabels, avulsed, 'Width', "Width (m)", "Avulsed Mass", "regime_width")
regime(alllabels, avulsed, 'Inletrat', "Inlet Height/Depth", "Avulsed Mass", "regime_inletrat")