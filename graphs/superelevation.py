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

from slength import *

from openmod import *
from entrainmod import *
from pltfunc import *
from curv import curvat
from normalize import labelparam
from matplotlib import rcParams

## MAC
#path= "/Users/akubo/myprojects/channelized-pdcs/graphs/processed/"
#os.chdir("/Users/akubo/myprojects/channelized-pdcs/graphs/")
## LAPTOP
path = "/home/akh/myprojects/channelized-pdcs/graphs/processed/"
os.chdir('/home/akh/myprojects/channelized-pdcs/graphs/')

#import cm_xml_to_matplotlib as cm


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
    'CVX7', 'CVY7', 'CWX7', 'CVZ7', 'CWZ7', 'CWY7',
    'DVX7', 'DVY7', 'DVY7', 'DWY7', 'DWZ7', 'DWX7',
    ]

Schan= ['SW7', 'SV4','SW4','SV7', 'uncon'] #['SV4', 'SW4', 'SW7', 'SV7']



def paramlists(labels, Xval, Yval):
    Y = []
    X = []
    for sim in labels:
        param = labelparam(sim)
        Y.append(param.at[0, Yval])
        X.append(param.at[0, Xval])
    return X, Y


amprat, wave = paramlists(alllabels, 'Amprat', 'Wave')
amp, vol = paramlists(alllabels, 'Amp', 'Vflux')
width, depth = paramlists(alllabels, 'Width', 'Depth')
inlet, inletrat = paramlists(alllabels, 'Inlet', 'Inletrat')

be_max, de_max=maxentrainment(alllabels, path)
tot, avulsed, buoyant, massout, area, areaout= openmassdist(alllabels, path)
avgTG, avgUG, avgdpu, avgWG, avgEPP, avgrho=opendenseaverage(alllabels, path)

cols=['t', 's05', 's15']
fid='_super.txt'
superel_dense=openmine(alllabels, path, fid, cols, 's05')
superel2=openmine(alllabels, path, fid, cols, 's15')


spillEPP, spillRho, spillTG, spillUG, spilldpu=openspillavg(alllabels, path)
avgdpu=avgdpu.drop(avgdpu.index[0])
depth=np.array(depth)
UGmax=[]
dpuMax=[]
mass=[]
mout=[]
aream=[]
rhoc=[]
se1=[]
se2=[]
UGse=[]
WGmax=[]
eppspill=[]
for sim in alllabels:
     UGmax.append(avgUG[sim].max())
     WGmax.append(avgWG[sim].max())
     dpuMax.append(avgdpu[sim].max())
     mass.append(avulsed[sim].max())
     mout.append(massout[sim].max())
     aream.append(areaout[sim].max())
     se1.append(superel_dense[sim].max())
     se2.append(superel2[sim].max())
     eppspill.append(spillRho[sim].iloc[1:8].mean())
     r=superel2[sim].idxmax(axis="columns")
     rhoc.append(avgrho[sim].iloc[r])
     UGse.append(avgUG[sim].iloc[r])
     
     
dpuMax=np.array(dpuMax)
UG=np.array(UGmax)
rhoc=np.array(rhoc)
kapa, dist = curvat(alllabels)
a=1
b=np.array(width)
g=9.81
h1=1*UG**2/(2*g)
Ta=273
R=287
Pconst=1e5
rhoa=Pconst/(R*Ta)
drho=(rhoc-rhoa)/rhoc 

#centrifugal component 
h2=(a)*(b)*(UG**2)/(2*(1/np.array(kapa))*(drho)*g)
#runup contribution
h3=(np.array(UGmax)**2)*(1/drho)/(2*g)
g_star=g*drho
froude=UG/(np.sqrt(g_star*np.array(depth)))
x=np.array(amp)/np.array(width)
y=(se2)/depth
mass2=(50*np.array(mass))**2


rcParams['pdf.fonttype'] = 42
rcParams['ps.fonttype'] = 42

