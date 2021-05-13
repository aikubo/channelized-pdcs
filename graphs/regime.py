import numpy as np
import matplotlib.pyplot as plt
import matplotlib.font_manager as font_manager
 
import pandas as pd
import seaborn as sns
import math

from slength import *

from openmod import *
from entrainmod import *
from pltfunc import *
from curv import curvat
from normalize import labelparam
from matplotlib import rcParams

rcParams['pdf.fonttype'] = 42
rcParams['ps.fonttype'] = 42

## MAC
#path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"
#os.chdir("/Users/akubo/myprojects/channelized-pdcs/graphs/")
## LAPTOP
path = "/home/akh/myprojects/channelized-pdcs/graphs/processed/"
os.chdir('/home/akh/myprojects/channelized-pdcs/graphs/')
alllabels = [
    'AVX4', 'AVZ4', 'AVY4', 'AWX4', 'AWZ4', 'AWY4', 
    'BVX4', 'BVZ4', 'BVY4', 'BWY4', 'BWX4', 'BWZ4', 
    'CVX4', 'CVZ4', 'CWY4', 'CVY4', 'CWX4', 'CWZ4',
    'DVX4', 'DVY4', 'DVZ4', 'DWX4', 'DWY4', 'DWZ4',
    'AVX7', 'AVZ7', 'AVY7', 'AWY7', 'AWX7', 'AWZ7',
    'BVX7', 'BVY7', 'BVZ7', 'BWX7', 'BWY7', 'BWZ7',
    'CVX7', 'CVY7', 'CWX7', 'CVZ7', 'CWZ7', 'CWY7',
    'DVX7', 'DVY7', 'DVZ7', 'DWY7', 'DWZ7', 'DWX7']
#import cm_xml_to_matplotlib as cm

straight = [
    'SW7',
    'SV4',
    'SW4',
    'SV7',
]


Schan= ['SV4', 'SV7'] #['SV4', 'SW4', 'SW7', 'SV7']

froudefid='_froude.txt'
frcols= ['time', 'AvgU','AvgEP','AvgT','Froude','Front',' Width','Height' ]
alllabels.sort()
print(alllabels)

#alllabels=[ x for x in alllabels if "4" in x]
tot, avulsed, buoyant, massout, area, areaout= openmassdist(alllabels, path)
stot, savulsed, sbuoyant, smassout, sarea, sareaout= openmassdist(Schan, path)
sfront=openmine(Schan, path, froudefid, frcols, 'Front')
savgTG, sUG, savgdpu, savgWG, savgEPP, savgrho = openaverage(Schan, path)

cols=['t', 'Udom', 'Uepp', 'Wdom', 'Wepp', 'Vdom', 'Vepp']
colspec= [[1,4], [10,26], [33, 48], [57,70], [79,92], [101,114], [119,135]]
vdom=openmine(alllabels,path, "_cross_stream.txt", cols, 'Vdom', colspec)



#
svulsed=[]
sdist=[]
sa=[]
sU=[]

for sim in Schan: 
    svulsed.append(savulsed[sim].max())
    sdist.append(sfront[sim].max())
    sa.append(sareaout[sim].max())
    sU.append(sUG[sim].max())
    
    
sa=np.average(sa)
sdist=np.average(sdist)
svulsed=np.average(svulsed)
sU=np.average(sU)

front=openmine(alllabels, path, froudefid, frcols, 'Front')
bulk_ent, med_ent, dense_ent = openent(alllabels,path)
avgTG, avgUG, avgdpu, avgW, avgEPP, avgrho=openaverage(alllabels, path)
ent= entrain(alllabels, bulk_ent)

cvol, lg, a = channelvolume(alllabels)

avulsed_kg = []

frontend=[]
bulkent=[]
totalmass=[]
out=[]
bout=[]


