import numpy as np
import matplotlib.pyplot as plt
import pandas as pd



def labelparam(label):
    if "A" in label:
        wave = 300
    elif "B" in label:
        wave = 600
    elif "C" in label:
        wave = 900
    elif "D" in label:
        wave = 1200
    elif "E" in label:
        wave = 2400
    else:
        wave = 0 

    if "N" in label: 
        width = 100
        depth = 15 
    elif "W" in label: 
        width=300
        depth = 39
    elif "V" in label: 
        width = 200 
        depth= 27
    else :
        width=0 
        depth =0

    if "4" in label:
        inlet=0.4
    elif "7" in label:
        inlet=0.7
    elif "1" in label:
        inlet=0.1
    else:
        inlet=1
    rho= 1950*(0.4)
    v = 10 
    vflux= depth*inlet*width*v*15

    if "X" in label:
        amp= 0.09
    elif "Y" in label: 
        amp=0.15
    elif "Z" in label: 
        amp=0.20
    else :
        amp=0


    return wave, amp*wave, width, depth, depth*inlet, vflux

def normalizebyamp(data):
    labels=data.columns
    result=pd.DataFrame()
    for sim in labels:
        if "X" in sim:
            amp=0.09
        elif "Y" in sim:
            amp=0.15
        elif "Z" in sim:
            amp = 0.2


        result[sim]=data[sim]/amp
    return result

def normalizebywave(data):
    labels=data.columns
    result=pd.DataFrame()
    for sim in labels:
        if "A" in sim :
            wave=300
        elif "C" in sim :
            wave= 900
        elif "S" in sim :
            wave=1200
        elif "B" in sim or "b" in sim:
            wave=600
        elif "D" in sim:
            wave=1200
        elif "E" in sim:
            wave=2400

        result[sim]= data[sim]/wave

    return result

def normalizebydepth(data):
    labels=data.columns
    for sim in labels:
        if "V" in sim :
            d=27
        elif "W" in sim :
            d=39
        elif "N" in sim :
            d=15

        data[sim]= data[sim]/d

    return data

def normalizebywidth(data):
    labels=data.columns
    for sim in labels:
        if "V" in sim :
            CA=201
        elif "W" in sim :
            CA=300
        elif "N" in sim :
            CA=102

        data[sim]= data[sim]/CA

    return data

def normalizebyCA(data):
    result=normalizebywidth(data)
    result=normalizebydepth(data)

    return result

def normalizebyvol(data):
    labels=data.columns
    result=pd.DataFrame()
    for sim in labels:
        wave, amp, width, depth, inlet, vflux=labelparam(sim)
        result[sim]=data[sim]/vflux
    return result

def normalizebypower(data):
    labels=data.columns
    result=pd.DataFrame()
    for sim in labels:
        wave, amp, width, depth, inlet, vflux=labelparam(sim)
        result[sim]=data[sim]/(amp*amp)
    return result

def normalizebymass(data):
    labels=data.columns
    result=pd.DataFrame()
    for sim in labels:
        wave, amp, width, depth, inlet, vflux=labelparam(sim)
    
        result[sim]=(data[sim]/vflux)
    return result