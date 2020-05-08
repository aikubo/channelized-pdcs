import os

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

from pltfunc import *
## MAC
path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"
os.chdir("/Users/akubo/myprojects/channelized-pdcs/graphs/")
## LAPTOP
#path ="/home/akh/myprojects/channelized-pdcs/graphs/processed/"
#os.chdir("/home/akh/myprojects/channelized-pdcs/graphs/")
## still running 
## 'CVZ7'
# #alllabels= [ 'AVX4',  'AVZ4',    'BVX4',  'BVZ4',  'BWY4',  'CVX4',  'CVZ4',  'CWY4',  'SW4',
#             'AVY4' , 'AWX4',  'AWZ4',  'BVY4',  'BWX4',  'BWZ4',  'CVY4',  'CWX4',  'CWZ4',  'SV4', 
#             'AVX7', 'AVZ7',  'BVX7', 'BVZ7','BWY7','CVY7', 'SV7', 'AWY4','AWY7','CWX7','CWZ7',
#             'AVY7',  'AWX7',  'AWZ7',  'BVY7',  'BWX7',  'BWZ7',  'CVX7', 'CWY7',  'SW7' ] 

#alllabels.sort()
labels= [  'BVY7' ] 
def openslicet(path2file, labels, twant, loc):
        
    if loc in "in":
        slicefid='_slice_middle.txt'
    elif loc in "half" :
        slicefid='_slice_halfl.txt'
        labels = [k for k in labels if "S" not in k]
    elif loc in "onel" :
        slicefid='_slice_onel.txt'
        labels = [k for k in labels if "S" not in k]
    elif loc in "quart" :
        slicefid='_slice_3quarter_100m.txt'
        labels = [k for k in labels if "S" not in k]
    print(labels)
    
    slice_EPP=pd.DataFrame()
    slice_UG=pd.DataFrame()
    slice_TG=pd.DataFrame()
    slice_Ri=pd.DataFrame()
    slice_DPU=pd.DataFrame()


    UG=[]
    EPP=[]
    TG=[]
    Ri=[]
    DPU=[]

    for sim in labels:
        print(sim)
        slicet=pd.DataFrame()
        fid=path2file+sim
        loc=fid + slicefid
        slice_temp=pd.read_table(loc, header=None, sep= '\s+', skiprows=9)
        col = ['UG', 'DPU', 'TG', 'Ri' ]
        slice_temp.columns = ['time', 'YYY',  'EPP', 'UG', 'DPU', 'TG', 'Ri' ]

        for i in col:
            slicet=slice_temp[slice_temp['time']== twant]
        slicet.reset_index(drop=True, inplace=True)

        UG.append(slicet['UG'])
        EPP.append(slicet['EPP'])
        TG.append(slicet['TG'])
        DPU.append(slicet['DPU'])
        Ri.append(slicet['Ri'])

        del slicet
    slice_UG=pd.concat(UG, axis=1, ignore_index=True)
    slice_EPP=pd.concat(EPP, axis=1, ignore_index=True)
    slice_TG=pd.concat(TG, axis=1, ignore_index=True)
    slice_DPU=pd.concat(DPU, axis=1, ignore_index=True)
    slice_Ri=pd.concat(Ri, axis=1, ignore_index=True)

    slice_UG.columns=labels
    slice_TG.columns=labels
    slice_EPP.columns=labels
    slice_DPU.columns=labels
    slice_Ri.columns=labels

    return slice_UG, slice_EPP, slice_DPU, slice_TG, slice_Ri