for sim in alllabels:
    bulkent.append(ent[sim].max())
    x = avulsed[sim].max()
    y = tot[sim].max()
    frontend.append(front[sim].max())
    totalmass.append(y)
    avulsed_kg.append(x * y)
    out.append(massout[sim].max())
    bout.append(buoyant[sim].max())
    
def justmax(data):
    labels=data.columns
    x=[]
    for sim in labels:
        x.append(data[sim].max())
        
    return x 


out2=[float(x)/float(y) for x,y in zip(out,totalmass)]

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


avul = []
areas = []
aout=[]
vel = []
velz = []
UGmax=[]
dpumax=[]
phoenix=[]
mout=[]
WGmax=[]
vdom_s=[]
kapa, dist = curvat(alllabels)
for sim in alllabels:
    avul.append(avulsed[sim].max())
    areas.append(area[sim].max())
    UGmax.append(avgUG[sim].max())
    dpumax.append(avgdpu[sim].max())
    velz.append(avgW[sim].max())
    aout.append(areaout[sim].max())
    mout.append(massout[sim].min())
    vdom_s.append(vdom[sim].max())



capacity = [float(x) / (1212) for x in lg]
X = wave
Y = amp
Z = avul
plt.style.use("seaborn-darkgrid")

xdist=[]
zdist=[]
for i in alllabels:
    xdist.append(1212)
    zdist.append(906)

slen=sinlength(alllabels,frontend)


kdist_norm=np.array(amp)/np.array(width)

mass_norm=Z/np.array(inlet)*np.array(wave) #[float(x) * (float(z)/float(y) ) for x, y, z in zip(Z, width, inlet)]


slen_norm=[float(x) / float(y) for x, y in zip(slen, lg)]
ugnorm=[float(x)/10 for x in UGmax]

rcParams['font.sans-serif'] = ['Helvetica']
fig, ax =plt.subplots(1,3)

# full page 190X230mm 
# 1/4 page 95mm x 115m 
r_squared=[]

r_sq5=[]
def rforoverk(x,y, k):
    x=np.array(x)
    y=np.array(y)
    mask=np.array([x > k])
    correlation_matrix = np.corrcoef(x[mask], y[mask])
    correlation_xy = correlation_matrix[0,1]
    r2=(correlation_xy**2)
    return r2
        

def plotandR(x,y, loc, col, size):
    
    loc.tick_params(labelsize=8)
    rang=max(x)-min(x)
    cl=rang*0.05
    loc.set_xlim([min(x)-cl, max(x)+cl])
    rang=max(y)-min(y)
    cl=rang*0.05
    loc.set_ylim([min(y)-cl, max(y)+cl])
    #loc.hlines(hline, min(x)-cl, max(x)+cl, 'r' )
    scat=loc.scatter(x,y, c=col, s=size)
    correlation_matrix = np.corrcoef(x, y)
    correlation_xy = correlation_matrix[0,1]
    r_squared.append(correlation_xy**2)
    #r2=rforoverk(x,y,.05)
    #r_sq5.append(r)
    
    return scat

dh=deltah(alllabels, frontend)

# x=dist_norm
size=0.5*((np.array(vol))/10000)**2

kdist_norm=kdist_norm
#wave='k'

# areas_norm=np.array(aout)/np.array(inletrat)
# scat = plotandR(kdist_norm, areas_norm, ax[0][0], 'k', size)
# ax[0][0].set_xlabel('Normalized Curvature', fontsize=8)
# ax[0][0].set_ylabel('Area Innudated', fontsize=8)



# ## Front location vs meander width
# scat = plotandR(kdist_norm, slen_norm, ax[0][1], 'k', size)
# ax[0][1].set_xlabel('Normalized Curvature', fontsize=8)
# ax[0][1].set_ylabel('Distance Travelled', fontsize=8)

