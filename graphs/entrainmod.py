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

    deltaV=pd.DataFrame()
    for sim in labels:
        vol=data[sim]
        dv=[]
        dv.append(0)
        for i in range(1,8):
            ent=vol[i]-vol[i-1]
            dv.append(ent)

        deltaV[sim]=dv

    return deltaV

def entrainment(labels,path):
    bulk_ent, med_ent, dense_ent = openent(labels,path)
    be=entrain(labels, bulk_ent)
    me=entrain(labels, med_ent)
    de=entrain(labels, dense_ent)
    
    return be, me, de

def maxentrainment(labels,path):
    be,me,de=entrainment(labels,path)
    
    be_max=[]
    de_max=[]
    for i in labels:
        be_max.append(be[i].max())
        de_max.append(de[i].max())
    
    return be_max, de_max
