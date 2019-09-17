import numpy as np
import matplotlib.pyplot as plt
import matplotlib.font_manager as font_manager
from matplotlib.offsetbox import (TextArea, DrawingArea, OffsetImage,
                                  AnnotationBbox)
import pandas as pd
import seaborn as sns

#colors = sns.cubehelix_palette(8)
labels=[ "AV4", "CV4", "BW4", "CW4", "SW4", "bw7", "AV7", "CV7" ]
labels.sort()

palette=sns.color_palette("coolwarm", len(labels))

sns.set()
sns.set_style("white")
sns.set_style( "ticks",{"xtick.direction": "in","ytick.direction": "in"})
sns.set_context("paper")

def openslicet(labels, twant):
    path2file = '/home/akh/channelized-pdcs/graphs/processed/'
    slicefid='_slice_x200_z150.txt'
    slice_EPP=pd.DataFrame()
    slice_UG=pd.DataFrame()
    slice_TG=pd.DataFrame()
    slice_Ri=pd.DataFrame()
    slice_DPU=pd.DataFrame()


    UG=[]
    EPP=[]
    TG=[]
    Ri=[]
    DPU=[]
    
    for sim in labels:
        print(sim)
        slicet=pd.DataFrame()
        fid=path2file+sim
        loc=fid + slicefid
        slice_temp=pd.read_table(loc, header=None, sep= '\s+', skiprows=9)
        col = ['UG', 'DPU', 'TG', 'Ri' ]
        slice_temp.columns = ['time', 'YYY',  'EPP', 'UG', 'DPU', 'TG', 'Ri' ]

        for i in col:
            slicet=slice_temp[slice_temp['time']== twant]
        slicet.reset_index(drop=True, inplace=True)

        UG.append(slicet['UG'])
        EPP.append(slicet['EPP'])
        TG.append(slicet['TG'])
        DPU.append(slicet['DPU'])
        Ri.append(slicet['Ri'])

        del slicet
    slice_UG=pd.concat(UG, axis=1, ignore_index=True)
    slice_EPP=pd.concat(EPP, axis=1, ignore_index=True)
    slice_TG=pd.concat(TG, axis=1, ignore_index=True)
    slice_DPU=pd.concat(DPU, axis=1, ignore_index=True)
    slice_Ri=pd.concat(Ri, axis=1, ignore_index=True)

    slice_UG.columns=labels
    slice_TG.columns=labels
    slice_EPP.columns=labels
    slice_DPU.columns=labels
    slice_Ri.columns=labels

    return slice_UG, slice_EPP, slice_DPU, slice_TG, slice_Ri

#slice_UG, slice_EPP, slice_DPU, slice_TG, slice_Ri= openslicet(labels, 6)


def opensliceavg(labels):
    path2file = '/home/akh/channelized-pdcs/graphs/processed/'
    slicefid='_slice_x200_z150.txt'
    slice_EPP=pd.DataFrame()
    slice_UG=pd.DataFrame()
    slice_TG=pd.DataFrame()
    slice_Ri=pd.DataFrame()
    slice_DPU=pd.DataFrame()


    UG=[]
    EPP=[]
    TG=[]
    Ri=[]
    DPU=[]
    
    for sim in labels:
        sliceavg=pd.DataFrame()
        fid=path2file+sim
        loc=fid + slicefid
        slice_temp=pd.read_table(loc, header=None, sep= '\s+', skiprows=9)
        col = ['UG', 'DPU', 'TG', 'Ri' ]
        slice_temp.columns = ['time', 'YYY',  'EPP', 'UG', 'DPU', 'TG', 'Ri' ]

        height= slice_temp['YYY'].min()
        klength=int((456-height)/3 +1)
        height_flow= (slice_temp['YYY']-height)
        height_flow=height_flow[0:klength]


        # first split by timestep
        sliceavg=slice_temp[0:klength]
        tavg=0
        for t in range(1,9):
            bottom=(t-1)*klength
            top=t*klength
            df=slice_temp[bottom:top]
            if df.iloc[0,2] < 7.5:
            #add to average 
                tavg=tavg+1
                sliceavg = sliceavg+df.values
        # divide by time
        sliceavg=sliceavg/tavg
        sliceavg.reset_index(inplace=True, drop=True)

        UG.append(sliceavg['UG'])
        EPP.append(sliceavg['EPP'])
        TG.append(sliceavg['TG'])
        DPU.append(sliceavg['DPU'])
        Ri.append(sliceavg['Ri'])

        del sliceavg

    slice_UG=pd.concat(UG, axis=1, ignore_index=True)
    slice_EPP=pd.concat(EPP, axis=1, ignore_index=True)
    slice_TG=pd.concat(TG, axis=1, ignore_index=True)
    slice_DPU=pd.concat(DPU, axis=1, ignore_index=True)
    slice_Ri=pd.concat(Ri, axis=1, ignore_index=True)

    slice_UG.columns=labels
    slice_TG.columns=labels
    slice_EPP.columns=labels
    slice_DPU.columns=labels
    slice_Ri.columns=labels

    return slice_UG, slice_EPP, slice_DPU, slice_TG, slice_Ri

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
    avulsed=pd.DataFrame()
    avg_TG=pd.DataFrame()

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
        mass_temp.columns=['time', 'Total Mass (m^3)', 'Elutriated %', 'Med % ', 'Dense %', 'InChannel', ' Width', ' 0ScaleH', 'ScaleH', '2ScaleH']   
        gtscaleheight[sim]=mass_temp['ScaleH']
        inchannelmass[sim]=mass_temp['InChannel']
        avulsed[sim]=1-mass_temp['InChannel']

        # average
        loc=fid + avgf
        avg_temp=pd.read_fwf(loc, header=None, skiprows=9)
        avg_temp.columns = ['time', 'T_G','U_G','V_G','W_G','U_S1','DPU'  ]
        avg_UG[sim]=avg_temp['U_G']
        avg_TG[sim]=avg_temp['T_G']

    return ent, froude, avg_UG, avg_TG, gtscaleheight, inchannelmass, avulsed, front 
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

