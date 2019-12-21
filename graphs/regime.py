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

from slength import channelvolume

from openmod import *
from entrainmod import *
from pltfunc import *

from scipy.special import ellipk

def regime(labels, data, param, xlab, ylab, fid):
    fig,axes=plt.subplots()
    setgrl(labels, fig,axes, 6, 4)
    palette=setcolorandstyle(labels)

    for sim in labels:
        i=labels.index(sim)
        c=palette[i]      
        initialcond = labelparam(sim)
        X= initialcond[param]
        end = data.loc[data.index[-1], sim]
        print(X)
        print(end)
        axes.scatter(X, end, color=c)

    axes.set_xlabel(param)
    axes.set_ylabel(ylab)
    savefigure(fid)

## MAC
#path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"
#os.chdir("/Users/akubo/myprojects/channelized-pdcs/graphs/")
## LAPTOP
path ="/home/akh/myprojects/channelized-pdcs/graphs/processed/"
os.chdir('/home/akh/myprojects/channelized-pdcs/graphs/')
straight=['SW7','SV4','SW4','SV7',]
alllabels= [ 'AVX4',  'AVZ4',    'BVX4',  'BVZ4',  'BWY4',  'CVX4',  'CVZ4',  'CWY4', 
            'AVY4' , 'AWX4',  'AWZ4',  'BVY4',  'BWX4',  'BWZ4',  'CVY4',  'CWX4',  'CWZ4', 
            'AVX7', 'AVZ7',  'BVX7', 'BWY7','CVY7', 'AWY4','AWY7','CWX7','CWZ7',
            'AVY7', 'BVZ7', 'AWX7',  'AWZ7',   'BWX7',  'BWZ7',  'CVX7', 'CWY7',   ] 
#BVZ7 has unusally high avulsed mass
alllabels.sort()
#alllabels=[ x for x in alllabels if "4" in x]
tot, avulsed, buoyant, massout, area = openmassdist(alllabels, path)
print(avulsed.max())
avulsed_kg=[]
for sim in alllabels:
    x= avulsed[sim].max()
    y= tot[sim].max()
    avulsed_kg.append(x*y)
P=1e5
T=800
R=461.5
rho_a= P/(R*T)
rho_p=1950
U0=10
mu=10e-3
reh= (  0.4*rho_p+ 0.6*rho_a)*10/mu

# print(area)
# regime(alllabels, avulsed, 'Amp', "Amplitude (m)", "Avulsed Mass", "regime_amp")
# regime(alllabels, avulsed, 'Amprat', "Amplitude Ratio", "Avulsed Mass", "regime_amprat")
# regime(alllabels, avulsed, 'Wave', "Wavelength (m)", "Avulsed Mass", "regime_wave")
# regime(alllabels, avulsed, 'Width', "Width (m)", "Avulsed Mass", "regime_width")
# regime(alllabels, avulsed, 'Inletrat', "Inlet Height/Depth", "Avulsed Mass", "regime_inletrat")

# regime(alllabels, area, 'Amp', "Amplitude (m)", "Area Innundated (m^2)", "regime_amp_area")
# regime(alllabels, area, 'Amprat', "Amplitude Ratio",  "Area Innundated (m^2)", "regime_amprat_area")
# regime(alllabels, area, 'Wave', "Wavelength (m)",  "Area Innundated (m^2)", "regime_wave_area")
# regime(alllabels, area, 'Width', "Width (m)",  "Area Innundated (m^2)", "regime_width_area")
# regime(alllabels, area, 'Inletrat', "Inlet Height/Depth",  "Area Innundated (m^2)", "regime_inletrat_area")

# regime(alllabels, massout, 'Amp', "Amplitude (m)", "Mass Out", "regime_amp_mass")
# regime(alllabels, massout, 'Amprat', "Amplitude Ratio", "Mass Out", "regime_amprat_mass")
# regime(alllabels, massout, 'Wave', "Wavelength (m)", "Mass Out", "regime_wave_mass")
# regime(alllabels, massout, 'Width', "Width (m)", "Mass Out", "regime_width_mass")
# regime(alllabels, massout, 'Inletrat', "Inlet Height/Depth", "Mass Out", "regime_inletrat_mass")

#printlegend(alllabels, 'regimelegend')




def curvat(labels):
    kapa=[]
    dist=[]
    kapadist=[]
    for sim in labels:
        param=labelparam(sim)
        wave = param.get_value(0,'Wave')
        A=param.get_value(0,'Amprat')
        amp=param.get_value(0,'Amp')
        width=param.get_value(0,'Width')
        slope= 0.18
        X = wave/4
        kapamax= 4*((np.pi)**2)*A*np.sin(2*np.pi*X/wave)
        kapa.append(kapamax)
        d=2*(amp+width)

        d2= np.sqrt(d**2 + (wave/2)**2)
        dist.append(d2)
        kdist=kapamax/d2

        # print("kapamax",kapamax)
        # print( "dist", d)


        kapadist.append(kdist)
        

    return kapa,dist, kapadist

def paramlists(labels, Xval, Yval):
    Y=[]
    X=[]
    for sim in labels: 
        param=labelparam(sim)
        Y.append(param.get_value(0, Yval))
        X.append(param.get_value(0, Xval))
    return X, Y

def interp(X,Y,Z):
    Z=np.array(Z)
    xmin=min(X)
    xmax=max(X)
    ymin=min(Y)
    ymax=max(Y)
    XX=np.linspace(xmin, xmax, 500)
    YY=np.linspace(ymin, ymax, 500)
    grid_x, grid_y= np.meshgrid(XX,YY)
    print(grid_x)
    print(grid_y)

    grid= griddata((X,Y), Z, (grid_x, grid_y), method='linear')
    return grid_x, grid_y, grid

