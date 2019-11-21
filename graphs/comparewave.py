import numpy as np
import matplotlib.pyplot as plt
import matplotlib.font_manager as font_manager
from matplotlib import cm 
import pandas as pd
import seaborn as sns

from openmod import *
from entrainmod import *
from pltfunc import *
from normalize import *
from curtains import *

import os 


## still running 
## 'CVZ7'
wavelabels= [ 'AVX4', 'BVX4', 'CVX4', 'AVX7', 'BVX7', 'CVX7' ] 
labels=wavelabels
labels.sort()

waves=["A", "B", "C", "S"]
## MAC
path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"
os.chdir("/Users/akubo/myprojects/channelized-pdcs/graphs/")
## LAPTOP
#path ="/home/akh/myprojects/channelized-pdcs/graphs/processed/"

avgTG, avgUG, avgdpu, peakin, peakout, xout, xin, zout, zin,  froude, front, bulk_ent, med_ent, dense_ent, avulseddense, buoyantelutriated, massout = openall(labels,path)
davgTG, davgUG, davgdpu = opendenseaverage(labels, path)
peak_in= peakin/39000 #np.log10(peakin + 0.000001)
peak_out= peakout/39000 #np.log10(peakout + 0.000001)

channelfrontsubplot(labels, 'avulsedmassbywavelength', front, avulseddense, 'Avulsed Mass Fraction')
channelfrontsubplot(labels, 'peakdpuoutbywavelength', xout, peakout, 'Peak Dynamic Pressure')

plt.close("all")
# nfront = normalizebywave(front)

## over time
plottogether(labels,'avgUG', avgUG/10, "Average Bulk Velocity (U/UO)", "Time")
plottogether(labels,'avgTG', avgTG/800, "Average Bulk Temperature (U/TO)", "Time")
plottogether(labels,'davgTG', davgTG/800, "Average Bed Load Temperature (U/TO)", "Time")
plottogether(labels,'davgUG', davgUG/10, "Average Bed Load Velocity (U/UO)", "Time")
plottogether(labels,'Elutriatedmass', buoyantelutriated, 'Elutriated Mass Fraction', "Time")
plottogether(labels,'avulsed', avulseddense, 'Mass Avulsed (%)', 'Time')
plottogether(labels, "front", front, "Front Location (m)", 'Time')
plottogether(labels,"peakdpuout", peak_out, 'Peak Dynamic Pressure Outside Channel (Pa)', 'Time')
plottogether(labels,"peakdpuin", peak_in, 'Peak Dynamic Pressure Inside Channel (Pa)', 'Time')

plt.close("all")


