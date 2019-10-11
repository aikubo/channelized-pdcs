import numpy as np
import matplotlib.pyplot as plt
import matplotlib.font_manager as font_manager
from matplotlib.offsetbox import (TextArea, DrawingArea, OffsetImage,
                                  AnnotationBbox)
from matplotlib import cm 
import pandas as pd
import seaborn as sns

from openmod import *
from pltfunc import *
from normalize import *

def entrain(labels, data):
    print('hello entrainment')
    vol=[]
    deltaV=pd.DataFrame(columns=labels)
    for sim in labels:
        print(sim)
        v=data[sim]
        dv=[0]
        for i in range(1,8):
            ent=v[i]-v[i-1]
            dv.append(ent)
        deltaV[sim]=dv

    return deltaV

alllabels= [ "AVY4","AWX4", "AWY4", "AVY7", "BVY4", "BWX4", "CVY4", "CWX4", "SV4", "SW4", "BVY7", "CWY7", "CWY4", "SW7", "SV7"]
alllabels.sort()
print(len(alllabels))
## MAC
#path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"

## LAPTOP
path ="/home/akh/myprojects/channelized-pdcs/graphs/processed/"
ent1, ent2, ent, = openent(alllabels, path)
deltaV=entrain(alllabels, ent1)
print(deltaV)

plottogether(alllabels,"entrainmentall", deltaV, "Entrainment (m^3)", "Time")

deltaV=normalizebyvol(deltaV)
print(deltaV)

plottogether(alllabels,"Nentrainmentall", deltaV, "Entrainment/Volume of Flow", "Time")
