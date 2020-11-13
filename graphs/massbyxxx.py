#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Nov  9 14:38:47 2020

@author: akh
"""
import matplotlib.pyplot as plt
from matplotlib import rcParams
import numpy as np
import pandas as pd
import os 
import openmod
from normalize import labelparam
from curv import curvat
## MAC
#path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"
#os.chdir("/Users/akubo/myprojects/channelized-pdcs/graphs/")
## LAPTOP
path ="/home/akh/myprojects/channelized-pdcs/graphs/processed/"
os.chdir("/home/akh/myprojects/channelized-pdcs/graphs/")

alllabels = [

    'AVX7', 'AVZ7', 'AVY7', 'AWY7', 'AWX7', 'AWZ7',
    'BVX7', 'BVY7', 'BVZ7', 'BWX7', 'BWY7', 'BWZ7',
    'CVX7', 'CVY7', 'CWX7', 'CVZ7', 'CWZ7', 'CWY7',
    'DVX7', 'DVY7', 'DVY7', 'DWY7', 'DWZ7', 'DWX7']

alllabels = [
     'AVZ4',
     'BVZ4', 
     'CVZ4', 
     'DVZ4',]

Schan= ['SW7', 'SV4','SW4','SV7', 'uncon'] #['SV4', 'SW4', 'SW7', 'SV7']


col=['t', 'X', 'E1', 'E2', 'total']
E1=openmod.openmine(alllabels, path, "_massbyxxx.txt", col, 'E1')


def paramlists(labels, Xval, Yval):
    Y = []
    X = []
    for sim in labels:
        param = labelparam(sim)
        Y.append(param.at[0, Yval])
        X.append(param.at[0, Xval])
    return X, Y


amprat, wave = paramlists(alllabels, 'Amprat', 'Wave')
amp, vol = paramlists(alllabels, 'Amp', 'Vflux')
width, depth = paramlists(alllabels, 'Width', 'Depth')
inlet, inletrat = paramlists(alllabels, 'Inlet', 'Inletrat')

x=np.arange(3,1194,3)
xx,yy=np.meshgrid(x, np.array(wave))

xnorm=xx/yy
x,lab=np.meshgrid(x, range(len(alllabels)))
xnorm=xnorm.T
lab=lab.T

fig, a=plt.subplots(1,2)

a[0].pcolor( lab, xnorm, np.log10(E1+0.00001), cmap="RdBu_r")

E2=openmod.openmine(alllabels, path, "_massbyxxx.txt", col, 'E2')


a[1].pcolor( lab,xnorm, np.log10(E2+0.00001), cmap="RdBu_r")

