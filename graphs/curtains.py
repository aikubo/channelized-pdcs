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

def curtains(sim,path):
    print(sim)
    fid = "_edge_vel_y.txt"
    pathid=path+sim
    loc= pathid+fid

    widths = [10] * 154
    temp_1=pd.read_fwf(loc, header=None, skiprows=9) #, widths=widths)

    wave, amp, width, depth, inlet, vflux= labelparam(sim)

    lengths= (wave/3.) *np.asarray([ 0.5, 1, 1.5, 2, 3])
    labels = ['0.5l', 'l', '1.5l', '2l', '3l']
    lengths = [x for x in lengths if x < 404]
    lengths=[int(x) for x in lengths ]
    print(lengths)
    fig, ax = plt.subplots()

    for x in lengths: 
        print(x)
        curtain = temp_1.iloc[x]
        j=lengths.index(x)
        height=np.arange(0,462,3)
        slope = 0.18
        dx=3
        IMAX=404
        clearance = 50
        top= slope*dx*(IMAX -x)+clearance-depth
        top=float(top)
        height=height.astype('float32')
        height-=top    
        ax.plot(curtain, height, label=labels[j] )
    ax.legend()
    ax.set_ylim([0,300])
    plt.hlines(depth, -50, 70, colors='k')
    ax.annotate('Top of Channel', xy=(40,depth+1) )
    ax.set_ylabel('Height Above Channel Bottom (m)')
    ax.set_xlabel('Summed Flux (m/s)')
    name= sim+'curtain'
    savefigure(name)

wavelabels= [ 'AVX4', 'BVX4', 'CVX4', 'AVX7', 'BVX7' ] #, 'CVX7' ] 

for sim in wavelabels:
    curtains(sim, path )