def regimecontour(labels, X, Y, Z, xlab, ylab, title):
    print(X)
    print(Y)
    print(Z)
    fig,ax=plt.subplots()
    lrange=np.arange(min(Z), max(Z), (max(Z)- min(Z))/10)
    ax.tricontour(X,Y,Z, levels=lrange, colors='k')
    cntr= ax.tricontourf( X, Y, Z, levels=lrange, cmap="hot_r") 
    ax.set_xlabel(xlab)
    #ax.get_xaxis().set_ticks(np.unique(X))
    ax.set_ylabel(ylab)
    #ax.get_yaxis().set_ticks(np.unique(Y))
    fig.colorbar(cntr)
    plt.title(title)
    plt.show()

def interpcontour(labels, X, Y, Z, xlab, ylab, title):
    fig,ax=plt.subplots()

    ax.contour(X,Y,Z,  colors='k')
    cntr= ax.contourf( X, Y, Z,  cmap="hot_r") 
    ax.set_xlabel(xlab)
    ax.set_ylabel(ylab)
    fig.colorbar(cntr)
    plt.title(title)
    plt.show()


# amplitudes=['X', 'Y', 'Z']
# waves=["A", "B", "C"]
# widths= ["W", "V"]
# vol=["4", "7"]


amprat, wave= paramlists(alllabels, 'Amprat', 'Wave' )
amp, vol=paramlists(alllabels, 'Amp', 'Vflux')
width, depth= paramlists(alllabels, 'Width', 'Depth' )
inlet, inletrat= paramlists(alllabels, 'Inlet', 'Inletrat')

wamp= [float(x)/y for x,y in zip(amp, width)]

TG, UG, dpu, avgW= opendenseaverage(alllabels, path)
#
avul=[]
areas=[]
vel=[]
velz=[]
kapa, dist, kdist= curvat(alllabels)
for sim in alllabels:
    avul.append(avulsed[sim].max())
    areas.append(area[sim].max())
    vel.append(UG[sim].max())
    velz.append(avgW[sim].max())

cvol, lg,area= channelvolume(alllabels)
rei=[float(x)*float(y)*(reh) for x,y in zip(depth,velz)]
sizes= np.array(areas)/1212/906
cvol2= [float(x)*float(y) for x,y in zip(sizes,cvol)]
cvol3= [float(x)/float(y) for x,y in zip(wamp,cvol2)]

capacity= [float(x)/(1212) for x in lg]
X= wave
Y= amp
Z= avul

fig,ax=plt.subplots()
#palette=setgrl(alllabels,fig,ax, 5,5)
# ax[0].scatter(kdist,Z)
# ax[1].scatter(areas,Z)
# ax[2].scatter(velz,Z)
# ax[3].scatter(capacity,Z)
# ax[4].scatter(cvol,Z)
# sns.set()
# sns.set_context('talk')
cm = plt.cm.get_cmap('Greys')
plt.style.use("seaborn-darkgrid")
ax.scatter(kdist, Z)

# ax.set_xlim([0,0.02])
# ax.set_ylim([0,0.1])
# ax.tick_params(labelsize=12) 


ax.set_xlabel('Curvature/Meader Amplitude Metric', fontsize=16)
ax.set_ylabel('Mass Fraction Avulsed ', fontsize=16)
`#cbar=plt.colorbar(scat)
# cbar.ax.tick_params(labelsize=12) 
# cbar.ax.set_ylabel('Area Fraction Innundated ', fontsize=18)
plt.show()
#savefigure('regimeAGU')
# re = rho*ui*length/(mu)
# mu from one of joes papers
# cominucion jgr 2008 appendix
# channelized turbidity currents


# cntr = ax.scatter(wamp,Z, c=Z , cmap=cm, s=sizes)
# ax.set_xlabel('Amplitude/Width')
# ax.set_ylabel('Mass Avulsed (%)')
# fig.colorbar(cntr)
# plt.show()
#regimecontour(alllabels, X, Y, Z, "Curvature*Distance", "Volume Flux", "Avulsed Mass %")
#plt.show()
# X,Y,Z=interp(X,Y,Z)
#interpcontour(alllabels, X, Y, Z, "Amp/Width", "Amp/Wave", "Avulsed Mass (kg)")

# fig = plt.figure()
# ax = fig.add_subplot(111, projection='3d')
# cm = plt.cm.get_cmap('hot_r')
# ax.scatter(amprat,wamp,Z, c=avul, s=sizes, cmap=cm)

# ax.set_xlabel('Amplitude/Wavelength')
# ax.set_ylabel('Amplitude/Width')
# ax.set_zlabel('Avulsed Mass %')

# for angle in range(0, 390*3, 90):
#     ax.view_init(30, angle)
#     plt.draw()
#     plt.pause(5)


#plt.show()
#savefigure("regime_area_innundated")
# fig2,ax2=plt.subplots()
# xlab= "Wavelength"
# ylab="Volume Flux"

# ax2.tricontour(X2,Y,Z, levels=lrange, colors='k')
# cntr= ax2.tricontourf( X2, Y, Z, levels=lrange, cmap="RdGy_r") 

# # cp = ax.contour(X, Y, Z)
# # ax.clabel(cp, inline=True, 
# #              fontsize=10, 
# #              cmap='RdGy'))

# ax2.set_xlabel(xlab)
# ax2.set_ylabel(ylab)
# fig2.colorbar(cntr)
#plt.show()