def opensliceavg(path2file, labels, loc):
    if loc in "in":
        slicefid='_slice_middle.txt'
    elif loc in "half" :
        slicefid='_slice_halfl.txt'
        labels = [k for k in labels if "S" not in k]
    elif loc in "onel" :
        slicefid='_slice_onel.txt'
        labels = [k for k in labels if "S" not in k]
    elif loc in "quart" :
        slicefid='_slice_3quarter_100m.txt'
        labels = [k for k in labels if "S" not in k]
    print(labels)
    slice_EPP=pd.DataFrame()
    slice_UG=pd.DataFrame()
    slice_TG=pd.DataFrame()
    slice_Ri=pd.DataFrame()
    slice_DPU=pd.DataFrame()


    UG=[]
    EPP=[]
    TG=[]
    Ri=[]
    DPU=[]

    for sim in labels:
        sliceavg=pd.DataFrame()
        fid=path2file+sim
        loc=fid + slicefid
        slice_temp=pd.read_table(loc, header=None, sep= '\s+', skiprows=9)
        col = ['UG', 'DPU', 'TG', 'Ri' ]
        slice_temp.columns = ['time', 'YYY',  'EPP', 'UG', 'DPU', 'TG', 'Ri' ]

        height= slice_temp['YYY'].min()
        klength=int((456-height)/3 +1)
        height_flow= (slice_temp['YYY']-height)
        height_flow=height_flow[0:klength]


        # first split by timestep
        sliceavg=slice_temp[0:klength]
        tavg=0
        for t in range(2,9):
            bottom=(t-1)*klength
            top=t*klength
            df=slice_temp[bottom:top]
            if df.iloc[1,2] < 7.5:
                #add to average
                tavg=tavg+1
                sliceavg = sliceavg+df.values
        # divide by time
        sliceavg=sliceavg/tavg
        sliceavg.reset_index(inplace=True, drop=True)

        UG.append(sliceavg['UG'])
        EPP.append(sliceavg['EPP'])
        TG.append(sliceavg['TG'])
        DPU.append(sliceavg['DPU'])
        Ri.append(sliceavg['Ri'])

        del sliceavg

    slice_UG=pd.concat(UG, axis=1, ignore_index=True)
    slice_EPP=pd.concat(EPP, axis=1, ignore_index=True)
    slice_TG=pd.concat(TG, axis=1, ignore_index=True)
    slice_DPU=pd.concat(DPU, axis=1, ignore_index=True)
    slice_Ri=pd.concat(Ri, axis=1, ignore_index=True)

    slice_UG.columns=labels
    slice_TG.columns=labels
    slice_EPP.columns=labels
    slice_DPU.columns=labels
    slice_Ri.columns=labels

    return slice_UG, slice_EPP, slice_DPU, slice_TG, slice_Ri

slicein_UG, slicein_EPP, slicein_DPU, slicein_TG, slicein_Ri= opensliceavg(path, labels,  'in')
sliceout_UG, sliceout_EPP, sliceout_DPU, sliceout_TG, sliceout_Ri= opensliceavg(path, labels, 'one')
sliceouth_UG, sliceouth_EPP, sliceouth_DPU, sliceouth_TG, sliceouth_Ri= opensliceavg(path, labels, 'half')
sliceoutq_UG, sliceoutq_EPP, sliceoutq_DPU, sliceoutq_TG, sliceoutq_Ri= opensliceavg(path, labels, 'quart')

fig, axes= plt.subplots(1,4, sharey=True, sharex=False)
fig.set_figheight(6)
fig.set_figwidth(7)
plt.ion()
plt.show()

fid="col_all_paper"
# fid = 'col_onel_comparewave'
plotallcol(fig, axes, labels, fid, sliceout_EPP, sliceout_UG, sliceout_DPU, sliceout_Ri, sliceout_TG)
plt.draw()
plt.pause(15)
# blue one l

#fid = 'col_half_comparewave'
plotallcol(fig, axes, labels, fid, sliceouth_EPP, sliceouth_UG, sliceouth_DPU, sliceouth_Ri, sliceouth_TG)
plt.draw()
plt.pause(15)



#fid = 'col_quart_comparewave'
plotallcol(fig, axes, labels, fid, sliceoutq_EPP, sliceoutq_UG, sliceoutq_DPU, sliceoutq_Ri, sliceoutq_TG)
plt.draw()
plt.pause(15)
#fid = 'col_in_comparewave'
plotallcol(fig, axes, labels, fid, slicein_EPP, slicein_UG, slicein_DPU, slicein_Ri, slicein_TG)
plt.draw()
plt.pause(20)
plt.savefig('slicesPAPERALL_AVERAGE.eps', dpi=600)