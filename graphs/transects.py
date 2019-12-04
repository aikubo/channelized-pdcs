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
import math

## MAC
path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"
os.chdir("/Users/akubo/myprojects/channelized-pdcs/graphs/")
## LAPTOP
#path ="/home/akh/myprojects/channelized-pdcs/graphs/processed/"
#os.chdir("/home/akh/myprojects/channelized-pdcs/graphs/")

alllabels= [ 'AVX4',  'AVZ4',    'BVX4',  'BVZ4',  'BWY4',  'CVX4',  'CVZ4',  'CWY4',  'SW4',
            'AVY4' , 'AWX4',  'AWZ4',  'BVY4',  'BWX4',  'BWZ4',  'CVY4',  'CWX4',  'CWZ4',  'SV4', 
            'AVX7', 'AVZ7',  'BVX7', 'BVZ7','BWY7','CVY7', 'SV7', 'AWY4','AWY7','CWX7','CWZ7',
            'AVY7',  'AWX7',  'AWZ7',  'BVY7',  'BWX7',  'BWZ7',  'CVX7', 'CWY7',  'SW7' ] 
labels= ['AVX4', 'BVX4', 'CVX4' ]

EPP300=pd.DataFrame() 
EPP600=pd.DataFrame()
EPP900=pd.DataFrame()
TG3=pd.DataFrame()
TG6=pd.DataFrame()
TG9=pd.DataFrame()

for sim in labels: 
    pathid=path+sim+'_transect.txt'
    temp=pd.read_fwf(pathid, header=None, skiprows=9)
    EPP300[sim]=temp.iloc[:,0]
    EPP600[sim]=temp.iloc[:,1]
    EPP900[sim]=temp.iloc[:,2]
    TG3[sim]=temp.iloc[:,3]
    TG6[sim]=temp.iloc[:,4]
    TG9[sim]=temp.iloc[:,5]
print(TG3)
TG3.plot()
plt.show()