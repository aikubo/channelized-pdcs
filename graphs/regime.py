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
from curv import curvat

from matplotlib import rcParams

## MAC
#path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"
#os.chdir("/Users/akubo/myprojects/channelized-pdcs/graphs/")
## LAPTOP
path = "/home/akh/myprojects/channelized-pdcs/graphs/processed/"
os.chdir('/home/akh/myprojects/channelized-pdcs/graphs/')

import cm_xml_to_matplotlib as cm


def regime(labels, data, param, xlab, ylab, fid):
    fig, axes = plt.subplots()
    setgrl(labels, fig, axes, 6, 4)
    palette = setcolorandstyle(labels)

    for sim in labels:
        i = labels.index(sim)
        c = palette[i]
        initialcond = labelparam(sim)
        X = initialcond[param]
        end = data.loc[data.index[-1], sim]
        print(X)
        print(end)
        axes.scatter(X, end, color=c)

    axes.set_xlabel(param)
    axes.set_ylabel(ylab)
    savefigure(fid)



straight = [
    'SW7',
    'SV4',
    'SW4',
    'SV7',
]
alllabels = [
    'AVX4', 'AVZ4', 'AVY4', 'AWX4', 'AWZ4', 'AWY4', 
    'BVX4', 'BVZ4', 'BVY4', 'BWY4', 'BWX4', 'BWZ4', 
    'CVX4', 'CVZ4', 'CWY4', 'CVY4', 'CWX4', 'CWZ4',
    'DVX4', 'DVY4', 'DVZ4', 'DWX4', 'DWY4', 'DWZ4',
    'AVX7', 'AVZ7', 'AVY7', 'AWY7', 'AWX7', 'AWZ7',
    'BVX7', 'BVY7', 'BVZ7', 'BWX7', 'BWY7', 'BWZ7',
    'CVX7', 'CVY7', 'CWX7', 'CWZ7', 'CWY7',
    'DVX7', 'DVY7', 'DVY7', 'DWY7', 'DWZ7', 'DWX7'
]
#'CVZ7', not done 

alllabels.sort()
print(alllabels)

#alllabels=[ x for x in alllabels if "4" in x]
tot, avulsed, buoyant, massout, area = openmassdist(alllabels, path)

froudefid='_froude.txt'
frcols= ['time', 'AvgU','AvgEP','AvgT','Froude','Front',' Width','Height' ]
front=openmine(alllabels, path, froudefid, frcols, 'Front')
bulk_ent, med_ent, dense_ent = openent(alllabels,path)
avgTG, avgUG, avgdpu, avgWG=openaverage(alllabels, path)
ent= entrain(alllabels, bulk_ent)

avulsed_kg = []

frontend=[]
bulkent=[]
for sim in alllabels:
    bulkent.append(ent[sim].max())
    x = avulsed[sim].max()
    y = tot[sim].max()
    frontend.append(front[sim].max())
    
    avulsed_kg.append(x * y)
P = 1e5
T = 800
R = 461.5
rho_a = P / (R * T)
rho_p = 1950
U0 = 10
mu = 10e-3
reh = (0.4 * rho_p + 0.6 * rho_a) * 10 / mu

def paramlists(labels, Xval, Yval):
    Y = []
    X = []
    for sim in labels:
        param = labelparam(sim)
        Y.append(param.at[0, Yval])
        X.append(param.at[0, Xval])
    return X, Y


def interp(X, Y, Z):
    Z = np.array(Z)
    xmin = min(X)
    xmax = max(X)
    ymin = min(Y)
    ymax = max(Y)
    XX = np.linspace(xmin, xmax, 500)
    YY = np.linspace(ymin, ymax, 500)
    grid_x, grid_y = np.meshgrid(XX, YY)
    print(grid_x)
    print(grid_y)

    grid = griddata((X, Y), Z, (grid_x, grid_y), method='linear')
    return grid_x, grid_y, grid


