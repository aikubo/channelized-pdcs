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

def labelparam(label):
    if "A" in label:
        wave = 300
    elif "B" in label:
        wave = 600
    elif "C" in label:
        wave = 900
    elif "D" in label:
        wave = 1200
    elif "E" in label:
        wave = 2400
    else:
        wave = 0 

    if "N" in label: 
        width = 100
        depth = 15 
    elif "W" in label: 
        width=300
        depth = 39
    elif "V" in label: 
        width = 200 
        depth= 27
    else :
        width=0 
        depth =0

    if "4" in label:
        inlet=0.4
    elif "7" in label:
        inlet=0.7
    elif "1" in label:
        inlet=0.1
    else:
        inlet=1
    rho= 1950*(0.4)
    v = 10 
    vflux= 1 #int(depth*inlet/3)*3*width*v

    if "X" in label:
        amp= 0.09
    elif "Y" in label: 
        amp=0.15
    elif "Z" in label: 
        amp=0.20
    else :
        amp=0

    return wave, amp, width, depth, inlet, vflux

# path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"
# labels=[ "AV4", "CV4" ] #, "BW4", "SW4", "BW7", "AV7", "CV7", "EV7", "EV4", "SV4" ]
# labels.sort()

# avgTG, avgUG, avgdpu, peakin, peakout, xout, xin, zout, zin,  froude, front, bulk_ent, med_ent, dense_ent, avulseddense, buoyantelutriated, massout = openall(labels,path)
# peak_in= peakin #np.log10(peakin + 0.000001)
# peak_out= peakout #np.log10(peakout + 0.000001)
# # print(front)cd

# channelfrontsubplot(labels, 'avulsedmassbywavelength', front, avulseddense, 'Avulsed Mass Fraction')
# channelfrontsubplot(labels, 'elumassbywavelength', front, buoyantelutriated, 'Elutriated Mass Fraction')
# channelfrontsubplot(labels, 'peakdpubywavelength',front, peak_in, 'Peak Dynamic Pressure in Channel ( Log (Pa))')
# channelfrontsubplot(labels, 'peakdpuoutbywavelength', front, peak_out, 'Peak Dynamic Pressure outside Channel ( Log (Pa))')
# #fn.channelfrontsubplot('crossstreambywavelength',crossV, 'Mass Fraction moving Cross Stream')
# plt.close("all")
# # nfront = normalizebywave(front)
# deltaV = entrain(labels, bulk_ent)

# plottogether(labels,"entrainmentall", deltaV, "Entrainment (m^3)", "Time")
# plottogether(labels,"froude", froude, "Froude Number", "Time")
# plottogether(labels,'avgUG', avgUG/10, "Average Velocity (U/UO)", "Time")
# plottogether(labels,'Elutriatedmass', buoyantelutriated, 'Elutriated Mass Fraction', "Time")
# plottogether(labels,'inchannel', massout, 'Mass in Channel (%)', 'Time')
# plottogether(labels,'avulsed', avulseddense, 'Mass Avulsed (%)', 'Time')
# plottogether(labels,"front", front, "Front Location (m)", 'Time')
# plottogether(labels,"peakdpuout", peak_out, 'Peak Dynamic Pressure Outside Channel (Pa)', 'Time')
# plottogether(labels,"peakdpuin", peak_in, 'Peak Dynamic Pressure Inside Channel (Pa)', 'Time')

# plt.close("all")
# #plottogether("cross_streamV", crossV, 'Mass Fraction with Dominant Cross Stream Velocity', 'Time')

# #plotby("DPU by UG", peak_dpuin, avg_UG, "Dynamic Pressure (Log Pa)", "Velocity (m/s)")

# #plotby("ent_elu", buoyantelutriated, deltaV, "Elutriated Mass Fraction (%)", "Entrainment (m^3)")
# #plotby("elu_avul", buoyantelutriated, avulseddense, "Elutriated Mass Fraction (%)", "Avulsed Mass Fraction")
# #plotby("avul", avulseddense, avg_UG, "Avulsed Mass Fraction (%)", "Velocity (m/s)")
# #twotime("entveluovertime", ent, gtscaleheight, "Entrainment (m^3)", "Elutriated Mass (%)")



def regime(data, ylab):
    fig,axes=plt.subplots(3)
    setgrl(fig,axes, 6, 4)
    palette=setcolorandstyle(labels)

    for sim in labels:
        i=labels.index(sim)
        c=palette[i]      
        wave, width, depth, inlet, vflux = labelparam(sim)
        end = data.loc[data.index[-1], sim]
        axes[0].scatter(wave, end, color=c)
        axes[1].scatter(width, end, color=c)
        axes[2].scatter(vflux, end, color=c)

    for i in range(len(axes)):
        axes[i].autoscale()
        axes[i].set_ylabel(ylab)

    axes[0].set_xlabel("Wavelength")
    axes[1].set_xlabel("Width")
    axes[2].set_xlabel("Volume Flux")
    labelsubplots(axes, 'uleft')
    plt.show()

# now plot based on label 

#regime(1-inchannelmass, "Avulsed Mass %")

def regime2(data, ylab):
    fig,axes=plt.subplots()
    setgrl(fig,axes, 4,4)
    palette=setcolorandstyle(labels)
    lamb=[]
    vei=[]
    end =[] 

    for sim in labels:
        wave, width, depth, inlet, vflux = labelparam(sim)
        end.append(data.loc[data.index[-1], sim])
        lamb.append(wave)
        vei.append(vflux)

    vmin=min(vei)
    vmax=max(vei)
    cs=axes.scatter(lamb, end, s=40, c=vei, cmap=cm.jet, vmin=vmin, vmax=vmax)
       # axes[1].scatter(width, end, color=c)
        #axes[2].scatter(vflux, end, color=c)

    plt.colorbar(cs)
    axes.autoscale()
    axes.set_ylabel(ylab)

    axes.set_xlabel("Wavelength")
    #axes[1].set_xlabel("Width")
    #axes[2].set_xlabel("Volume Flux")
    #labelsubplots(axes, 'uleft')
    savefigure("regime2")

#regime2(avulseddense, "Avulsed Mass %")