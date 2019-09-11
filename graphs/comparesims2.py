import numpy as np
import matplotlib.pyplot as plt
import pandas as pd


print('hello world')
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
    time=np.arange(2,9)
    print('hello entrainment')
    vol=[]
    for i in range(2,9):
        deltaV= data.iloc[i]-deltaV
        print(deltaV)
        vol.append(deltaV)

    #plt.plot(time,vol)
    #plt.show()
    return vol

def massin_bar(data):
    