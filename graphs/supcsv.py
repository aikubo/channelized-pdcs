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
    'DVX7', 'DVY7', 'DVZ7', 'DWY7', 'DWZ7', 'DWX7',  
    'SW7', 'SV4','SW4','SV7', 'uncon']

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


for sim in alllabels:
    bulkent.append(ent[sim].max())
    x = avulsed[sim].max()
    y = tot[sim].max()
    frontend.append(front[sim].max())
    totalmass.append(y)
    avulsed_kg.append(x * y)
    out.append(massout[sim].max())
    
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

#wamp = [float(x) / y for x, y in zip(amp, width)]
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
kapa, dist = curvat(alllabels)
for sim in alllabels:
    avul.append(avulsed[sim].max())
    areas.append(area[sim].max())
    UGmax.append(avgUG[sim].max())
    dpumax.append(avgdpu[sim].max())
    velz.append(avgW[sim].max())
    aout.append(areaout[sim].max())
    mout.append(massout[sim].min())



#volcvol = [float(x) / float(y) for x, y in zip(vol, cvol)]


sizes = np.array(areas) / 1212 / 906
#cvol2 = [float(x) * float(y) for x, y in zip(sizes, cvol)]
#cvol3 = [float(x) / float(y) for x, y in zip(wamp, cvol2)]

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
#cm = cm.make_cmap('4-section-discrete-vanEyck.xml')
#cm = cm.make_cmap('red-2.xml')

#volcvol = [float(x) * float(y) for x, y in zip(volcvol, inlet)]
xdist=[]
zdist=[]
for i in alllabels:
    xdist.append(1212)
    zdist.append(906)

slen=sinlength(alllabels,frontend)

# area_channel=[ float(x)*float(y) for x, y in zip(areas, aout)]

# dist_norm = [float(x) / float(y) for x, y in zip(dist,zdist)]
# dist_norm2 = [float(x) / float(y) for x, y in zip(dist, inlet)]

# kdist_norm= [float(x) * float(y)  for x, y in zip(kdist, wave)]
# kdist_norm2= [float(x) * (float(y)) *(float(z)) for x, y, z in zip(kdist, wave, inletrat)]
# mass_norm=[float(x) * (float(z)/float(y) ) for x, y, z in zip(Z, xdist, wave)]
# front_norm=[float(x) / float(y) for x, y in zip(frontend, slen)]
# si=[float(x) / float(y) for x, y in zip(lg, xdist)]
# amp_norm=[ float(x)/ (float(y)) for x, y in zip(amp, zdist)]
# ent_norm=[float(x) / (float(y)) for x, y in zip(bulkent, cvol)]

# slen_norm=[float(x) / float(y) for x, y in zip(slen, lg)]
# ugnorm=[float(x)/10 for x in UGmax]
## regime figure



    

#rcParams['font.sans-serif'] = ['Helvetica']
#fig, ax =plt.subplots(2,2)

# full page 190X230mm 
# 1/4 page 95mm x 115m 

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
    return scat

dh=deltah(alllabels, frontend)


columns=['Width (m)', 'Depth (m)', 'Wavelength (m)', 'Amplitude (m)', 'H0 (m)', 
             'Distance Traveled (m)', 'Mass Fraction in Channel',
             'Mass Overspilled', 'Area Fraction Innundated','Area Out of Channel', 
             'Max Depth Averaged Downstream Velocity (m/s)', 'Bulk Entrainment (m^3)', 'dH', 'Volume (m^3)']

"""
0 'Width', 
1 'Depth', 
2 'Wavelength',
3 'Amplitude', 
4 'H0', 
5 'Distance Traveled ', 
6 'Mass Fraction in Channel',
7 "Mass Overspilled", 
8 'Area Fraction Innundated', 
9 'Area out of Channel Innundated'
10 "Max Depth Averaged Downstream Velocity"
11 "Bulk Entrainment"
12 "dH"
"""

sup=np.empty( (len(alllabels), len(columns)))
for i in range(len(alllabels)):
    sup[i][0]=width[i]
    sup[i][1]=depth[i]
    sup[i][2]=wave[i]
    sup[i][3]=amp[i]
    sup[i][4]=inlet[i]
    sup[i][5]=slen[i]
    sup[i][6]=1-mout[i]
    sup[i][7]=Z[i]
    sup[i][8]=areas[i]
    sup[i][9]=aout[i]
    sup[i][10]=UGmax[i]
    sup[i][11]=bulkent[i]
    sup[i][12]=dh[i]
    sup[i][13]=vol[i]*15
supcsv=pd.DataFrame(sup,  index=alllabels, columns=columns)
supcsv.to_csv("/home/akh/myprojects/channelized-pdcs/graphs/supcsv.csv")