plt.style.use("seaborn-darkgrid")
size=0.5*((np.array(vol))/10000)**2
fig,ax=plt.subplots(1,2)
fw,fl=[10/2.54, 7/2.54]
fig.set_size_inches(fw,fl)


scat=ax[0].scatter(x, np.array(se1)/depth, s=size, c='red')
scat=ax[0].scatter(x, np.array(se2)/depth, s=size, c='orange')
kw=dict(prop="sizes", num=4, func= lambda s: 2*(np.sqrt(s)))
leg=ax[0].legend(*scat.legend_elements(**kw), )
leg.set_title('Volume Flux ( $10^4  m^3/s$)', prop={'size':8})
ax[0].set_ylabel('Normalized Splash Height')
ax[0].set_xlabel('Normalized Curvature')

ax[1].scatter(eppspill, y, s=size, c='k') #s=200*np.array(mout*1000
ax[1].set_xlabel('Average Density in Spill (kg m^{-3})')
ax[1].set_ylabel('Normalized Splash Height')


fig,ax=plt.subplots(2)
ax[0].scatter(be_max/(depth*np.array(width)*3),y, s=size, c="blue", edgecolor='black')
ax[1].scatter(de_max/(depth*np.array(width)*3),y, s=size, c="orange", edgecolor='black')
fig.savefig('entrainment_super.eps', dpi=600)

# ax[1].set_xlabel('Normalized Entrainment')
correlation_matrix = np.corrcoef(x, y)
correlation_xy = correlation_matrix[0,1]
print("R", correlation_xy**2)

correlation_matrix = np.corrcoef(eppspill , y)
correlation_xy = correlation_matrix[0,1]
print("R", correlation_xy**2)


#ax[1].set_xlabel('Average Volume Fraction Particles in Overspill')
#
# plt.tight_layout()
# #fig.savefig('superel.eps', dpi=600)

# fig2,ax2=plt.subplots(3)
# ax2[0].scatter(x, se1/h2, s=size, c='k')
# #ax2[0].plot(h2, h2, c='r')
# ax2[0].set_ylabel('Centrifugal Contribution')


# ax2[1].scatter(x, se1/h3, s=size, c='k')
# #ax2[1].plot(y, h3, c='r')
# ax2[1].set_ylabel('Runup Contribution')


# ax2[2].scatter(x, se1/(h3+h2), s=size, c='k')
# #ax2[1].plot(y, h3, c='r')
# ax2[2].set_ylabel('Both Contributions')

# ax2[2].set_xlabel('Normalized Curvature')

# fig2.savefig('Contributions.eps', dpi=600)

kw=dict(prop="sizes", num=4, func= lambda s: 2*(np.sqrt(s)))
leg=ax2[0].legend(*scat.legend_elements(**kw), )
leg.set_title('Volume Flux ( $10^4  m^3/s$)', prop={'size':8})

ax2[1].scatter(x, de_max/(depth*np.array(width)*3), s=size, c='orange')
ax2[1].set_ylabel('Normalized Dense Isosurface Entrainment')
ax2[1].set_xlabel('Normalized Curvature')

savefigure("entrainment2")
ax[2].scatter(x, eppspill, s=size, cmap=matplotlib.cm.RdBu_r)

ax[2].set_xlabel('Average Overspill Volume Fraction ')
correlation_matrix = np.corrcoef(eppspill, y)
correlation_xy = correlation_matrix[0,1]
print("R", correlation_xy**2)

# plt.tight_layout()
    
# fig,ax=plt.subplots()
# ax.scatter(mass,h1, c='b')
# ax.scatter(mass, h2, c='r')
# ax.scatter(mass, h3, c='g')
# ax.scatter(mass, h1+h2, c='k')

# fig,ax=plt.subplots()
# ax.scatter(aream,h1, c='b')
# ax.scatter(aream, h2, c='r')
# ax.scatter(aream, h3, c='g')
# ax.scatter(aream, h1+h2, c='k')

