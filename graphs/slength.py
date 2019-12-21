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

from scipy.special import ellipk

def channelvolume(labels):
    cvolume=[]
    si=[]
    lg=[]
    a=[]
    for sim in labels:


        if "S" not in sim:
            param=labelparam(sim)
            wave = float(param.get_value(0,'Wave'))
            A=float(param.get_value(0,'Amprat'))
            amp=float(param.get_value(0,'Amp'))
            width=float(param.get_value(0,'Width'))
            depth=float(param.get_value(0,'Depth'))
            oldi=0
            olds=0
            length=0
            for i in range(0,1212,3):
                sinuous= (amp)*np.sin( 2*np.pi *(i)/wave)
                dist = np.sqrt( (i-oldi)**2 + (sinuous-olds)**2)
                olds=sinuous
                oldi=i
                length= dist+length
        else:
            length=1212
        #     for k in range(0,900,3):
        #         k1=sinuous-(width/2)
        #         k2=sinuous+(width/2) 
        #         if k1 < k < k2:
        #             area=area+3
        area=length*width       
        volume=area*depth
        a.append(area)
        cvolume.append(volume)
        lg.append(length)
    return cvolume, lg, a