def plottogether(fid, df, xlab, ylab):
    time=['0','5','10','15','20','25','30','35', '40']
    fig1, ax1 = plt.subplots()
    ax1.set_xticklabels(time)
    sns.lineplot(data=df, palette=palette, dashes=False)
    ax1.set_xlabel(xlab)
    ax1.set_ylabel(ylab)
    ax1.set_xlim(left=0)
    savefigure(fid)

def plotcol(df, xlab, ylab):
    df1=df.fillna(14)
    fig1, ax1 = plt.subplots()
    sns.lineplot(data=df1, palette=palette, dashes=False)
    ax1.set_xlabel(xlab)
    ax1.set_ylabel(ylab)
    ax1.invert_yaxis() 

    plt.tight_layout()

def labelsubplots(axes):
    alpha=['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
    for i in range(len(axes)):
        text = axes[i].annotate(alpha[i], weight='bold', size=12, xy=(0.9, 0.9), xycoords="axes fraction")

def horizplot(df, loc, labels):
    maxy=(len(df))
    top=3*maxy
    height = np.arange(0,top,3)

    palette=sns.color_palette("coolwarm", len(labels))

    df1=df.fillna(df.min())
    for i in range(len(labels)):
        loc.plot(df1[labels[i]], height, label=labels[i], color=palette[i] )

def setgrl(fig, axes, h,l):

    #fontsll
    font_path="/usr/share/fonts/truetype/msttcorefonts"
    myfont= "arial.tff"
    plt.rcParams['font.family']='Arial'

    fig.set_figheight(h)
    fig.set_figwidth(l)

def savefigure(name):
    path= "/home/akh/channelized-pdcs/graphs/figures"
    fid=name + '.eps'
    plt.savefig(fid, format='eps', dpi=600)

def plotallcol(fid, df1, df2, df3, df4, df5):

    fig, axes= plt.subplots(1,4, sharey=True, sharex=False)
    setgrl(fig, axes, 4, 8)
    # EPP

    loc=axes[0]
    horizplot(df1, loc, labels)
    axes[0].set_ylabel('Height (m)', size=9)
    axes[0].set_xlabel('Log Volume fraction', size=9)
    loc.set_ylim([0,150])
    loc.set_xlim([1,8])
    sns.despine()
    # UG
    loc=axes[1]
    u0=10.0
    horizplot(df2/u0, loc, labels)    
    axes[1].set_xlabel('Velocity (U/U0)',size=9)
    loc.set_ylim([0,150])

    # Richardson Number 
    loc=axes[2]
    t0=800
    horizplot(df5/t0, loc, labels)
    axes[2].set_xlabel('Temperature (T/T0)', size=9)
    loc.set_ylim([0,150])

    # DPU
    loc=axes[3]
    df3= df3+0.000001
    dpu=np.log10(df3)
    horizplot(dpu, loc, labels)
    axes[3].set_xlabel('Dynamic Pressure', size=8)
    loc.set_ylim([0,150])

    # Richardson Number 
   # loc=axes[4]
   # horizplot(df4, loc, labels)
   # axes[4].set_xlabel('Richardson Number')
   # loc.set_xlim([-5, 5])
   # loc.set_ylim([0,150])



    fig.legend(    # The line objects
           labels=labels,   # The labels for each line
           loc="center right",   # Position of legend
           borderaxespad=0.5,    # Small spacing around legend box
           title="Geometries",  # Title for the legend
           )

    labelsubplots(axes)

    savefigure(fid)
    #plt.show()

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


ent, froude, avg_UG, avg_T, gtscaleheight, inchannelmass, avulsed, front = openlabel(labels)

#nfront=normalizebywave(front)
deltaV=entrain(ent)

ndeltaV=normalizebywidth(deltaV)
ndeltaV=normalizebydepth(ndeltaV)
plottogether("entrainmentall", deltaV, "Entrainment (m^3)", "Time")
#plottogether(froude)
plottogether('avgUG', avg_UG, "Average Velocity (U/UO)", "Time")
plottogether('Elutriatedmass', gtscaleheight, 'Elutriated Mass (%)', "Time")
plottogether('inchannel', inchannelmass, 'Mass in Channel (%)', 'Time')
plottogether('avulsed', 1-inchannelmass, 'Mass Avulsed (%)', 'Time')
#plottogether(front)
#plotbyfront(inchannelmass,nfront, "% Mass in Channel")
plottogether("normalizedentrainment", ndeltaV, "Time", "Entrainment Normalized by Cross Sectional Area")

#plotby(inchannelmass, avg_UG, "% Mass in Channel", "Entrainment")
#plotcol(slice_EPP, 'Height (m)', 'Log Volume Fraction Particles')
slice_UG, slice_EPP, slice_DPU, slice_TG, slice_Ri= opensliceavg(labels)
fid = 'avgcol_0917w0Ri'
plotallcol(fid, slice_EPP, slice_UG, slice_DPU, slice_Ri, slice_TG)
