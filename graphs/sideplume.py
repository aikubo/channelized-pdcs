import numpy as np
import matplotlib.pyplot as plt
import matplotlib.font_manager as font_manager
from matplotlib.offsetbox import (TextArea, DrawingArea, OffsetImage,
                                  AnnotationBbox)
from mpl_toolkits import mplot3d
from mpl_toolkits.mplot3d import Axes3D
from scipy.interpolate import griddata
from matplotlib import cm 
import pandas as pd
import seaborn as sns
import math 

from openmod import *
from entrainmod import *
from pltfunc import *

labels=["AVY4", 'CVY4', 'B4']
alllabels= [ 'AVX4',  'AVZ4',    'BVX4',  'BVZ4',  'BWY4',  'CVX4',  'CVZ4',  'CWY4', 
            'AVY4' , 'AWX4',  'AWZ4',  'BVY4',  'BWX4',  'BWZ4',  'CVY4',  'CWX4',  'CWZ4', 
            'AVX7', 'AVZ7',  'BVX7', 'BWY7','CVY7', 'AWY4','AWY7','CWX7','CWZ7',
            'AVY7',  'AWX7',  'AWZ7',   'BWX7',  'BWZ7',  'CVX7', 'CWY7',   ] 

## MAC
#path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"
#os.chdir("/Users/akubo/myprojects/channelized-pdcs/graphs/")
## LAPTOP
path ="/home/akh/myprojects/channelized-pdcs/graphs/processed/"
os.chdir('/home/akh/myprojects/channelized-pdcs/graphs/')

sideplume= openmine(labels, path, '_sideplume.txt', ['mass'], 'mass', width=[40])

#print(sideplume)
Z=np.arange(0,906,3)
fig,ax=plt.subplots()
plottogether2(labels, 'side', sideplume, Z, 'Buoyant Mass (kg)', 'Z (m)', fig, ax)

xcoords=[350,550]
for xc in xcoords:
    plt.axvline(x=xc)


plt.show()
# cols=['time', 'Umass', 'Uepp', 'Vmass', 'Vepp','Wmass', 'Wepp']
# crossV = openmine(labels, path, '_cross_stream.txt', cols, 'Wmass')
# print(crossV)
# ent, med_ent, dense_ent=openent(labels,path)
# print(ent)
# tot, avulsed, buoyant, massout, area = openmassdist(alllabels, path)
# deltaV=entrain(labels,ent)
# print(deltaV)

# avgTG, avgUG, avgdpu=openaverage(labels,path)
# maxavul=pd.DataFrame()
# maxcrossV=pd.DataFrame()
# for i in labels:
#     maxavul=avulsed.loc[avulsed[i].idxmax()]
#     maxcrossV=crossV.loc[crossV[i].idxmax()]

# #plottogether2(labels, 'crossEnt', maxent, maxcross, 'Entrainment (m^3)', 'Dominate Cross W', fig, ax)
# # ax.scatter(maxcrossV, maxavul)
# # ax.set_ylabel('Avulsed mass (%)')
# # ax.set_xlabel('Fraction of Mass with Dominant W velocity')
# # plt.show()