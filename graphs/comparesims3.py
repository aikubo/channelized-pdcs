import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns

#colors = sns.cubehelix_palette(8)
palette="coolwarm"
sns.set()
print('hello world')



labels=[ "AV4", "CV4", "BW4", "CW4", "SW4", "bw7", "AV7", "CV7" ]
labels.sort()
colors = sns.cubehelix_palette(len(labels), rot=-0.4)

def openslice():
    path2file = '/home/akh/channelized-pdcs/graphs/processed/'
    slicefid='_slice_x200_z150.txt'
    sim='AV4'
    #for sim in labels:
    fid=path2file+sim
    loc=fid + slicefid
    slice_temp=pd.read_fwf(loc, header=None, skiprows=9)
    col = ['EPP', 'UG', 'DPU', 'TG', 'Ri' ]
    slice_temp.columns = ['time', 'YYY',  'EPP', 'UG', 'DPU', 'TG', 'Ri' ]

        ## take average 
        #10-115 so 0-105

    # get rid of all values where EPP less than 7
    for i in col:
        slice_temp.loc[slice_temp['EPP']>7] = 0

    # first split by timestep
    sliceavg=slice_temp[0:106]
    for t in range(5,9):
        bottom=(t-1)*106
        top=t*106
        df=slice_temp[bottom:top]
        print(df)
        #add to average 
        sliceavg = sliceavg+df.values
    # divide by time
    sliceavg=sliceavg/4

    print(sliceavg)
       # UG[sim]=slice_temp['UG']
       # EPP[sim]=slice_temp['EPP']
       # DPU[sim]=slice_temp['DPU']
       # TG[sim]=slice_temp['TG']
       # RI[sim]=slice_temp['Ri']
    
openslice()

def openlabel(labels):
    path2file = '/home/akh/channelized-pdcs/graphs/processed/'
    nosefid='_nose.txt'
    froudefid='_froude.txt'
    slicefid='_slice_x200_z150.txt'
    entrainmentfid='_entrainment.txt'
    massfid='_massinchannel.txt'
    avgf='_average_all.txt'

    ent=pd.DataFrame()
    froude=pd.DataFrame()
    avg_UG=pd.DataFrame()
    front=pd.DataFrame()

    inchannelmass=pd.DataFrame()
    gtscaleheight=pd.DataFrame()

    for sim in labels:
        fid=path2file + sim
        # nose
        #loc=fid + nosefid
        #nose=pd.read_fwf(loc, header=None, skiprows=9)

        # froude
        loc=fid + froudefid
        fr_temp=pd.read_fwf(loc, header=None, skiprows=9)
        fr_temp.columns=['time', 'AvgU','AvgEP','AvgT','Froude','Front',' Width','Height' ]
        froude[sim]=fr_temp['Froude']
        front[sim]=fr_temp['Front']

        # ent
        loc=fid + entrainmentfid
        ent_temp=pd.read_fwf(loc, header=None, skiprows=9)
        ent_temp.columns=['time', 'bulk', 'medium', 'dense']
        ent[str(sim)]=ent_temp['bulk']

        print(sim)
        # massin
        loc=fid + massfid
        mass_temp=pd.read_fwf(loc, header=None, skiprows=9)
        mass_temp.columns=['time', 'Total Mass (m^3)', 'Elutriated %', 'Med % ', 'Dense %', 'InChannel', ' WidthChannel', ' 0ScaleH', 'ScaleH', '2ScaleH']   
        gtscaleheight[sim]=mass_temp['ScaleH']
        inchannelmass[sim]=mass_temp['InChannel']

        # average
        loc=fid + avgf
        avg_temp=pd.read_fwf(loc, header=None, skiprows=9)
        avg_temp.columns = ['time', 'T_G','U_G','V_G','W_G','U_S1','DPU'  ]
        avg_UG[sim]=avg_temp['U_G']


    return ent, froude, avg_UG, gtscaleheight, inchannelmass, front #nose, froude, ent, massin, avg

def entrain(data):
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

def plottogether(df, xlab, ylab):
    time=['0','5','10','15','20','25','30','35', '40']
    fig1, ax1 = plt.subplots()
    ax1.set_xticklabels(time)
    sns.lineplot(data=df, palette=palette, dashes=False)
    ax1.set_xlabel(xlab)
    ax1.set_ylabel(ylab)
    plt.show()

def plotby(df1, df2, datalabel1, datalabel2):
    palette='coolwarm'
    fig3, ax3 = plt.subplots()
    for sim in labels:
        df3=pd.DataFrame()
        df3['x']=df2[sim]
        df3[sim]=df1[sim]
        sns.lineplot(x=df3.x, y=df3.iloc[:,1], palette=palette, label=sim, legend='brief')
    ax3.set_ylabel(datalabel1)
    ax3.set_xlabel(datalabel2)
    plt.show()

def normalizebywave(data):
    for sim in labels:
        if "A" in sim :
            wave=300
        elif "C" in sim :
            wave= 900
        elif "S" in sim :
            wave=1200
        elif "B" in sim or "b" in sim:
            wave=600
        
        data[sim]= data[sim]/wave

    return front

def normalizebydepth(depth):
    for sim in labels:
        if "V" in sim :
            d=27
        elif "W" in sim :
            d=39
        elif "N" in sim :
            d=15
        
        depth[sim]= depth[sim]/d

    return depth

def normalizebywidth(data):
    for sim in labels:
        if "V" in sim :
            CA=200
        elif "W" in sim :
            CA=300
        elif "N" in sim :
            CA=100
        
        data[sim]= data[sim]/CA

    return data


#ent, froude, avg_UG, gtscaleheight, inchannelmass, front = openlabel(labels)

#nfront=normalizebywave(front)
#deltaV=entrain(ent)
#ndeltaV=normalizebywave(deltaV)
#ndeltaV=normalizebywidth(ndeltaV)
#ndeltaV=normalizebydepth(ndeltaV)
#plottogether(ent)
#plottogether(froude)
#plottogether(avg_UG)
#plottogether(gtscaleheight)
#plottogether(inchannelmass)
#plottogether(front)
#plotbyfront(inchannelmass,nfront, "% Mass in Channel")
#plottogether(ndeltaV, "Time", "Entrainment Normalized by Geometry")

#plotby(inchannelmass, avg_UG, "% Mass in Channel", "Entrainment")