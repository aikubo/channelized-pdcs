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


## still running 
## 'CVZ7'
alllabels= [ 'AVX4',  'AVZ4',    'BVX4',  'BVZ4',  'BWY4',  'CVX4',  'CVZ4',  'CWY4',  'SW4',
            'AVY4' , 'AWX4',  'AWZ4',  'BVY4',  'BWX4',  'BWZ4',  'CVY4',  'CWX4',  'CWZ4',  'SV4', 
            'AVX7', 'AVZ7',  'BVX7', 'BVZ7','BWY7','CVY7', 'SV7', 'AWY4','AWY7','CWX7','CWZ7',
            'AVY7',  'AWX7',  'AWZ7',  'BVY7',  'BWX7',  'BWZ7',  'CVX7', 'CWY7',  'SW7' ] 
labels=alllabels
labels.sort()

waves=["A", "B", "C", "S"]
## MAC
path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"
os.chdir("/Users/akubo/myprojects/channelized-pdcs/graphs/")
## LAPTOP
#path ="/home/akh/myprojects/channelized-pdcs/graphs/processed/"


avgTG, avgUG, avgdpu, peakin, peakout, xout, xin, zout, zin,  froude, front, bulk_ent, med_ent, dense_ent, avulseddense, buoyantelutriated, massout = openall(labels,path)
peak_in= peakin #np.log10(peakin + 0.000001)
peak_out= peakout #np.log10(peakout + 0.000001)

channelfrontsubplot(labels, 'avulsedmassbywavelength', front, avulseddense, 'Avulsed Mass Fraction')
channelfrontsubplot(labels, 'elumassbywavelength', front, buoyantelutriated, 'Elutriated Mass Fraction')
channelfrontsubplot(labels, 'peakdpubywavelength',xin, peak_in, 'Peak Dynamic Pressure in Channel ( Log (Pa))')
channelfrontsubplot(labels, 'peakdpuoutbywavelength', xout, peak_out, 'Peak Dynamic Pressure outside Channel ( Log (Pa))')
#fn.channelfrontsubplot('crossstreambywavelength',crossV, 'Mass Fraction moving Cross Stream')
plt.close("all")
# nfront = normalizebywave(front)

plottogether(labels,"froude", froude, "Froude Number", "Time")
plottogether(labels,'avgUG', avgUG/10, "Average Velocity (U/UO)", "Time")
plottogether(labels,'Elutriatedmass', buoyantelutriated, 'Elutriated Mass Fraction', "Time")
plottogether(labels,'inchannel', massout, 'Mass in Channel (%)', 'Time')
plottogether(labels,'avulsed', avulseddense, 'Mass Avulsed (%)', 'Time')
plottogether(labels,"front", front, "Front Location (m)", 'Time')
plottogether(labels,"peakdpuout", peak_out, 'Peak Dynamic Pressure Outside Channel (Pa)', 'Time')
plottogether(labels,"peakdpuin", peak_in, 'Peak Dynamic Pressure Inside Channel (Pa)', 'Time')

plt.close("all")
#plottogether("cross_streamV", crossV, 'Mass Fraction with Dominant Cross Stream Velocity', 'Time')

#plotby("DPU by UG", peak_dpuin, avg_UG, "Dynamic Pressure (Log Pa)", "Velocity (m/s)")

#plotby("ent_elu", buoyantelutriated, deltaV, "Elutriated Mass Fraction (%)", "Entrainment (m^3)")
#plotby("elu_avul", buoyantelutriated, avulseddense, "Elutriated Mass Fraction (%)", "Avulsed Mass Fraction")
#plotby("avul", avulseddense, avg_UG, "Avulsed Mass Fraction (%)", "Velocity (m/s)")
#twotime("entveluovertime", ent, gtscaleheight, "Entrainment (m^3)", "Elutriated Mass (%)")