# kw=dict(prop="sizes", num=4, func= lambda s: 2*(np.sqrt(s)))
# #leg=ax[0][1].legend(*scat.legend_elements(**kw), )
# #leg.set_title('Volume Flux ( $10^4  m^3/s$)', prop={'size':8})
# # ax[0][1].add_artist(leg)
# # cbar=fig.colorbar(scat, ticks=[300,600,900,1200], ax=ax[0][1])
# # cbar.ax.tick_params(labelsize=8)

# # ### mass avulsed vs curvature metric
# # # mass = mass avuled/total mass *inlet/wave
# # # curvature = k*meander distance


# scat=plotandR(kdist_norm, mass_norm,  ax[1][0], 'k', size)
# ax[1][0].set_ylabel('Mass Overspilled', fontsize=8)
# ax[1][0].set_xlabel('Normalized Curvature', fontsize=8)
                    
                    

# # interestingly area innudated does not corelate with entrainment 
# # but mass overspilled does

# scat=plotandR(kdist_norm, velz, ax[1][1],'k', size)
# ax[1][1].set_ylabel('Cross Stream Velocity (m/s)', fontsize=8)
# ax[1][1].set_xlabel('Normalized Curvature', fontsize=8)

# # scat=plotandR(np.array(vol)/(np.array(width)*1200*np.array(depth)),  dpumax, ax[1][1],'k', size)
# # ax[1][1].set_xlabel('Carrying Capacity', fontsize=8)
# # ax[1][1].set_ylabel('Dynamic pressure', fontsize=8)
# # ax[1][1].set_xlim([0.002, 0.008])

# plt.tight_layout()


areas_norm=np.array(aout)/np.array(inletrat)
scat = plotandR(kdist_norm, areas_norm, ax[0], 'k', size)
ax[0].set_xlabel('Normalized Curvature', fontsize=8)
ax[0].set_ylabel('Area Innudated', fontsize=8)



## Front location vs meander width
scat = plotandR(kdist_norm, slen_norm, ax[1], 'k', size)
ax[1].set_xlabel('Normalized Curvature', fontsize=8)
ax[1].set_ylabel('Distance Travelled', fontsize=8)

kw=dict(prop="sizes", num=4, func= lambda s: 2*(np.sqrt(s)))
#leg=ax[0][1].legend(*scat.legend_elements(**kw), )
#leg.set_title('Volume Flux ( $10^4  m^3/s$)', prop={'size':8})
# ax[0][1].add_artist(leg)
# cbar=fig.colorbar(scat, ticks=[300,600,900,1200], ax=ax[0][1])
# cbar.ax.tick_params(labelsize=8)

# ### mass avulsed vs curvature metric
# # mass = mass avuled/total mass *inlet/wave
# # curvature = k*meander distance


# scat=plotandR(kdist_norm, mass_norm,  ax[1][0], 'k', size)
# ax[1][0].set_ylabel('Mass Overspilled', fontsize=8)
# ax[1][0].set_xlabel('Normalized Curvature', fontsize=8)
                    
                    

# interestingly area innudated does not corelate with entrainment 
# but mass overspilled does

scat=plotandR(kdist_norm, velz, ax[2],'k', size)
ax[2].set_ylabel('Cross Stream Velocity (m/s)', fontsize=8)
ax[2].set_xlabel('Normalized Curvature', fontsize=8)

fig.savefig("regime3.eps", dpi=600)

# print(r_squared)


fig2, ax2=plt.subplots()
ax2.scatter(kdist_norm, Z, c='k', s=size)
ax2.scatter(kdist_norm, bout, c='k', s=size)

#savefigure("regimeNOV")



## AREA CORRELATES WITH ENTRAINMENT

# fig, ax=plt.subplots()
# fig.set_size_inches(cm2inch(9.5, 6))
# plotandR(areas, bulkent, ax, 'k',  size)
# ax.set_xlabel('Areas Innundated', fontsize=8)
# ax.set_ylabel('Bulk Entrainment', fontsize=8)
# savefigure("regime_ENTRAINMENT")