# fig,ax=plt.subplots()
# ax.scatter(se, h2, c='r')
# ax.scatter(se, h3, c='g')
# ax.plot(se, h3+h2, 'k+')
# ax.plot(se,se, 'k')
# ax.set_xlabel('Superelevation (m)')
# ax.set_ylabel('Calculated Superelevation(m)')

# fig,ax=plt.subplots()
# ax.scatter(mout,h1)
# ax.scatter(mout, h2, c='r')
# alllabels=[ x for x in alllabels if "4" in x]
# tot, avulsed, buoyant, massout, area, areaout= openmassdist(alllabels, path)
# stot, savulsed, sbuoyant, smassout, sarea, sareaout= openmassdist(Schan, path)
# sfront=openmine(Schan, path, froudefid, frcols, 'Front')
# sTG, sUG, sdpu, savgW= openaverage(Schan, path)
# #
# svulsed=[]
# sdist=[]
# sa=[]
# sU=[]

# for sim in Schan: 
#     svulsed.append(savulsed[sim].max())
#     sdist.append(sfront[sim].max())
#     sa.append(sareaout[sim].max())
#     sU.append(sUG[sim].max())
    
    
# sa=np.average(sa)
# sdist=np.average(sdist)
# svulsed=np.average(svulsed)
# sU=np.average(sU)

# front=openmine(alllabels, path, froudefid, frcols, 'Front')
# bulk_ent, med_ent, dense_ent = openent(alllabels,path)
# avgTG, avgUG, avgdpu, avgWG=openaverage(alllabels, path)
# ent= entrain(alllabels, bulk_ent)

# cvol, lg, a = channelvolume(alllabels)

# avulsed_kg = []

# frontend=[]
# bulkent=[]
# totalmass=[]
# out=[]


# for sim in alllabels:
#     bulkent.append(ent[sim].max())
#     x = avulsed[sim].max()
#     y = tot[sim].max()
#     frontend.append(front[sim].max())
#     totalmass.append(y)
#     avulsed_kg.append(x * y)
#     out.append(massout[sim].max())
    
# def justmax(data):
#     labels=data.columns
#     x=[]
#     for sim in labels:
#         x.append(data[sim].max())
        
#     return x 


# out2=[float(x)/float(y) for x,y in zip(out,totalmass)]

# P = 1e5
# T = 800
# R = 461.5
# rho_a = P / (R * T)
# rho_p = 1950
# U0 = 10
# mu = 10e-3
# reh = (0.4 * rho_p + 0.6 * rho_a) * 10 / mu

# def paramlists(labels, Xval, Yval):
#     Y = []
#     X = []
#     for sim in labels:
#         param = labelparam(sim)
#         Y.append(param.at[0, Yval])
#         X.append(param.at[0, Xval])
#     return X, Y



# # amplitudes=['X', 'Y', 'Z']
# # waves=["A", "B", "C"]
# # widths= ["W", "V"]
# # vol=["4", "7"]

# amprat, wave = paramlists(alllabels, 'Amprat', 'Wave')
# amp, vol = paramlists(alllabels, 'Amp', 'Vflux')
# width, depth = paramlists(alllabels, 'Width', 'Depth')
# inlet, inletrat = paramlists(alllabels, 'Inlet', 'Inletrat')

# wamp = [float(x) / y for x, y in zip(amp, width)]
# rho = 1950
# #tmass= vol*(0.4)*rho

# TG, UG, dpu, avgW= openaverage(alllabels, path)
# #
# avul = []
# areas = []
# aout=[]
# vel = []
# velz = []
# UGmax=[]
# dpumax=[]
# phoenix=[]
# mout=[]
# kapa, dist, kdist = curvat(alllabels)
# for sim in alllabels:
#     avul.append(avulsed[sim].max())
#     areas.append(area[sim].max())
#     UGmax.append(UG[sim].max())
#     dpumax.append(dpu[sim].max())
#     velz.append(avgW[sim].max())
#     aout.append(areaout[sim].max())
#     mout.append(massout[sim].min())



# #volcvol = [float(x) / float(y) for x, y in zip(vol, cvol)]


