import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import pltfunc
from pltfunc import plotallcol as sliceplt

path = "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"
labels=['AV7', 'AW4']

def openslicet(path2file, labels, twant, loc):
    
    
    if loc in "in":
        slicefid='_slice_middle.txt'
    else :
        slicefid='_slice_outsidehalfl.txt'
        labels = [k for k in labels if 'S' not in k]
    
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
        if 'S' in sim: 
            continue

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

def opensliceavg(path2file, labels):

    slicefid='_slice_x200_z150.txt'
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
        for t in range(1,9):
            bottom=(t-1)*klength
            top=t*klength
            df=slice_temp[bottom:top]
            if df.iloc[0,2] < 7.5:
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

slicein_UG, slicein_EPP, slicein_DPU, slicein_TG, slicein_Ri= openslicet(path, labels, 7, 'in')
sliceout_UG, sliceout_EPP, sliceout_DPU, sliceout_TG, sliceout_Ri= openslicet(path, labels, 7, 'out')


fid = 'col_in'
sliceplt(labels, fid, slicein_EPP, slicein_UG, slicein_DPU, slicein_Ri, slicein_TG)

print(slicein_TG)
fid = 'col_out'
sliceplt(labels, fid, sliceout_EPP, sliceout_UG, sliceout_DPU, sliceout_Ri, sliceout_TG)