def regimecontour(labels, X, Y, Z, xlab, ylab, title):
    print(X)
    print(Y)
    print(Z)
    fig, ax = plt.subplots()
    lrange = np.arange(min(Z), max(Z), (max(Z) - min(Z)) / 10)
    ax.tricontour(X, Y, Z, levels=lrange, colors='k')
    cntr = ax.tricontourf(X, Y, Z, levels=lrange, cmap="hot_r")
    ax.set_xlabel(xlab)
    #ax.get_xaxis().set_ticks(np.unique(X))
    ax.set_ylabel(ylab)
    #ax.get_yaxis().set_ticks(np.unique(Y))
    fig.colorbar(cntr)
    plt.title(title)
    plt.show()


def interpcontour(labels, X, Y, Z, xlab, ylab, title):
    fig, ax = plt.subplots()

    ax.contour(X, Y, Z, colors='k')
    cntr = ax.contourf(X, Y, Z, cmap="hot_r")
    ax.set_xlabel(xlab)
    ax.set_ylabel(ylab)
    fig.colorbar(cntr)
    plt.title(title)
    plt.show()


# amplitudes=['X', 'Y', 'Z']
# waves=["A", "B", "C"]
# widths= ["W", "V"]
# vol=["4", "7"]

amprat, wave = paramlists(alllabels, 'Amprat', 'Wave')
amp, vol = paramlists(alllabels, 'Amp', 'Vflux')
width, depth = paramlists(alllabels, 'Width', 'Depth')
inlet, inletrat = paramlists(alllabels, 'Inlet', 'Inletrat')

wamp = [float(x) / y for x, y in zip(amp, width)]
rho = 1950
#tmass= vol*(0.4)*rho

TG, UG, dpu, avgW= openaverage(alllabels, path)
#
avul = []
areas = []
vel = []
velz = []
UGmax=[]
dpumax=[]
phoenix=[]
kapa, dist, kdist = curvat(alllabels)
for sim in alllabels:
    avul.append(avulsed[sim].max())
    areas.append(area[sim].max())
    UGmax.append(UG[sim].max())
    dpumax.append(dpu[sim].max())
    velz.append(avgW[sim].max())


cvol, lg, area = channelvolume(alllabels)

volcvol = [float(x) / float(y) for x, y in zip(vol, cvol)]

rei = [float(x) * float(y) * (reh) for x, y in zip(depth, velz)]
sizes = np.array(areas) / 1212 / 906
cvol2 = [float(x) * float(y) for x, y in zip(sizes, cvol)]
cvol3 = [float(x) / float(y) for x, y in zip(wamp, cvol2)]

capacity = [float(x) / (1212) for x in lg]
X = wave
Y = amp
Z = avul


#palette=setgrl(alllabels,fig,ax, 5,5)
# ax[0].scatter(kdist,Z)
# ax[1].scatter(areas,Z)
# ax[2].scatter(velz,Z)
# ax[3].scatter(capacity,Z)
# ax[4].scatter(cvol,Z)
# sns.set()
# sns.set_context('talk')
#cm = plt.cm.get_cmap('Greys')
#cm=plt.cm.get_cmap('jet')
plt.style.use("seaborn-darkgrid")
cm = cm.make_cmap('/home/akh/myprojects/channelized-pdcs/graphs/4-section-discrete-vanEyck.xml')
#cm = cm.make_cmap('red-2.xml')

#volcvol = [float(x) * float(y) for x, y in zip(volcvol, inlet)]
xdist=[]
zdist=[]
for i in alllabels:
    xdist.append(1212)
    zdist.append(906)