# sizes = np.array(areas) / 1212 / 906
# #cvol2 = [float(x) * float(y) for x, y in zip(sizes, cvol)]
# #cvol3 = [float(x) / float(y) for x, y in zip(wamp, cvol2)]

# capacity = [float(x) / (1212) for x in lg]
# X = wave
# Y = amp
# Z = avul


# #palette=setgrl(alllabels,fig,ax, 5,5)
# # ax[0].scatter(kdist,Z)
# # ax[1].scatter(areas,Z)
# # ax[2].scatter(velz,Z)
# # ax[3].scatter(capacity,Z)
# # ax[4].scatter(cvol,Z)
# # sns.set()
# # sns.set_context('talk')
# #cm = plt.cm.get_cmap('Greys')
# #cm=plt.cm.get_cmap('jet')
# plt.style.use("seaborn-darkgrid")
# #cm = cm.make_cmap('4-section-discrete-vanEyck.xml')
# #cm = cm.make_cmap('red-2.xml')

# #volcvol = [float(x) * float(y) for x, y in zip(volcvol, inlet)]
# xdist=[]
# zdist=[]
# for i in alllabels:
#     xdist.append(1212)
#     zdist.append(906)

# slen=sinlength(alllabels,frontend)

# # area_channel=[ float(x)*float(y) for x, y in zip(areas, aout)]

# # dist_norm = [float(x) / float(y) for x, y in zip(dist,zdist)]
# # dist_norm2 = [float(x) / float(y) for x, y in zip(dist, inlet)]

# # kdist_norm= [float(x) * float(y)  for x, y in zip(kdist, wave)]
# # kdist_norm2= [float(x) * (float(y)) *(float(z)) for x, y, z in zip(kdist, wave, inletrat)]
# # mass_norm=[float(x) * (float(z)/float(y) ) for x, y, z in zip(Z, xdist, wave)]
# # front_norm=[float(x) / float(y) for x, y in zip(frontend, slen)]
# # si=[float(x) / float(y) for x, y in zip(lg, xdist)]
# # amp_norm=[ float(x)/ (float(y)) for x, y in zip(amp, zdist)]
# # ent_norm=[float(x) / (float(y)) for x, y in zip(bulkent, cvol)]

# # slen_norm=[float(x) / float(y) for x, y in zip(slen, lg)]
# # ugnorm=[float(x)/10 for x in UGmax]
# ## regime figure



    

# #rcParams['font.sans-serif'] = ['Helvetica']
# #fig, ax =plt.subplots(2,2)

# # full page 190X230mm 
# # 1/4 page 95mm x 115m 

# def plotandR(x,y, loc, col, size):
    
#     loc.tick_params(labelsize=8)
#     rang=max(x)-min(x)
#     cl=rang*0.05
#     loc.set_xlim([min(x)-cl, max(x)+cl])
#     rang=max(y)-min(y)
#     cl=rang*0.05
#     loc.set_ylim([min(y)-cl, max(y)+cl])
#     #loc.hlines(hline, min(x)-cl, max(x)+cl, 'r' )
#     scat=loc.scatter(x,y, c=col, s=size)
#     correlation_matrix = np.corrcoef(x, y)
#     correlation_xy = correlation_matrix[0,1]
#     r_squared.append(correlation_xy**2)
#     return scat

# dh=deltah(alllabels, frontend)


# columns=['Width (m)', 'Depth (m)', 'Wavelength (m)', 'Amplitude (m)', 'H0 (m)', 
#              'Distance Traveled (m)', 'Mass Fraction in Channel',
#              'Mass Overspilled', 'Area Fraction Innundated','Area Out of Channel', 
#              'Max Depth Averaged Downstream Velocity (m/s)', 'Bulk Entrainment (m^3)', 'dH', 'Volume (m^3)']

