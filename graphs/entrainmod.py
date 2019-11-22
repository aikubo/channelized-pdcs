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