areas_norm = [float(x) / float(y)/ float(z) for x, y, z in zip(areas, inlet, width)]
dist_norm = [float(x) / float(y) for x, y in zip(dist, zdist)]
dist_norm2 = [float(x) / float(y) for x, y in zip(dist, inlet)]
kdist_norm= [float(x) * float(y)  for x, y in zip(kdist, areas)]
mass_norm=[float(x) * float(y) /float(z)  for x, y, z in zip(Z, inlet, wave)]
front_norm=[float(x) / float(y) for x, y in zip(frontend, xdist)]
si=[float(x) / float(y) for x, y in zip(lg, xdist)]
amp_norm=[float(x) / (float(y)+float(x)) for x, y in zip(amp, width)]
## regime figure

rcParams['font.sans-serif'] = ['Helvetica']
fig, ax =plt.subplots(2,2)
fig.set_size_inches(11,8.5)

# ## normalized meander distance vs areas normalized
# # Meander distance = Meander dist (m)/ Z dist(m)
# # Area innudated = 

scat = ax[0][0].scatter(dist_norm, areas_norm, c=wave, cmap=cm)
ax[0][0].set_ylim([0,50])
ax[0][0].tick_params(labelsize=8)
ax[0][0].set_xlabel('Meander Amplitude+Width', fontsize=8)
ax[0][0].set_ylabel('Area Innudated', fontsize=8)

## Front location vs meander width
scat = ax[0][1].scatter(amp_norm, front_norm, c=wave, cmap=cm)
cbar=fig.colorbar(scat, ticks=[300,600,900,1200], ax=ax[0][1])
cbar.ax.tick_params(labelsize=8)
#ax[0][1].set_ylim([0,50])
ax[0][1].tick_params(labelsize=8)
ax[0][1].set_xlabel('Meander Amplitude/Width', fontsize=8)
ax[0][1].set_ylabel('Front Location', fontsize=8)

### mass avulsed vs curvature metric
# mass = mass avuled/total mass *inlet/wave
# curvature = k*meander distance


scat=ax[1][0].scatter(kdist_norm, mass_norm, c=inletrat, cmap=cm)
ax[1][0].set_ylim([-0.001,0.007])
ax[1][0].set_xlim([500,3600])
ax[1][0].tick_params(labelsize=8)
ax[1][0].set_ylabel('Mass Avulsed', fontsize=8)
ax[1][0].set_xlabel('Curvature*(Meander Amplitude + Width)', fontsize=8)

scat=ax[1][1].scatter(kdist_norm, bulkent, c=inletrat, cmap=cm)
#ax[1][1].set_ylim([-0.001,0.007])
#ax[1][1].set_xlim([500,3600])
ax[1][1].tick_params(labelsize=8)
ax[1][1].set_ylabel('Bulk Entrainment', fontsize=8)
ax[1][1].set_xlabel('Curvature*(Meander Amplitude + Width)', fontsize=8)

plt.show()

fig, ax =plt.subplots(2,2)
fig.set_size_inches(11,8.5)
ax[0][0].scatter(amp_norm, UGmax, c=wave, cmap=cm)
ax[0][0].set_ylabel('Maximum Average Velocity', fontsize=8)
ax[0][0].set_xlabel('(MeanderAmp)/(MeanderAmp+Width)', fontsize=8)

ax[0][1].scatter(UGmax, velz, c=wave, cmap=cm)
ax[0][1].set_ylabel('Maximum Average CrossStream Velocity', fontsize=8)
ax[0][1].set_xlabel('Maximum Average Velocity', fontsize=8)

ax[1][1].scatter(velz, mass_norm, c=wave, cmap=cm)
ax[1][1].set_ylabel('Mass Avulsed', fontsize=8)
ax[1][1].set_xlabel('Cross Stream Velocity', fontsize=8)
ax[1][1].set_ylim([-0.0001,.0070])

ax[1][0].scatter(amp_norm, mass_norm, c=wave, cmap=cm)
ax[1][0].set_ylabel('Maximum Average CrossStream Velocity', fontsize=8)
ax[1][0].set_xlabel('(MeanderAmp)/(MeanderAmp+Width)', fontsize=8)
ax[1][0].set_ylim([-0.0001,.0070])

