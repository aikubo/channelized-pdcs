import numpy as np
import matplotlib.pyplot as plt
import matplotlib.font_manager as font_manager
from matplotlib.offsetbox import (TextArea, DrawingArea, OffsetImage,
                                  AnnotationBbox)

from scipy.interpolate import griddata
from matplotlib import cm 
import pandas as pd
import seaborn as sns
import math 

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

avulsed, buoyant, massout, area = openmassdist(alllabels, path)
# print(area)
# regime(alllabels, avulsed, 'Amp', "Amplitude (m)", "Avulsed Mass", "regime_amp")
# regime(alllabels, avulsed, 'Amprat', "Amplitude Ratio", "Avulsed Mass", "regime_amprat")
# regime(alllabels, avulsed, 'Wave', "Wavelength (m)", "Avulsed Mass", "regime_wave")
# regime(alllabels, avulsed, 'Width', "Width (m)", "Avulsed Mass", "regime_width")
# regime(alllabels, avulsed, 'Inletrat', "Inlet Height/Depth", "Avulsed Mass", "regime_inletrat")

# regime(alllabels, area, 'Amp', "Amplitude (m)", "Area Innundated (m^2)", "regime_amp_area")
# regime(alllabels, area, 'Amprat', "Amplitude Ratio",  "Area Innundated (m^2)", "regime_amprat_area")
# regime(alllabels, area, 'Wave', "Wavelength (m)",  "Area Innundated (m^2)", "regime_wave_area")
# regime(alllabels, area, 'Width', "Width (m)",  "Area Innundated (m^2)", "regime_width_area")
# regime(alllabels, area, 'Inletrat', "Inlet Height/Depth",  "Area Innundated (m^2)", "regime_inletrat_area")

# regime(alllabels, massout, 'Amp', "Amplitude (m)", "Mass Out", "regime_amp_mass")
# regime(alllabels, massout, 'Amprat', "Amplitude Ratio", "Mass Out", "regime_amprat_mass")
# regime(alllabels, massout, 'Wave', "Wavelength (m)", "Mass Out", "regime_wave_mass")
# regime(alllabels, massout, 'Width', "Width (m)", "Mass Out", "regime_width_mass")
# regime(alllabels, massout, 'Inletrat', "Inlet Height/Depth", "Mass Out", "regime_inletrat_mass")

#printlegend(alllabels, 'regimelegend')

def curvat(sim):
    param=labelparam(sim)
    wave = param['Wave']
    A=param['Amprat']
    slope= 0.18
    X = np.arange(0,1212,3)
    kappa=np.empty([404])

    for i in range(0, len(X)):
        t=i*3.0
        
        if "S" in sim: 
            kappa[i]=0 
        else: 
            kappa[i] = (((2*np.pi)**2)*A/wave)*np.sin(2*np.pi*t/wave)*(((2*np.pi)**2)*A/wave)*(np.sin(2*np.pi*t/wave))*(( slope**2 + ( 2*np.pi*A*np.cos(2*np.pi*t/wave))**2 )**(-3/2))
    avg = kappa.mean()
    kappamax= kappa.max()
    return avg, kappamax



amplitudes=['X', 'Y', 'Z']
waves=["A", "B", "C"]


for amp in amplitudes:
    labels=[ x for x in alllabels if amp in x]
    X=[]
    X2=[]
    Y=[]
    Z=[]
    data = area
    for sim in labels: 
        param=labelparam(sim)
        Y.append(param.get_value(0, 'Vflux'))
        #avg, kappamax= curvat(sim)
        A=param.get_value(0, 'Amprat')
        W= param.get_value(0, 'Wave')
        X.append(W)
        X2.append(W)
        avul= data[sim].max()
        Z.append(avul/(1212*900))

    fig,ax=plt.subplots()
    xlab= "Wavelength"
    ylab="Volume Flux"
    lrange=np.arange(min(Z), max(Z), (max(Z)- min(Z))/10)
    ax.tricontour(X,Y,Z, levels=lrange, colors='k')
    cntr= ax.tricontourf( X, Y, Z, levels=lrange, cmap="hot_r") 
    #ax.scatter(X,Y)

    ax.set_xlabel(xlab)
    ax.get_xaxis().set_ticks([0,300,600,900])
    ax.set_ylabel(ylab)
    fig.colorbar(cntr)
    title="Avulsed Mass channel at amprat of "+ amp
    ax.set_title(title)
    plt.show()

#savefigure("regime_area_innundated")
# fig2,ax2=plt.subplots()
# xlab= "Wavelength"
# ylab="Volume Flux"

# ax2.tricontour(X2,Y,Z, levels=lrange, colors='k')
# cntr= ax2.tricontourf( X2, Y, Z, levels=lrange, cmap="RdGy_r") 

# # cp = ax.contour(X, Y, Z)
# # ax.clabel(cp, inline=True, 
# #              fontsize=10, 
# #              cmap='RdGy'))

# ax2.set_xlabel(xlab)
# ax2.set_ylabel(ylab)
# fig2.colorbar(cntr)
# plt.show()