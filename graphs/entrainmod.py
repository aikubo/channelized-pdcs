import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import pltfunc



def entrain(labels, data):
    print('hello entrainment')
    vol=[]
    deltaV=pd.DataFrame(columns=labels)
    for j in range(0,len(labels)):
        sim=labels[j]
        v=[]
        for i in range(2,8):
            dv=data.iloc[i,j]-data.iloc[i-1, j]
            v.append(dv)
        deltaV[sim]=v

    return deltaV