# """
# 0 'Width', 
# 1 'Depth', 
# 2 'Wavelength',
# 3 'Amplitude', 
# 4 'H0', 
# 5 'Distance Traveled ', 
# 6 'Mass Fraction in Channel',
# 7 "Mass Overspilled", 
# 8 'Area Fraction Innundated', 
# 9 'Area out of Channel Innundated'
# 10 "Max Depth Averaged Downstream Velocity"
# 11 "Bulk Entrainment"
# 12 "dH"
# """

# sup=np.empty( (len(alllabels), len(columns)))
# for i in range(len(alllabels)):
#     sup[i][0]=width[i]
#     sup[i][1]=depth[i]
#     sup[i][2]=wave[i]
#     sup[i][3]=amp[i]
#     sup[i][4]=inlet[i]
#     sup[i][5]=slen[i]
#     sup[i][6]=1-mout[i]
#     sup[i][7]=Z[i]
#     sup[i][8]=areas[i]
#     sup[i][9]=aout[i]
#     sup[i][10]=UGmax[i]
#     sup[i][11]=bulkent[i]
#     sup[i][12]=dh[i]
#     sup[i][13]=vol[i]*15
# supcsv=pd.DataFrame(sup,  index=alllabels, columns=columns)
# supcsv.to_csv("/home/akh/myprojects/channelized-pdcs/graphs/supcsv.csv")
# # # #half page
# #fig.set_size_inches(cm2inch(19.0, 11.5))
# r_squared=[]
# # # # ## normalized meander distance vs areas normalized
# # # # # Meander distance = Meander dist (m)/ Z dist(m)
# # # # # Area innudated = i
# size=((np.array(vol)/10000)**2)*0.5
# # x=dist_norm


# # kdist_norm=kdist_norm
# # #wave='k'

# # areas_norm=np.array(aout)/np.array(inletrat)
# # scat = plotandR(kdist_norm, areas_norm,  svulsed/sa, ax[0][0], 'k', size)
# # ax[0][0].set_xlabel('Curvature', fontsize=8)
# # ax[0][0].set_ylabel('Area Innudated', fontsize=8)



# # ## Front location vs meander width
# # scat = plotandR(kdist_norm, slen_norm, sdist/1212, ax[0][1], 'k', size)
# # ax[0][1].set_xlabel('Normalized Curvature', fontsize=8)
# # ax[0][1].set_ylabel('Distance Travelled', fontsize=8)

# # kw=dict(prop="sizes", num=4, func= lambda s: 2*(np.sqrt(s)))
# # leg=ax[0][1].legend(*scat.legend_elements(**kw), )
# # leg.set_title('Volume Flux ( $10^4  m^3/s$)', prop={'size':8})
# # # ax[0][1].add_artist(leg)
# # # cbar=fig.colorbar(scat, ticks=[300,600,900,1200], ax=ax[0][1])
# # # cbar.ax.tick_params(labelsize=8)

# # # ### mass avulsed vs curvature metric
# # # # mass = mass avuled/total mass *inlet/wave
# # # # curvature = k*meander distance


# # scat=plotandR(kdist_norm, mass_norm, svulsed, ax[1][0], 'k', size)
# # ax[1][0].set_ylabel('Mass Overspilled', fontsize=8)
# # ax[1][0].set_xlabel('Normalized Curvature', fontsize=8)
                    
                    

# # # interestingly area innudated does not corelate with entrainment 
# # # but mass overspilled does

# # scat=plotandR(kdist_norm, ugnorm, sU/10, ax[1][1],'k', size)
# # ax[1][1].set_ylabel('Downstream Velocity', fontsize=8)
# # ax[1][1].set_xlabel('Normalized Curvature', fontsize=8)


# # plt.tight_layout()

# # print(r_squared)
# # savefigure("regimeJULY_WITHS")



# ## AREA CORRELATES WITH ENTRAINMENT

# # fig, ax=plt.subplots()
# # fig.set_size_inches(cm2inch(9.5, 6))
# # plotandR(areas, bulkent, ax, 'k',  size)
# # ax.set_xlabel('Areas Innundated', fontsize=8)
# # ax.set_ylabel('Bulk Entrainment', fontsize=8)
# # savefigure("regime_ENTRAINMENT")

