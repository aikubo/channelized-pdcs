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
from smoothmod import *


import scipy.fftpack

labels = ["AVX4", "AVY4", "AVZ4" ]#, "BVX4", "BVY4", "BVZ4"]
## MAC
#path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"

## LAPTOP
path ="/home/akh/myprojects/channelized-pdcs/graphs/processed/"


massR, massL=openmassxxx(labels,path)
fid="massbyxxxL"
ylab="Mass (kg)"
xlab="Distance (m)"

massR_smooth=pd.DataFrame()
sumR=[]
F=pd.DataFrame()

for sim in labels:
    mass=massR[sim]
    mass_smooth=smooth(mass)
    massR_smooth[sim]=mass_smooth 

    N= 404
    dx = 3
    yf= scipy.fftpack.fft(mass)
    xf= np.linspace(0.0, 1212, N/2)

    fig, ax = plt.subplots()
    ax.plot(xf, 2.0/N * np.abs(yf[:N//2]))
    plt.show()

    intmass=mass.sum()
    sumR.append(intmass)


xxx=np.arange(0,1212,3)
fig, ax= plt.subplots()
plottogether2(fid, massR_smooth, xxx, ylab,xlab, fig, ax)

fid="summass"
fig, ax= plt.subplots()
x= [0.09, 0.15, 0.20]
print(sumR)
xlab ="Amplitude Ratio"
plotscatter(labels, fid, x, sumR, ylab,xlab, fig, ax)