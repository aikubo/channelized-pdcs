import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from astropy.io import ascii


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
    loc=fid + nosefid
    nose=pd.read_fwf(loc, header=None, skiprows=9)

    # froude
    loc=fid + froudefid
    froude=pd.read_fwf(loc, header=None, skiprows=9)
    froude.columns=['time', 'AvgU','AvgEP','AvgT','Froude',' Front',' Width','Height' ]
    # ent
    loc=fid + entrainmentfid
    ent=pd.read_fwf(loc, header=None, skiprows=9)
    ent.columns=['time', 'bulk', 'medium', 'dense']

    # massin
    loc=fid + massfid
    massin=pd.read_fwf(loc, header=None, skiprows=9)
    massin.columns=['time', 'Total Mass (m^3)', 'Elutriated %', 'Med % ', 'Dense %', 'InChannel', ' WidthChannel', ' 0ScaleH', ' ScaleH', ' 2ScaleH']   

    # average
    loc=fid + avgf
    avg=pd.read_fwf(loc, header=None, skiprows=9)
    avg.columns = ['time', 'T_G','U_G','V_G','W_G','U_S1','DPU'  ]

    return nose, froude, ent, massin, avg

def entrain(data):
    print('hello entrainment')
    vol=[]
    for i in range(1,8):
        deltaV= data.bulk[i]-data.bulk[i-1]
        #print(deltaV)
        vol.append(deltaV)

    #plt.plot(time,vol)
    #plt.show()
    return vol

nose, froude, ent, massin, avg = openlabel("AV4")

vol=entrain(ent)
print(vol)
#def massin_bar(data):
    