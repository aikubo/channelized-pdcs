import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

labels=[ "AV4", "CV4", "BW4", "CW4", "SW4", "bw7", "AV7", "CV7", "SV4" ]



def openlabel(label):
    path2file = '/home/akh/channelized-pdcs/graphs/processed/';
    nosefid='_nose.txt'
    froudefid='_froude.txt'
    slicefid='_slice_x200_z150.txt'
    entrainmentfid='_entrainment.txt'
    massfid='_massinchannel.txt'
    avgf='_average_all.txt'
    fid=path2file + label

    # nose
    locnose=fid + nosefid
    nose=pd.read_fwf(locnose, header=9)

    # froude
    loc=fid + froudefid
    froude=pd.read_fwf(loc, header=9)

    # ent
    loc=fid + entrainmentfid
    ent=pd.read_fwf(loc)

    # slice
    #loc=fid + slicefid
    #col=pd.read_fwf(loc, header=9)

    # massin
    loc=fid + massfid
    massin=pd.read_fwf(loc, header=9)

    # average
    loc=fid + avgf
    avg=pd.read_fwf(loc, header=9)

    return nose, froude, ent, massin, avg 

def entrain(data):
    timesteps=np.arrange(1,8)
    deltaV=np.array(7)
    for i in range(1,7):
        deltaV[i]=(data.iloc[i] - data.iloc[i-1] 
        print('hello world')

    plt.plot(time, deltaV)
    plt.show()
    return detlaV